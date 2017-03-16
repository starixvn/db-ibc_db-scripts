#Implement SQL CodeGuard Validation
[string]$CodeGuardPath = "$buildPath\CodeGuard_Validation.xml"
[string]$excludeCodes = "ST010;DEP023;SC003;PE006;DEP023;MI003;ST006;EI025;EI025;DEP013;BP016;BP014"
try
{
    \\10.18.200.200\Users\1.DB_Team\DB_Deployment\SqlCodeGuard\SqlCodeGuard.Cmd.exe -source $buildPath -out $CodeGuardPath -quiet -include "ALL;CGUNP" -exclude "${excludeCodes}"

    #Write to Jenkin Console Output
    Write-Host "WARNING: ============SQLCodeGuard Validation==================="
    $CodeGuardOutput = @(Get-Content -Path $CodeGuardPath)
    Write-Output $CodeGuardOutput
} 
catch 
{
    $Error
    exist 1
}