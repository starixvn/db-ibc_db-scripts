USE bodb_EAS
GO

EXEC sp_rename 'eaUserInfo', 'Delete_eaUserInfo', 'OBJECT'
GO
EXEC sp_rename 'eaUserPolicy', 'Delete_eaUserPolicy', 'OBJECT'
GO
EXEC sp_rename 'eaGroupPolicy', 'Delete_eaGroupPolicy', 'OBJECT'
GO
EXEC sp_rename 'eaOn_User', 'Delete_eaOn_User', 'OBJECT'
GO
EXEC sp_rename 'eaMenu', 'Delete_eaMenu', 'OBJECT'
GO
EXEC sp_rename 'eaGroupConfiguration', 'Delete_eaGroupConfiguration', 'OBJECT'
GO
EXEC sp_rename 'eaFunction', 'Delete_eaFunction', 'OBJECT'
GO
EXEC sp_rename 'eaGroup', 'Delete_eaGroup', 'OBJECT'
GO