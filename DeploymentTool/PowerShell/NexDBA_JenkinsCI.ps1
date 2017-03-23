[string]$packagePath  = "\\10.18.200.200\Users\1.DB_Team\DB_Deployment\Packages"
if($env:PACKAGE_PATH -ne $null -and $env:PACKAGE_PATH.Length -gt 0)
{
    $packagePath = $env:PACKAGE_PATH
}
[string]$branchName = $env:BRANCH_NAME
[string]$branchNameShort = $env:PACKAGE_NAME
[string]$projName = $env:JOB_BASE_NAME
[string]$repoDir = "D:\Jenkins\workspace\$projName"
[string]$dateVersion = get-date -format yyyyMMdd-HHmmss
[string]$packageName = "$dateVersion-$branchNameShort"
[string]$buildPath = "$packagePath\$projName\$branchName\$packageName"

#ignore master branch
if($branchName -eq "master" -or $branchName.Length -eq 0) { exit 0 }

#Check DB patch
if ((Test-Path -Path “$packagePath\$projName”) -ne “true”)
{
    new-item -type directory -name “$projName” -path “$packagePath”
}

#Check Branch patch
if ((Test-Path -Path “$packagePath\$projName\$branchName”) -ne “true”)
{
    new-item -type directory -name “$branchName” -path “$packagePath\$projName”
}


#check $buildPath
if ((Test-Path -Path “$buildPath”) -ne “true”)
{
    new-item -type directory -name $packageName -path “$packagePath\$projName\$branchName”
} 

$DiffFileName = $buildPath + "\" + "ReleaseLog.txt"

#Write-Host "repoDir: $repoDir"

cd "$repoDir"
#reset master branch
#git.exe checkout master -f
git.exe branch --force master origin/master
#reset branch to build
#git.exe checkout $branchName -f
git.exe branch --force $branchName origin/$branchName
#get list file changed to deploy
git.exe diff --name-status master.."$branchName" > $DiffFileName 

#Write-Host "DiffFileName: $DiffFileName"

#hard code failed
#exit 1 

#load PS script to create DB package
. "\\10.18.200.200\Users\1.DB_Team\DB_Deployment\PowerShell\NexDBA_CreatePackage.ps1"