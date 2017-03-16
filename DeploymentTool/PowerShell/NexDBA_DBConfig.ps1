$global:servers = @{}
#DEVELOPMENT: server alias config
$servers.Add("DEV", @{
                    "Servers" = @(
                                    @{"DBTXN" = @{"IP" = "10.18.200.230"; "Databases" = @("bodb02","DBCust") }}
                                  , @{"DBPRO" = @{"IP" = "10.18.200.230"; "Databases" = @("bodb02") }}
                                  , @{"DBLOG" = @{"IP" = "10.18.200.231"; "Databases" = @("bodb_CustomerLog") }}
                                  , @{"DBAGE" = @{"IP" = "10.18.200.231"; "Databases" = @("bodb02") }}
                                );
                    "SQLDeployer" = @{"username" = "dbateam"; "password" = "@bigboy#"}
                  }
            );

#LOCAL: server alias config
$servers.Add("LOCAL", @{
                    "Servers" = @(
                                    @{"DBTXN" = @{"IP" = "10.18.200.206"; "Databases" = @("bodb02","DBCust") }}
                                  , @{"DBPRO" = @{"IP" = "10.18.200.206"; "Databases" = @("bodb02") }}
                                  , @{"DBLOG" = @{"IP" = "10.18.200.215"; "Databases" = @("bodb_CustomerLog") }}
                                  , @{"DBAGE" = @{"IP" = "10.18.200.215"; "Databases" = @("bodb02") }}
                                );
                    "SQLDeployer" = @{"username" = "dbateam"; "password" = "@bigboy#"}
                  }
            );

#OBJECT: target version config
$global:configVersion = @{"XTEST" = "_Xtest"; "XPRE" = "_Xpre"; "UAT1" = "_UAT1"; "UAT2" = "_UAT2"; "UAT3" = "_UAT3"; "UAT4" = "_UAT4"; "OGRINAL" = ""}