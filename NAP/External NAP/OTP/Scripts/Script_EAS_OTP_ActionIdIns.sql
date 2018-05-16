
USE [bodb_CustomerLog]
GO


INSERT INTO [dbo].[LogAction]
           ([ActionID]
           ,[ActionTypeID]
           ,[SPName]
           ,[ActionNameEN]
           ,[ActionNameCH]
           ,[ActionNameCS]
           ,[ActionNameJP]
           ,[ActionNameIT]
           ,[ActionNameTH]
           ,[ActionNameKO]
           ,[XsltContent]
           ,[IsInternal]
           ,[ActionNameVI])
     VALUES
           (932
           ,4
           ,'EAS_OTP_CustomerOTPIns'
           ,'Register Mobile Authenticator App'
           ,'Register Mobile Authenticator App'
           ,'Register Mobile Authenticator App'
           ,'Register Mobile Authenticator App'
           ,'Register Mobile Authenticator App'
           ,'Register Mobile Authenticator App'
           ,'Register Mobile Authenticator App'
           ,NULL
           ,0
           ,'Register Mobile Authenticator App')
GO


USE [bodb_CustomerLog]
GO

INSERT INTO [dbo].[LogAction]
           ([ActionID]
           ,[ActionTypeID]
           ,[SPName]
           ,[ActionNameEN]
           ,[ActionNameCH]
           ,[ActionNameCS]
           ,[ActionNameJP]
           ,[ActionNameIT]
           ,[ActionNameTH]
           ,[ActionNameKO]
           ,[XsltContent]
           ,[IsInternal]
           ,[ActionNameVI])
     VALUES
           (933
           ,4
           ,'EAS_OTP_CustomerOTPSecretKeyUpd'
           ,'Update OTP secret key'
           ,'Update OTP secret key'
           ,'Update OTP secret key'
           ,'Update OTP secret key'
           ,'Update OTP secret key'
           ,'Update OTP secret key'
           ,'Update OTP secret key'
           ,NULL
           ,0
           ,'Update OTP secret key')
GO
