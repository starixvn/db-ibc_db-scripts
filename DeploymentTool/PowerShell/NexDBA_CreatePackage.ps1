#DBA - Create DB package
#=========================
#load PS utils scripts
. \\10.18.200.200\Users\1.DB_Team\DB_Deployment\PowerShell\NexDBA_Utils.ps1

#$PSVersionTable

[hashtable]$config = @{}
[array]$deployObjects = @()

[string]$meta = ""
[xml]$xmlData = "<info />"
[string]$serverAlias = ""
[int]$errorCode = 0
[string]$errorMessage = ""

[boolean]$global:hasUnchangedSPs = 0
[string]$global:unchangedSPsFile = $null
[string]$global:FilePermission = $null
$global:objectsPermission = $null

$ReleaseLog = @()

$ReleaseDiff = $(Get-Content -path $DiffFileName -Encoding UTF8)
$ReleaseDiff | Where-Object ({$_.Length -gt 0 -and $_.Substring(0,1) -ne 'D'}) | foreach({
    $fileName = $_.Replace(" ", "").Substring(2)
    $ReleaseLog += @{"FileName" = $fileName; "Action" = $_.Substring(0,1).Replace('M', 'E') }
})

#check has UnchangedSPs or not
CheckUnchangedSPs $ReleaseLog
Write-Host "hasUnchangedSPs: $hasUnchangedSPs"
if($hasUnchangedSPs -eq 1)
{
    $UnchangedSPsPath = $repoDir + "\" + $unchangedSPsFile
    $ReleaseNone = @(Get-Content -path $UnchangedSPsPath -Encoding UTF8)
    $ReleaseNone | Where-Object ({$_.Length -gt 0 }) | foreach ({
        $fileName = $_.Replace(" ", "")
        $ReleaseLog += @{"FileName" = $fileName; "Action" = "None" }
    })
}

[int]$fileCount = 1
[string]$BaseName = $null
[string]$fileExt = $null
[array]$aliasInfo = $null
[string]$aliasName = $null
[string]$dbName = $null
[string]$developer = $null
[regex]$regexDev = new-object System.Text.RegularExpressions.Regex ('[0-9]\d{4,10}@\w*', [System.Text.RegularExpressions.RegexOptions]::MultiLine)

Write-Host "----------------------------------"
Write-Host "Creating database package."

foreach ($fileItem in $ReleaseLog)
{
    try
    {
        $fileName = $fileItem.FileName
        $fileAction = $fileItem.Action
        $fileDir = "$repoDir\$fileName"
        $fileAttr = dir $fileDir
        $BaseName = $fileAttr.BaseName.Replace("dbo.","").Replace(".func","").Replace(".proc","").Replace(".StoredProcedure", "").Replace(".Function", "")     
        $fileExt = $fileAttr.Extension

        #Write-Host "fileDir: $fileDir"
        if($fileExt -ne ".sql" -or $fileName.IndexOf("DataPatch") -gt -1 -or $fileName.IndexOf(".script") -gt -1) 
        { 
            #Copy original file to DB package
            Copy-Item $fileDir "${buildPath}\${dateVersion}-${branchNameShort}-${BaseName}${fileExt}"
            continue 
        }

        $cont = @(Get-Content -path $fileDir -encoding UTF8)
        $meta = $cont.Get(0) #is the first line
        $xmlData = $meta.Replace("/*", "").Replace("*/", "")
      
        #GET db-server info
        $serverAlias = @()
        $aliasData = $xmlData.info.serverAlias
        if($aliasData -eq $null -or $aliasData.Length -eq 0) {
            
            $errorCode = 2
            break
        }
        else
        {
            $serverAlias = $aliasData.Split(",")
        }

        #GET function or Store Procedure object
        $isFunction = $xmlData.info.isFunction
        if($isFunction -eq $null) { $isFunction = 0 }

        #GET EXEC permission
        $execPermissions = $xmlData.info.executers
        if($execPermissions -eq $null) { $execPermissions = "" }

        #GET VIEW permission
        $viewPermissions = $xmlData.info.viewers
        if($viewPermissions -eq $null) { $viewPermissions = "" }

        #GET nested calling 
        $isNested = $xmlData.info.isNested
        if($isNested -eq $null) { $isNested = 0 }

        $fileNameConfig =  $BaseName

        if($isFunction -eq 1)
        {
            $fileNameConfig +=  "-x-func-x-"
        }

        # Get account permission
        $global:objectsPermission = @("")
        GetObjectPermission $execPermissions $viewPermissions
        #Write-Host "Global objectsPermission: $global:objectsPermission"
        
        #REPLACE meta-data
        if($cont[0..4].Contains("SET ANSI_NULLS ON") -eq 0) {
            $arrMeta = @($cont.Get(0),"SET ANSI_NULLS ON","GO", "SET QUOTED_IDENTIFIER ON", "GO")
            $cont.Set(0, $arrMeta)
        }
        #Set object permission
        if( $global:objectsPermission.Count -gt 0 ) 
        {
            if(@($cont | Select-Object -last 1).Contains("GO") -ne 1) {
                $global:objectsPermission.Set(0, "GO")
            }
            $cont += $global:objectsPermission
        }

        #GET lastest developer
        try {
            $developer = ""
            [int]$revisionsIdx = @(0..($cont.Count -1) | Where { $cont[$_].IndexOf("Revisions") -gt -1 }) | Select-Object -First 1
            $developer = $regexDev.Match(($cont[$revisionsIdx..($revisionsIdx+100)] | Where-Object ({$regexDev.IsMatch($_) -eq 1 }) | Select-Object -Last 1)).Value.Split('@').Get(1)
        }
        catch {
            #ignorge this error
        }

        foreach($configKey IN $serverAlias)
        {        
            #manual deployment tool
            if($config.ContainsKey($configKey) -eq 1)
            {
                $config[$configKey] += ",$fileNameConfig"
            }
            else
            {
                $config.Add($configKey,$fileNameConfig)
            }
    
            $fileNameBuild = "$dateVersion-$configKey-$branchNameShort-$BaseName$fileExt"
            $fileBuild = $buildPath + "\" + $fileNameBuild
            
            #START auto-deployment config
            $aliasInfo = $configKey.Split("-")
            $aliasName = $aliasInfo.Get(0)
            $dbName = $aliasInfo.Get(1)
            
            if($deployObjects.Where({$_.aliasName -eq $aliasName -and $_.dbName -eq $dbName -and $_.objName -eq $BaseName}).objName.Length -eq 0) {
                $deployObjects += @{ "objName" = $BaseName; "aliasName" = $aliasName;  "dbName" = $dbName; "isFunction" = $isFunction; "action" = $fileAction; "isNested" = $isNested; "developer" = $developer; "fileNameBuild" = $fileNameBuild }
            }
            #END auto-deployment config

            #write output build file
            Write-Host "fileBuild-${fileCount}: $fileBuild"
            $cont | Out-File $fileBuild -Encoding UTF8

            #SET file count
            $fileCount += 1
        }
        
    }
    catch 
    {
        $errorCode = 1
        break
    }
}

#Write-out config file for the manual Deployment Tool
[string]$configValue = $null
[string]$fileConfig = $null
if($errorCode -eq 0)
{
    #write to config file
    $fileConfig = $buildPath + "\" + "$dateVersion-$branchNameShort" + ".config"
    foreach($item in $config.Keys)
    {
        $configValue = $item + ":" + $config[$item].ToString()
        if($cntItem -eq 0)
        {
            #write-host 'Create file:'
            $configValue | Out-File $fileConfig -Encoding UTF8
        
        }
        else
        {
            #write-host 'Append file:'
            $configValue | Out-File $fileConfig -Encoding UTF8 -Append
        }
        $cntItem += 1
    } 

    Write-Host "Created database package successfully."

    #checking validation code with SQL CodeGuard
    . \\10.18.200.200\Users\1.DB_Team\DB_Deployment\PowerShell\NexDBA_SqlCodeGuard.ps1

    #run auto-deployemet tool
    . \\10.18.200.200\Users\1.DB_Team\DB_Deployment\PowerShell\NexDBA_AutoDeployment.ps1

    try 
    {
        #EXPORT excel - package template 
        [string]$excelPathFile = "${buildPath}\${dateVersion}-${branchNameShort}-SPList.csv"
        $columns = [ordered]@{}
        &{$deployObjects.getenumerator() | foreach {
                $columns["ServerName"] = $_.aliasName 
                $columns["DBName"] = $_.dbName
                $columns["SPName"] = $_.objName
                $columns["IsFunction"] = $_.isFunction
                $columns["Version"] = ""
                New-Object -Type PSObject -Property $columns
            }
        } | export-CSV -Path $excelPathFile -UseCulture -Encoding UTF8 -NoTypeInformation

        #EXPORT excel - NDICT import SPs template file
        [string]$importSPsFile = "${buildPath}\${dateVersion}-${branchNameShort}-NDICT-ImportSPs.csv"
        [regex]$regexIssue = new-object System.Text.RegularExpressions.Regex ('[0-9]\d{1,10}', [System.Text.RegularExpressions.RegexOptions]::MultiLine)
        [string]$issueId  = $regexIssue.Match($branchName).Value
        $import = [ordered]@{}
        &{$deployObjects.getenumerator() | foreach {
                $import["IssueId"] = $issueId
                $import["SPName"] = $_.objName
                $import["AliasServer"] = $_.aliasName 
                $import["Database"] = $_.dbName
                if($_.isFunction -eq 1) {
                    $import["Type"] =  'Func'
                } else {
                    $import["Type"] =  'SP'
                }
                $import["Developer"] = $_.developer
                $import["Action"] = $_.action
                $import["Status"] = "Done"
                $import["Version"] = "original"
                $import["CallByWeb"] = "0"
                $import["CallByExecRef"] = "0"
                $import["Description"] = ""
                New-Object -Type PSObject -Property $import
            }
        } | export-CSV -Path $importSPsFile -UseCulture -Encoding UTF8 -NoTypeInformation
    }
    catch {
        Wtire-Host "Exporting SPs template file has failed."
    }
    #CLEAR Old build version - just keeping the latest one 
    Get-ChildItem “${packagePath}\${projName}\${branchName}” | Where-Object { $_.PSIsContainer } | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
}
else 
{
    Write-Host "Created database package failed."
    Write-Host "--------------------------------"
    Remove-Item -Recurse -Force "${buildPath}"
    if($errorCode = 2)
    {
        $errorMessage =  "The alias server information of the file [${BaseName}] is not available."
    }
    else 
    {
        if($Error[0].Exception.Message.IndexOf("XmlDocument") -gt -1)
        {
            $errorMessage =  "The meta data of the file [${BaseName}] is not available. The formation likes <info serverAlias='aliasName-dbname' executers='account-name' viewers='account-name' isFunction='0|1' isNested = '0|1' />"
        }
        else #unhandle error exception
        {
            $errorMessage = $Error[0].Exception.Message
        }
    }
    Write-Host "Error message: ${errorMessage}"
    exit 1 #exit build process with failed
}