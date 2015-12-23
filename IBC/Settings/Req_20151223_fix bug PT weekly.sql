 --Correct pt for Gold Deluxe
 --SUPER	S99ah (4022510)
 --N4 > S1 + M1 + A1
 EXEC Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'GoldDeluxe', @sporttype = 255, @bettype = 1701
 GO

-----------------------------------------------------------------------------------------------------------
--correct pt for Live casino
--rule: MIN (S4-M1-A1, (IS1?US1,US3)) > S1

--SUPER	S2M (1211024)
--MASTER	S2MBU (16011488)
 EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 1211024, @mrecommend = 16011488, @roleid = 3, @mode = 'LiveCasino'
GO

--MASTER	S2MSA (2356621)
--SUPER	S2M (1211024)
 EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 1211024, @mrecommend = 2356621, @roleid = 3, @mode = 'LiveCasino'
GO

--rule N4 > S1 + M1 + A1
--SUPER	S99ah (4022510)
EXEC [Acc_CustSetting3rd_04] @srecommend = 4022510, @roleid = 4, @mode = 'LiveCasino'
GO

----------------------------------------------------------------------------------------------------------------
--correct pt for Racing
--MIN (S4-M1-A1, (IS1?US1,US3)) > S1

--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'horse'

----------------------------------------------------------------------------------------------------------------
--correct pt for Virtual sports
--N4 > S1 + M1 + A1

--Virtual Tennis
--SUPER	SNI (15516774)
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 15516774, @roleid = 4,@mode = 'virtual-sports',@sporttype = 186,@bettype = 1220
GO

--Virtual Speedway
--SUPER	SNI (15516774)
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 15516774, @roleid = 4,@mode = 'virtual-sports',@sporttype = 183,@bettype = 1231
GO

--Virtual Motorsports
--SUPER	SNI (15516774)
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 15516774, @roleid = 4,@mode = 'virtual-sports',@sporttype = 184,@bettype = 1231
GO

--Virtual Horse Racing
--SUPER	SNI (15516774)
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 15516774, @roleid = 4,@mode = 'virtual-sports',@sporttype = 181,@bettype = 1231
GO

--Virtual Greyhounds
--SUPER	SNI (15516774)
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 15516774, @roleid = 4,@mode = 'virtual-sports',@sporttype = 182,@bettype = 1231
GO


--Virtual Cycling
--SUPER	SNI (15516774)
EXEC dbo.Acc_CustSetting3rd_07 @srecommend = 15516774, @roleid = 4,@mode = 'virtual-sports',@sporttype = 185,@bettype = 1231
GO

--N4 > S1 + M1 + A1
--Virtual Tennis
--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'virtual-sports', @sporttype = 186, @bettype = 1220
GO

--Virtual Speedway
--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'virtual-sports', @sporttype = 183, @bettype = 1231
GO

--Virtual Soccer
--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'virtual-sports', @sporttype = 180, @bettype = 1201
GO

--Virtual Motorsports
--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'virtual-sports', @sporttype = 184, @bettype = 1231
GO

--Virtual Horse Racing
--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'virtual-sports', @sporttype = 181, @bettype = 1231
GO

--Virtual Greyhounds
--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'virtual-sports', @sporttype = 182, @bettype = 1231
GO

--Virtual Cycling
--SUPER	S99ah (4022510)
EXEC dbo.Acc_CustSetting3rd_04 @srecommend = 4022510, @roleid = 4, @mode = 'virtual-sports', @sporttype = 185, @bettype = 1231
GO