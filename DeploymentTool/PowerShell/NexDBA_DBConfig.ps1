$global:servers = @{}
#DEVELOPMENT: server alias config
$servers.Add("DEV", @{
                    "Servers" = @(
                                    @{"DBTXN" = @{"IP" = "10.18.200.230"; "Databases" = @("bodb02","DBCust") }}
                                  , @{"DBPRO" = @{"IP" = "10.18.200.230"; "Databases" = @("bodb02") }}
                                  , @{"DBLOG" = @{"IP" = "10.18.200.231"; "Databases" = @("bodb_CustomerLog") }}
                                  , @{"DBAGE" = @{"IP" = "10.18.200.231"; "Databases" = @("bodb02") }}
                                  , @{"DBACC" = @{"IP" = "10.18.200.232"; "Databases" = @("bodb02") }}
                                  , @{"DBAGE" = @{"IP" = "10.18.200.231"; "Databases" = @("bodb02") }}
                                  , @{"DBARC" = @{"IP" = "10.18.200.232"; "Databases" = @("bodb02") }}
                                  , @{"DBLIC" = @{"IP" = "10.18.200.231"; "Databases" = @("bodb_licensee") }}
                                  , @{"DBEXT" = @{"IP" = "10.18.200.231"; "Databases" = @("bodb02") }}
                                  , @{"DBCUST" = @{"IP" = "10.18.200.230\sqlserver2008R2"; "Databases" = @("custdb") }}
                                  , @{"DBMSG" = @{"IP" = "10.18.200.232"; "Databases" = @("bodb_message") }}
                                  , @{"DBRPT" = @{"IP" = "10.18.200.232"; "Databases" = @("bodb_report") }}
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
                                  , @{"DBACC" = @{"IP" = "10.18.200.234"; "Databases" = @("bodb02") }}
                                  , @{"DBAGE" = @{"IP" = "10.18.200.215"; "Databases" = @("bodb02") }}
                                  , @{"DBARC" = @{"IP" = "10.18.200.234"; "Databases" = @("bodb02") }}
                                  , @{"DBLIC" = @{"IP" = "10.18.200.215"; "Databases" = @("bodb_licensee") }}
                                  , @{"DBEXT" = @{"IP" = "10.18.200.215"; "Databases" = @("bodb02") }}
                                  , @{"DBCUST" = @{"IP" = "10.18.200.233"; "Databases" = @("custdb") }}
                                  , @{"DBMSG" = @{"IP" = "10.18.200.234"; "Databases" = @("bodb_message") }}
                                  , @{"DBRPT" = @{"IP" = "10.18.200.234"; "Databases" = @("bodb_report") }}
                                );
                    "SQLDeployer" = @{"username" = "dbateam"; "password" = "@bigboy#"}
                  }
            );
#SIT: server alias config

#UAT: server alias config

#PRO: server alias config

#OBJECT: target version config
$global:configVersion = @{"XTEST" = "_Xtest"; "XPRE" = "_Xpre"; "UAT1" = "_UAT1"; "UAT2" = "_UAT2"; "UAT3" = "_UAT3"; "UAT4" = "_UAT4"; "OGRINAL" = ""}