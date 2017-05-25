  /*
	Created: 20170307Winnie
	Task : Initial data for CashOut. Add dummy trade
	DB: DBCust/CustDB.	 [RedmineID: #71727]
*/

CREATE TABLE #supers (custid INT PRIMARY KEY,isfinished bit default(0))
INSERT INTO #supers(custid)
SELECT ci.custid
FROM Customer ci WITH(NOLOCK)
INNER JOIN custInfo c WITH(NOLOCK) ON ci.custid=c.custid
WHERE ci.roleid = 4 	
AND ci.custid IN (SELECT custid FROM Dep_CustSuper WITH(NOLOCK)) 
AND c.Enabled=1	
AND ci.site IN ('Macaubet','Aoncash','ITCBET','9Bet','Allbetclub','m8bola','Q8Bola','NBCbet','BE7','Goobet','Bolanation','IndoWin','IvoryBet','Unobet')

DECLARE @custid INT,@ErrMsg NVARCHAR(200),@UserId int
select @UserId=10278938

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) #Supers
	SET isfinished = 1
		,@custid = custid	
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK

			SELECT a.userName + 'CashOut' AS UserName, a.custid AS recommend, a.mrecommend, a.currency, a.site, a.refcode1
				, a.refcode2, a.ugroup, b.[closed], b.[MatchLimit], b.[VirtualMultiplier], b.[Enabled], b.[danger], b.[DisableHorseRacing]
				, b.[DisableFinancial], b.[DisableCasino], b.[SyncCasino], b.[danger2], b.[danger3], b.[DisableOutright], b.[DisableOpenTote]
				, b.[maxpermatch151_OT], b.[MaxPerMatch99MP], b.[DisableBingo], b.[DisableNumber], b.[maxpermatch161], b.[SyncBingo]
				, b.[MaxPerBall161], b.[MaxPerMatch151_AU], b.[MaxPerMatch152_UK], b.[MaxPerMatch152_AU], b.[MaxPerMatch153_AU]
				, b.[Disable151_AU], b.[Disable152_UK], b.[Disable152_AU], b.[Disable153_AU], b.[MaxTransferP2P], b.[IsAutoResetP2P]
				, b.[DisableP2P], b.[DisableFunP2P], b.[DisableLiveCasino], b.[SyncLiveCasino], b.[maxpermatch180], b.[DisableVirtualSports]
				, b.[HideVirtualSports], b.[Abnormal], b.[isAutoResetLiveCasino], b.[MaxWinLiveCasino], b.[DoubleCommLosing]
			INTO #tempCashOut
			FROM Customer a(NOLOCK)
				INNER JOIN custInfo b(NOLOCK)
				ON a.custid = b.custid
			WHERE a.srecommend = @CustID
				AND a.roleid = 2
				AND a.username NOT LIKE '%' + a.site + '%' + 'ACC%'
				AND (
					NOT EXISTS (
						SELECT 1
						FROM custInfo WITH (NOLOCK)
						WHERE username = a.userName + 'CashOut'
						)
					)
				AND (
					NOT EXISTS (
						SELECT 1
						FROM customer WITH (NOLOCK)
						WHERE username = a.userName + 'CashOut'
						)
					)
				AND (
					NOT EXISTS (
						SELECT 1
						FROM custsub WITH (NOLOCK)
						WHERE username = a.userName + 'CashOut'
						)
					)

			INSERT INTO [dbo].[Customer] ([username], [username2], creatdate, creator, currency, roleid, srecommend, mrecommend
				, recommend, site, refcode1, refcode2, ugroup)
			SELECT [username], b.site + '$' + [username], GETDATE(), @UserId, b.Currency, 1, @CustId, b.mrecommend, b.recommend
				, b.site, refcode1, refcode2, 'a'
			FROM #tempCashOut b
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM Customer(NOLOCK)
					WHERE username = b.username
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert customer'

				RETURN
			END

			INSERT INTO [dbo].[custInfo] ([username], [custid], [currency], [roleid], [srecommend], [mrecommend], [recommend], [closed]
				, [MatchLimit], [VirtualMultiplier], [Enabled], [danger], [DisableHorseRacing], [DisableFinancial], [DisableCasino]
				, [SyncCasino], [danger2], [danger3], [DisableOutright], [DisableOpenTote], [maxpermatch151_OT], [MaxPerMatch99MP]
				, [DisableBingo], [DisableNumber], [maxpermatch161], [SyncBingo], [MaxPerBall161], [MaxPerMatch151_AU], [MaxPerMatch152_UK]
				, [MaxPerMatch152_AU], [MaxPerMatch153_AU], [Disable151_AU], [Disable152_UK], [Disable152_AU], [Disable153_AU]
				, [MaxTransferP2P], [IsAutoResetP2P], [DisableP2P], [DisableFunP2P], [DisableLiveCasino], [SyncLiveCasino], [maxpermatch180]
				, [DisableVirtualSports], [HideVirtualSports], [Abnormal], [isAutoResetLiveCasino], [MaxWinLiveCasino], [DoubleCommLosing], credit)
			SELECT a.[username], a.[custid], a.[currency], a.[roleid], a.[srecommend], a.[mrecommend], a.[recommend], b.[closed]
				, b.[MatchLimit], 0, b.[Enabled], b.[danger], b.[DisableHorseRacing], b.[DisableFinancial], b.[DisableCasino]
				, b.[SyncCasino], b.[danger2], b.[danger3], b.[DisableOutright], b.[DisableOpenTote], b.[maxpermatch151_OT], b.[MaxPerMatch99MP]
				, b.[DisableBingo], b.[DisableNumber], b.[maxpermatch161], b.[SyncBingo], b.[MaxPerBall161], b.[MaxPerMatch151_AU]
				, b.[MaxPerMatch152_UK], b.[MaxPerMatch152_AU], b.[MaxPerMatch153_AU], b.[Disable151_AU], b.[Disable152_UK], b.[Disable152_AU]
				, b.[Disable153_AU], b.[MaxTransferP2P], b.[IsAutoResetP2P], b.[DisableP2P], b.[DisableFunP2P], b.[DisableLiveCasino]
				, b.[SyncLiveCasino], b.[maxpermatch180], b.[DisableVirtualSports], b.[HideVirtualSports], b.[Abnormal], b.[isAutoResetLiveCasino]
				, b.[MaxWinLiveCasino], b.[DoubleCommLosing], 0
			FROM Customer(NOLOCK) a
				INNER JOIN #tempCashOut b
				ON a.username = b.username
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM custInfo(NOLOCK)
					WHERE username = a.username
						OR custid = a.custid
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert custinfo'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				RETURN
			END

			INSERT INTO [dbo].[TradeCust] ([Custid],VendorID)
			SELECT b.[Custid],14
			FROM #tempCashOut a
				INNER JOIN Customer(NOLOCK) b
				ON a.username = b.username
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [TradeCust](NOLOCK)
					WHERE custid = b.custid
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert TradeCust'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM [TradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempCashOut b
					ON c.username = b.username

				RETURN
			END

			INSERT INTO [dbo].[TradeComm] ([Agentid], [IsBA], [TradeComm], [Licenseecomm],HouseDeductionRate,HousePT,VendorID)
			SELECT a.recommend, 0, 0.03, 0.03,0.015,0.5,14
			FROM #tempCashOut a
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [TradeComm](NOLOCK)
					WHERE [Agentid] = a.recommend
						AND [IsBA] = 0
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert TradeComm'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM [TradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempCashOut b
					ON c.username = b.username

				DELETE a
				FROM [TradeComm] a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.AgentId = b.recommend
				WHERE IsBA = 0

				RETURN
			END

			INSERT INTO [dbo].[TradeComm] ([Agentid], [IsBA], [TradeComm], [Licenseecomm],HouseDeductionRate,HousePT,VendorID)
			SELECT a.recommend, 1, 0.03, 0,0.015,0.5,14
			FROM #tempCashOut a
			WHERE NOT EXISTS (
					SELECT TOP 1 1
					FROM [TradeComm](NOLOCK)
					WHERE [Agentid] = a.recommend
						AND [IsBA] = 1
					)

			IF (@@ERROR <> 0)
			BEGIN
				SELECT @ErrMsg = 'Could not insert TradeComm'

				DELETE a
				FROM Customer a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM custInfo a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.username = b.username

				DELETE a
				FROM [TradeCust] a(NOLOCK)
					INNER JOIN Customer(NOLOCK) c
					ON a.custid = c.Custid
					INNER JOIN #tempCashOut b
					ON c.username = b.username

				DELETE a
				FROM [TradeComm] a(NOLOCK)
					INNER JOIN #tempCashOut b
					ON a.AgentId = b.recommend

				RETURN
			END

			DECLARE @tradeUserName VARCHAR(50), @tradeCustId INT, @tradeAgentId INT, @tradeCurrency INT
				, @tradeSite VARCHAR(100), @tradeErrCode VARCHAR(100)

			WHILE EXISTS (
					SELECT TOP 1 1
					FROM #tempCashOut
					)
			BEGIN
				SELECT TOP 1 @tradeUserName = a.UserName, @tradeCustId = b.custid, @tradeAgentId = b.recommend
					, @tradeCurrency = b.currency, @tradeSite = b.site
				FROM #tempCashOut a
					INNER JOIN Customer b WITH (NOLOCK)
					ON a.username = b.username

				----Insert Dep_Custsetting
				INSERT INTO [dbo].[Dep_CustSetting] ([custid], [bettype], [sporttype], [islive], [apositiontaking], [mpositiontaking]
					, [spositiontaking], [playerdiscount], [discount], [adiscount], [sdiscount], [minbet], [maxbet])
				SELECT @tradeCustId, [bettype], [sporttype], [islive], [apositiontaking], [mpositiontaking], [spositiontaking]
					, [playerdiscount], [discount], [adiscount], [sdiscount], [minbet], [maxbet]
				FROM [Dep_CustSetting] a(NOLOCK)
				WHERE custid = @tradeAgentId
					AND NOT EXISTS (
						SELECT TOP 1 1
						FROM [Dep_CustSetting] b(NOLOCK)
						WHERE b.custid = @tradeCustId
							AND a.bettype = b.bettype
							AND a.sporttype = b.sporttype
							AND a.islive = b.islive
						)

				---------------------------------------------------------------------------------  
				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not insert TradeCust'

					DELETE a
					FROM Customer a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.username = b.username

					DELETE a
					FROM custInfo a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.username = b.username

					DELETE a
					FROM [TradeCust] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempCashOut b
						ON c.username = b.username

					DELETE a
					FROM [Dep_CustSetting] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempCashOut b
						ON c.username = b.username

					DELETE a
					FROM [TradeComm] a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.AgentId = b.recommend

					RETURN
				END

				---------------------------------------------------------------------------------  
				-- Insert Balance
				EXEC DBTXN.bodb02.dbo.Dot_BalanceInsCredit @CustID = @tradeCustID

				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not insert TradeCust'

					DELETE a
					FROM Customer a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.username = b.username

					DELETE a
					FROM custInfo a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.username = b.username

					DELETE a
					FROM [TradeCust] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempCashOut b
						ON c.username = b.username

					DELETE a
					FROM [Dep_CustSetting] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempCashOut b
						ON c.username = b.username

					DELETE a
					FROM [TradeComm] a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.AgentId = b.recommend

					EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @tradeCustID --DELETE BalanceCredit WITH (ROWLOCK) WHERE custid = @custid   

					RETURN
				END

				EXEC DBTXN.bodb02.dbo.Dot_BalanceInsDebit @CustID = @tradeCustID

				IF (@@ERROR <> 0)
				BEGIN
					SELECT @ErrMsg = 'Could not insert TradeCust'

					DELETE a
					FROM Customer a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.username = b.username

					DELETE a
					FROM custInfo a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.username = b.username

					DELETE a
					FROM [TradeCust] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempCashOut b
						ON c.username = b.username

					DELETE a
					FROM [Dep_CustSetting] a(NOLOCK)
						INNER JOIN Customer(NOLOCK) c
						ON a.custid = c.Custid
						INNER JOIN #tempCashOut b
						ON c.username = b.username

					DELETE a
					FROM [TradeComm] a(NOLOCK)
						INNER JOIN #tempCashOut b
						ON a.AgentId = b.recommend

					EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @tradeCustID --DELETE BalanceCredit WITH (ROWLOCK) WHERE custid = @custid   

					EXEC DBTXN.bodb02.dbo.Dot_BalanceDelDebit @CustID = @tradeCustID

					RETURN
				END

				--Copy Customer Info to DBLIC.bodb_Licensee.dbo.LicenseeCustinfo
				EXEC DBLIC.bodb_Licensee.dbo.Lrf_CustomerInfoIns @CustID = @tradeCustId
					, @Recommend = @tradeAgentId, @Username = @tradeUserName
					, @Username2 = @tradeUserName, @Currency = @tradeCurrency

				--Set default player comm  
				EXEC DBLIC.bodb_Licensee.dbo.Lrf_CustomerSetDefaultComm @LicenseeName = @tradesite
					, @CustID = @tradeCustID, @ErrCode = @tradeErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT

				DELETE
				FROM #tempCashOut
				WHERE UserName = @tradeUserName
			END
		DROP TABLE #tempCashOut
	waitfor delay '00:00:0.280'
END


DROP TABLE #supers