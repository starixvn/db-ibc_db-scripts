if($env:IS_AUTO_DEPLOY -eq "false") { exit 0 }
Write-Host "----------------------------" 
Write-Host "Auto Deployment Process is running..." 

#build enviroment variables
. \\10.18.200.200\Users\1.DB_Team\DB_Deployment\PowerShell\NexDBA_DBConfig.ps1

$depEnv = $env:TARGET_ENV
$depVersion = $env:TARGET_VERSION
$depDir = $buildPath
$packageName = $branchNameShort

#$deployObjects.Where({$_.objName -eq "NAP_Set_AutoPayout_MatchInfo"})

try 
{
    [string]$scriptFile = $null
    [string]$targetVersion = $configVersion.$depVersion
    [string]$deployAliasName = $null
    [string]$deployDbName = $null
    [string]$objectName = $null
    [string]$objectNameVersion = $null
    [string]$SQLPacket = $null
    [string]$aliasName = $null
    [string]$dbName = $null
    [string]$objName = $null
    [string]$keySearch = $null
    [string]$keyReplace = $null
    [int]$depCount = 1

    $sqlfiles = get-childitem $depDir

    foreach($runfile in $sqlfiles.name) 
    {
    
        if($runfile.IndexOf(".sql") -eq -1) { continue }

        $scriptFile = "${depDir}\${runfile}"
        #Write-Host "Script File: ${scriptFile}"

        $fileAttr = dir $scriptFile

        $objectName = $fileAttr.BaseName.Replace("dbo.","").Replace(".func","").Replace(".proc","")
        $objectName = $objectName.Substring($objectName.IndexOf("-${packageName}-")+6)

        #GET target version
        $objectNameVersion = $objectName + $targetVersion

 
        Write-Host "Tartget version: from ${objectName} to ${objectNameVersion}"
        #continue

        $SQLConnection = New-Object System.Data.SqlClient.SqlConnection 
        #$SQLConnection.ConnectionTimeout = 30

        #$SQLCommandText
        $SQLCommandText = @(Get-Content -Path $scriptFile -Encoding UTF8)
        
        $pathInfo = $runfile.Split("-")
                
        $deployAliasName = $pathInfo.Get(2).ToString() 
        $deployDbName = $pathInfo.Get(3).ToString() 

        #Write-Host "Alias Info: ${aliasName}-${dbName}"
        $serverIP = $servers.$depEnv.Servers.$deployAliasName.IP
        $user = $servers.$depEnv.SQLDeployer.username
        $pwd = $servers.$depEnv.SQLDeployer.password

        #Connect to MS SQL Server 
        $SQLConnection.ConnectionString = "Server=" + $serverIP + ";Database="  + $deployDbName + ";User ID= "  + $user + ";Password="  + $pwd + ";" 
        #Write-Host "$aliasName -" $SQLConnection.ConnectionString 

        #TODO
        $SQLPacket = ""
        foreach($SQLStatement in  $SQLCommandText) 
        { 
            if($SQLStatement.Replace(" ", "") -ne "GO") 
            { 
                #Preparation of SQL packet 
                $SQLPacket += $SQLStatement + "`n" 
            } 
            else 
            { 
                if ($SQLPacket.Length -gt 0) 
                {
                    $hasExisted = 0
                    $SQLCommand = New-Object System.Data.SqlClient.SqlCommand("SELECT TOP 1 1 FROM sysobjects WHERE name='${objectNameVersion}'", $SQLConnection)
                    IF($SQLPacket.IndexOf('PROCEDURE') -gt -1 -OR $SQLPacket.IndexOf('FUNCTION') -gt -1)
                    {
                        #Write-Host "SELECT TOP 1 1 FROM sysobjects WHERE name='${objectNameVersion}'"
                        if($SQLConnection.State -eq 'Closed') { $SQLConnection.Open() }
                        $hasExisted = $SQLCommand.ExecuteScalar()
                    }

                    #$hasExisted

                    if($hasExisted -gt 0){
                          
                        $SQLPacket = $SQLPacket.Replace("CREATE PROCEDURE", "ALTER PROCEDURE")
                        $SQLPacket = $SQLPacket.Replace("CREATE FUNCTION", "ALTER FUNCTION")
                        #Write-Host 'ALTER'
                    }
                    ELSE
                    {
                        $SQLPacket = $SQLPacket.Replace("ALTER PROCEDURE", "CREATE PROCEDURE")
                        $SQLPacket = $SQLPacket.Replace("ALTER FUNCTION", "CREATE FUNCTION")
                        #Write-Host 'CREATE'
                    }

                    #RUN CREATE/ALTER
                    #$SQLCommand = New-Object System.Data.SqlClient.SqlCommand($SQLPacket, $SQLConnection)
                    #$SQLCommand.Connection = $SQLConnection 
                    #-OR $SQLPacket.IndexOf('GRANT') -gt -1
                    IF($SQLPacket.IndexOf('PROCEDURE') -gt -1 -OR $SQLPacket.IndexOf('FUNCTION') -gt -1 -OR $SQLPacket.IndexOf('GRANT') -gt -1)
                    {
                        #Deploy to Target version
                        $SQLPacket = $SQLPacket.Replace("[${objectName}]", "[${objectNameVersion}]")

                        #Process Nested Calling
                        IF($SQLPacket.IndexOf('PROCEDURE') -gt -1)
                        {
                            #nested calling
                            #ProcessNestedCalling($SQLPacket, $objectName, $targetVersion)
                            foreach($obj IN $deployObjects)
                            {
                                $aliasName = $obj.aliasName
                                $dbName = $obj.dbName
                                $objName = $obj.objName

                                if($SQLPacket.IndexOf($objName) -gt -1 -and $objName -ne $objectName) {
                                    
                                    #Replace cross server & database
                                    #1
                                    $keySearch = "[${aliasName}].[${dbName}].[dbo].[${objName}]"
                                    $keyReplace = "[${aliasName}].[${dbName}].[dbo].[${objName}$targetVersion]"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #2
                                    $keySearch = "${aliasName}.${dbName}.dbo.${objName}"
                                    $keyReplace = "${aliasName}.${dbName}.dbo.${objName}$targetVersion"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #3
                                    $keySearch = "${aliasName}.${dbName}.dbo.${objName}`n"
                                    $keyReplace = "${aliasName}.${dbName}.dbo.${objName}$targetVersion`n"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #4
                                    $keySearch = "${aliasName}.${dbName}.dbo.${objName} "
                                    $keyReplace = "${aliasName}.${dbName}.dbo.${objName}$targetVersion "
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }

                                    #Replace cross database
                                    #5
                                    $keySearch = "[${dbName}].[dbo].[${objName}]"
                                    $keyReplace = "[${dbName}].[dbo].[${objName}$targetVersion]"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #6
                                    $keySearch = "${dbName}.dbo.${objName}"
                                    $keyReplace = "${dbName}.dbo.${objName}${targetVersion}"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }

                                    #7
                                    $keySearch = "${dbName}.dbo.${objName}`n"
                                    $keyReplace = "${dbName}.dbo.${objName}${targetVersion}`n"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #8
                                    $keySearch = "${dbName}.dbo.${objName} "
                                    $keyReplace = "${dbName}.dbo.${objName}${targetVersion} "
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }


                                    #Replace same database
                                    #9
                                    $keySearch = "[dbo].[${objName}]"
                                    $keyReplace = "[dbo].[${objName}${targetVersion}]"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #10
                                    $keySearch = "dbo.${objName}"
                                    $keyReplace = "dbo.${objName}${targetVersion}"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #11
                                    $keySearch = "[${objName}]"
                                    $keyReplace = "[${objName}${targetVersion}]"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #12
                                    $keySearch = "${objName}`n"
                                    $keyReplace = "${objName}${targetVersion}`n"
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                    #13
                                    $keySearch = "${objName} "
                                    $keyReplace = "${objName}${targetVersion} "
                                    if($SQLPacket.IndexOf($keyReplace) -eq -1) {
                                        $SQLPacket = $SQLPacket.Replace($keySearch, $keyReplace)
                                    }
                                }
                            }
                        }

                        if($SQLConnection.State -eq 'Closed') { $SQLConnection.Open() }
                        $SQLCommand.CommandText = $SQLPacket
                        $SQLCommand.ExecuteScalar()

                        #OUTPUT deployed object
                        IF($SQLPacket.IndexOf('PROCEDURE') -gt -1 -OR $SQLPacket.IndexOf('FUNCTION') -gt -1) {
                            Write-Host "Deployed-${depCount}: $deployAliasName-${deployDbName}-${objectNameVersion} successfully."
                            $depCount += 1
                        }
                    }
                    #RESET Packet
                    $SQLPacket = ""
                    #$SQLCommand.Dispose()
                }
            }
        }        
    }

    if($SQLConnection.State -eq 'Open') { $SQLConnection.Close() } 
    Write-Host "Auto Deployment Process has been completed." 
}
catch
{
    Write-Host "Auto Deployment Process has been failed at the object [${deployAliasName}-${deployDbName}-${objectNameVersion}]." 
    if($SQLConnection.State -eq 'Open') { $SQLConnection.Close() }
    $Error
    exit 1
}