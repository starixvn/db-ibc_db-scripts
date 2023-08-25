/*<info serverAlias="DBPRO-bodb02"></info>*/
/*
	Created: 20230825@Evan
	DB: DBPRO-bodb02
	Task: Update Rename bettype 17003 [Redmine: #193037]
*/
USE bodb02;

GO

DECLARE @typeid INT
	  , @typenamee NVARCHAR(128)
	  , @typedesc NVARCHAR(128)
	  , @typenamec_uni NVARCHAR(128)
	  , @typenamej NVARCHAR(128)
	  , @typenamecn NVARCHAR(128)
	  , @typenameth NVARCHAR(128)
	  , @typenameit NVARCHAR(128)
	  , @typenameko NVARCHAR(128)
	  , @typenameES NVARCHAR(128)
	  , @typenameVN NVARCHAR(128)
	  , @typenameID NVARCHAR(128)
	  , @typenameFR NVARCHAR(128)
	  , @typenamePTBR NVARCHAR(128)
	  , @typenameDE NVARCHAR(128)
	  , @typenameBENG NVARCHAR(128)
	  , @typenameURD NVARCHAR(128)
	  , @typenameMSA NVARCHAR(128)
	  , @typenameKH NVARCHAR(128)
	  , @typenameLAO NVARCHAR(128)
	  , @typenameAR NVARCHAR(128)
	  , @typenameTAM NVARCHAR(128)
	  , @RepUpdateTime DATETIME2

SELECT @typeid = 17003
	 , @typenamee = N'SABA Reward System'
	 , @typedesc = N'SABA Reward System'
	 , @typenamec_uni = N'沙巴成就系统'
	 , @typenamej = N'SABA 報酬システム'
	 , @typenamecn = N'沙巴成就系统'
	 , @typenameth = N'ระบบรางวัล SABA'
	 , @typenameit = N'Sistema di reward SABA'
	 , @typenameko = N'SABA 리워드 체계'
	 , @typenameES = N'Sistema de recompensa de SABA'
	 , @typenameVN = N'Hệ Thống Phần Thưởng SABA'
	 , @typenameID = N'Sistem Imbalan SABA'
	 , @typenameFR = N'Système de récompense SABA'
	 , @typenamePTBR = N'Sistema de Prêmios SABA'
	 , @typenameDE = N'SABA Belohnungssystem'
	 , @typenameBENG = N'SABA পুরস্কার পদ্ধতি'
	 , @typenameURD = N'SABAx ریوارڈ سسٹم'
	 , @typenameMSA = N'Sistem ganjaran SABA'
	 , @typenameKH = N'ប្រព័ន្ធរង្វាន់ SABA'
	 , @typenameLAO = N'SABA ລະບົບລາງວັນ'
	 , @typenameAR = N'نظام جوائز SABA'
	 , @typenameTAM = N'SABA வெகுமதி முறை'
	 , @RepUpdateTime = SYSDATETIME()

UPDATE b
SET typenamee = @typenamee
  , typedesc = @typedesc
  , typenamec_uni = @typenamec_uni
  , typenamej = @typenamej
  , typenamecn = @typenamecn
  , typenameth = @typenameth
  , typenameit = @typenameit
  , typenameko = @typenameko
  , typenameES = @typenameES
  , typenameVN = @typenameVN
  , typenameID = @typenameID
  , typenameFR = @typenameFR
  , typenamePTBR = @typenamePTBR
  , typenameDE = @typenameDE
  , typenameBENG = @typenameBENG
  , typenameURD = @typenameURD
  , typenameMSA = @typenameMSA
  , typenameKH = @typenameKH
  , typenameLAO = @typenameLAO
  , typenameAR = @typenameAR
  , typenameTAM = @typenameTAM
  , RepUpdateTime = @RepUpdateTime
FROM bettype b WITH (ROWLOCK)
WHERE b.typeid = @typeid

GO
