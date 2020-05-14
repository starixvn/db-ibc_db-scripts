USE [CustDB]

/*
Create: 20200514@Sophia
DBTXN.bodb02
Task: 131358 - create permission for Dot_Intg
*/

GO
CREATE USER [Dot_Intg] FOR LOGIN [Dot_Intg]
GO
GRANT SELECT ON Exchange TO Dot_Intg 
 