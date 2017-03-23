if($env:IS_AUTO_DEPLOY -eq $null -or $env:IS_AUTO_DEPLOY -eq "false") { exit 0 }
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
    
    [array]$regexFunc = @()
    [array]$regexValues = @()
    [array]$regexNested = @()
    [array]$regexNestedFunc = @()

    [string]$runfile = ""
    [regex]$regex = $null
    [regex]$nRegex = $null

    #foreach($runfile in $sqlfiles.name) {
    $deployObjects | Sort-Object { $_.isFunction; $_.isNested } -DESC | Foreach {
    
        $runfile = $_.fileNameBuild
        $objectName = $_.objName
        $deployAliasName = $_.aliasName
        $deployDbName = $_.dbName
        $objFunction = $_.isFunction

        #GET script file path
        $scriptFile = "${depDir}\${runfile}"              

        #GET target version
        $objectNameVersion = $objectName + $targetVersion 
        Write-Host "Tartget version: from ${objectName} to ${objectNameVersion}"

        #Expression to replace to target
        $regexValues = @(@{"expression" ="${objectName}`n"},@{"expression" = "${objectName}[\s]"},@{"expression" ="[\[]${objectName}[\]]"})
        $regexFunc = @(@{"expression" = "${objectName}[\s+\(]"},@{"expression" = "[\[]${objectName}]\s+\("})

        $SQLConnection = New-Object System.Data.SqlClient.SqlConnection 
        #$SQLConnection.ConnectionTimeout = 30

        #$SQLCommandText
        $SQLCommandText = @(Get-Content -Path $scriptFile -Encoding UTF8)
        
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
                        $regexValues | foreach {
                            $regex = new-object System.Text.RegularExpressions.Regex ($_.expression, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                            if($regex.IsMatch($SQLPacket) -eq 1)
                            {
                                if($_.expression.IndexOf("`n") -gt -1) {
                                    $SQLPacket = $regex.Replace($SQLPacket, "[${objectNameVersion}]`n")
                                } else {
                                    $SQLPacket = $regex.Replace($SQLPacket, "[${objectNameVersion}]")
                                }
                            }
                        }
                        IF($objFunction -eq 1) {
                            $regexFunc | foreach {
                                $regex = new-object System.Text.RegularExpressions.Regex ($_.expression, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                                if($regex.IsMatch($SQLPacket) -eq 1)
                                {
                                    $SQLPacket = $regex.Replace($SQLPacket, "[${objectNameVersion}](")
                                }
                            }
                        }

                        #Process Nested Calling
                        IF($SQLPacket.IndexOf('PROCEDURE') -gt -1)
                        {
                            #Process nested calling
                            #$deployObjects | Where-Object {$_.objName -ne $objectName -and ($_.isFunction -eq 1 -or $_.isNested -eq 1) } | Foreach 
                            $deployObjects | Foreach {

                                $nestedName = $_.objName
                                $nestedVersion = "${nestedName}${targetVersion}"

                                $regexNested = @(@{"expression" ="${nestedName}`n"},@{"expression" = "${nestedName}[\s]"},@{"expression" ="[\[]${nestedName}[\]]"},@{"expression" ="${nestedName}[\)]"})
                                #Replace to Target version
                                $regexNested | foreach {
                                    $nRegex = new-object System.Text.RegularExpressions.Regex ($_.expression, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                                    if($nRegex.IsMatch($SQLPacket) -eq 1)
                                    {
                                        if($_.expression.IndexOf("`n") -gt -1) {
                                            $SQLPacket = $nRegex.Replace($SQLPacket, "[${nestedVersion}]`n")
                                        } else {
                                            $SQLPacket = $nRegex.Replace($SQLPacket, "[${nestedVersion}]`n")
                                        }
                                    }
                                }
                                #Replace for function
                                IF($_.isFunction -eq 1) {
                                    $regexNestedFunc = @(@{"expression" = "${nestedName}[\s+\(]"},@{"expression" = "[\[]${nestedName}]\s+\("})
                                    $regexNestedFunc | foreach {
                                        $nRegex = new-object System.Text.RegularExpressions.Regex ($_.expression, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                                        if($nRegex.IsMatch($SQLPacket) -eq 1)
                                        {
                                            $SQLPacket = $nRegex.Replace($SQLPacket, "[${nestedVersion}](")
                                        }
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
    $Error[0]
    exit 1
}