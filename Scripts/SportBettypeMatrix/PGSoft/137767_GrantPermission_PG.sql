/*<info serverAlias="DBAGE-bodb02" step="1"></info>*/
Use bodb02
GO 

/*
Create : 20200808@Sophia
Task: Grant Permission [redmine :#137767]
DB: DBAGE-bodb02
*/


GRANT SELECT ON PRODUCTS TO bodbDownlineNet 
GRANT SELECT ON PRODUCTS TO bodbDownlineNetView 