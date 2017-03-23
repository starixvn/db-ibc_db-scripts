#Set-Variable -Name $varName -Value ($a + $b) -Scope Global
function CheckUnchangedSPs ( $changedFiles )
{   
    $fileItems = @()
    try 
    {
        $fileItems += $changedFiles | Where-Object { $_.FileName.IndexOf("UnchangedSPs.txt") -gt -1 }
        IF($fileItems.Count -gt 0) {
            $global:hasUnchangedSPs = 1
            $global:unchangedSPsFile = $fileItems.Get(0).FileName
        }
    }
    catch
    {
        #Write-Error 'Detecting unchanged SPs failed.'
        Write-Error $Error[0]
        exit 1
    }
}

function GetObjectPermission($execPermissions, $viewPermissions)
{
    
    #Write-Host "Function execPermissions: " $execPermissions

    [string]$objectName = $BaseName
    [array]$executers = @()
    [array]$viwers = @()

    if($execPermissions -ne $null)
    {
        $executers = $execPermissions.Split(",")
    }

    if($viewPermissions -ne $null)
    {
        $viwers = $viewPermissions.Split(",")
    }


    [string] $account = ""

    #grant EXECUTE permission
    if($executers.Count -gt 0)
    {
        #$executers.Count
        foreach($account in $executers)
        {
            #$account.Length
            if($account.Length -gt 0) {
                $global:objectsPermission += @("GRANT EXECUTE ON [dbo].[" + $objectName + "] TO [" + $account  + "] AS [dbo]")
                $global:objectsPermission += @("GO")
            }
        }
    }

    #grant VIEW DEFINITION permission
    if($viwers.Count -gt 0)
    {
        foreach($account in $viwers)
        {
            if($account.Length -gt 0) {
                $global:objectsPermission += @("GRANT VIEW DEFINITION ON [dbo].[" + $objectName + "] TO [" + $account + "] AS [dbo]")
                $global:objectsPermission += @("GO")
            }
        }
    }
}

function ProcessNestedCalling ($SQLPacket, $objectName, $targetVersion)
{
    #$objectName
    #$targetVersion

    [array]$global:listObjects = @()

    $global:depConfig.Keys | foreach ({

        $aliasName = $_

        $global:depConfig.$aliasName.Keys | foreach ({

            $dbName = $_

            $global:depConfig.$aliasName.$dbName.Objects | foreach ({
                if($listObjects.Contains($_.objName) -eq 0 ) {
                    $listObjects += $_.objName
                }
            })
        })
    });

    #$listObjects
    
    #$SQLPacket

    $listObjects | foreach({
        #$_
        if($SQLPacket.IndexOf($_) -gt -1) {
            $_
            $SQLPacket = $SQLPacket.Replace("[" + $_ + "]", "[" + $_ + $targetVersion + "]")
            #$SQLPacket = $SQLPacket.Replace($_.objName + "(", $_.objName + $targetVersion + "(") #replace function
        }
    });

    #$SQLPacket
}