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

$ReleaseLog = $(Get-Content -path $DiffFileName)

#check has UnchangedSPs or not
CheckUnchangedSPs $ReleaseLog

#Write-Host "hasUnchangedSPs: $hasUnchangedSPs"

if($hasUnchangedSPs -eq 1)
{
    $UnchangedSPsPath = $repoDir + "\" + $unchangedSPsFile
    $ReleaseLog += @(Get-Content -path $UnchangedSPsPath)
}

[int]$fileCount = 1
[string]$BaseName = $null
[string]$fileExt = $null
[array]$aliasInfo = $null
[string]$aliasName = $null
[string]$dbName = $null

Write-Host "----------------------------------"
Write-Host "Creating database package."
foreach ($fileName in $ReleaseLog)
{
    $fileDir = "$repoDir\$fileName"
    $fileAttr = dir $fileDir
    
    $BaseName = $fileAttr.BaseName.Replace("dbo.","").Replace(".func","").Replace(".proc","").Replace(".StoredProcedure", "").Replace(".Function", "")
    $fileExt = $fileAttr.Extension

    if($fileExt -ne ".sql"){ continue }

    #Write-Host "fileDir: $fileDir"
    try 
    {   
        $cont = @(Get-Content -path $fileDir -encoding UTF8)
        $meta = $cont.Get(0) #is the first line
        $xmlData = $meta.Replace("/*", "").Replace("*/", "")
      
        $serverAlias = $xmlData.info.serverAlias.Split(",")
        $isFunction = $xmlData.info.isFunction
        $execPermissions = $xmlData.info.executers
        $viewPermissions = $xmlData.info.viewers

        $fileNameConfig =  $BaseName

        if($isFunction -eq 1)
        {
            $fileNameConfig +=  "-x-func-x-"
        }

        # Get account permission
        $global:objectsPermission = @("")
        GetObjectPermission $execPermissions $viewPermissions
        #Write-Host "Global objectsPermission: $global:objectsPermission"
        
        foreach($configKey IN $serverAlias)
        {
            #START auto-deployment config
            $aliasInfo = $configKey.Split("-")
            $aliasName = $aliasInfo.Get(0)
            $dbName = $aliasInfo.Get(1)
            
            if($deployObjects.Where({$_.aliasName -eq $aliasName -and $_.dbName -eq $dbName -and $_.objName -eq $BaseName}).objName.Length -eq 0) {
                $deployObjects += @{ "objName" = $BaseName; "aliasName" = $aliasName;  "dbName" = $dbName; "isFunction" = $isFunction }
            }
            #END auto-deployment config

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
            
            #Copy file to DB package
            #Copy-Item $fileDir $fileBuild

            #Write to build file
            if($cont[0..4].Contains("SET ANSI_NULLS ON") -eq 0) {
                $arrMeta = @($cont.Get(0),"SET ANSI_NULLS ON","GO", "SET QUOTED_IDENTIFIER ON", "GO")
                $cont.Set(0, $arrMeta)
            }
            #Set object permission
            if( $global:objectsPermission.Count -gt 0 ) 
            {
                if(@($cont | Select-Object -last  5).Contains("GO") -ne 1) {
                    $global:objectsPermission.Set(0, "GO")
                }
                $cont += $global:objectsPermission
            }
            #write output build file
            Write-Host "fileBuild-${fileCount}: $fileBuild"
            $cont | Out-File $fileBuild -Encoding UTF8
        }
        $fileCount += 1
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

    #EXPORT excel 
    [string]$excelPathFile = "${buildPath}\${dateVersion}-${branchNameShort}.csv"
    $columns = [ordered]@{}
    &{$deployObjects.getenumerator() | foreach {
            $columns["ServerName"]=$_.aliasName 
            $columns["DBName"] = $_.dbName
            $columns["SPName"] = $_.objName
            $columns["IsFunction"] = $_.isFunction
            $columns["Version"] = ""
            New-Object -Type PSObject -Property $columns
        }
    } | export-CSV -Path $excelPathFile -UseCulture -Encoding UTF8 -NoTypeInformation

    #CLEAR Old build version - just keeping the latest one 
    Get-ChildItem “${packagePath}\${projName}\${branchName}” | Where-Object { $_.PSIsContainer } |Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
}
else 
{
    Write-Host "Created database package failed."
    Write-Host "--------------------------------"
    Remove-Item -Recurse -Force "${buildPath}"
    if($Error[0].Exception.Message.IndexOf("XmlDocument") -gt -1)
    {
        $errorMessage =  "The meta data of the file [${BaseName}] is not available. The formation likes <info serverAlias='aliasName-dbname' executers='account-name' viewers='account-name' isFunction='0|1' isNested = '0|1' />"
    }
    else #unhandle error exception
    {
        $errorMessage = $Error[0].Exception.Message
    }
    Write-Host "Error message: ${errorMessage}"
    exit 1 #exit build process with failed
}