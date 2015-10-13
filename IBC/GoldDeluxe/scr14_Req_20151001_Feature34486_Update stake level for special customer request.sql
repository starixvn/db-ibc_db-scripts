 /*
	created: Johnson
	Date: 20151001
	Task: update gold deluxe bet limit for special customer
	DB: DBCUST/CustDB
 */
 --SELECT * FROM CustGameType where custid = 720475 and GameTypeID IN (1701,1702)

--SELECT * FROM StakeLevel where StakeLevelID in (372,373,374)

--SELECT top 100 cg.StakeLevelList, ci.*
--from CustGameType cg (NOLOCK) 
--inner join custInfo ci (NOLOCK) ON ci.custid = cg.CustID and cg.GameTypeID = 1702
--WHERE ci.srecommend =720475
--AND cg.StakeLevelList LIKE '%372%'
 
 DECLARE @custid		INT,
	@StakeLevel	VARCHAR(4000),
	@Language	VARCHAR(2)='E',	
	@ErrCode	INT = 00,
	@ErrMsg		NVARCHAR(500) = ''

DECLARE @roleid INT
		,@GameTypeID INT
		,@StakeLevelList VARCHAR(300)
		,@StakeLevelList_Old VARCHAR(300)
		,@LowestStakeLevelList VARCHAR(30)
		
--pass custid & stakelevelList wants to apply
/* @StakeLevel = <ROOT>
								<Row ID="1701" Stake="1,2,3,4"/>
								<Row ID="1702" Stake="1,2,3,4"/>
							</ROOT>
*/
--SELECT @custid = 720475,
--	@StakeLevel = '<ROOT><Row ID="1702" Stake="373,374"/>
--							</ROOT>'
	
	
SELECT @custid = xx,
	@StakeLevel = ''
	
	
	DECLARE @DownlineID INT
			,@srecommend INT
			,@mrecommend INT
			,@recommend  INT
			,@DownlineRoleid INT
			,@DownlineStakeLevelList VARCHAR(300)
			,@DownlineStakeLevelList_new VARCHAR(300)
			,@UplineStakeLevelList VARCHAR(300)
			,@UplineLowestStakeLevelList VARCHAR(300)
			,@invalidStakeLevelID INT
			,@cntCust INT 
			,@rowcount INT
			--store xml bet settings for downlines when correct settings			
			,@BetSettings VARCHAR(MAX)
			--log data
			,@LogStakeLevel VARCHAR(500)
			,@LogStakeLevel_Old VARCHAR(500)
			,@LogSPData VARCHAR(MAX)
			,@LogSPData_Old VARCHAR(MAX)
			
	IF OBJECT_ID('tempdb..#CustGameTypeDownlines') IS NOT NULL DROP TABLE #CustGameTypeDownlines

	CREATE TABLE #CustGameTypeDownlines (
				CustID INT PRIMARY KEY		
				,srecommend INT
				,mrecommend INT
				,recommend INT		
				,roleid TINYINT
				,StakeLevelList varchar(100)
				,StakeLevelList_new varchar(100)
				,isUpdated BIT DEFAULT (0)				
		)

	DECLARE @tmpStake TABLE(GameTypeID INT, StakeLevelList VARCHAR(500), isValidated BIT DEFAULT(0))
	
	DECLARE @DocHandler INT
	
	-- For read xml					
	EXEC sp_xml_preparedocument @DocHandler OUTPUT, @StakeLevel
	
	INSERT INTO @tmpStake(
					GameTypeID,
					StakeLevelList
				)
		SELECT
			Data.ID,
			Data.Stake			
		FROM OPENXML (@DocHandler, '/ROOT/Row',1) 
		WITH (
			ID			SMALLINT,
			Stake		VARCHAR(200)	
		) AS Data

	EXEC sp_xml_removedocument @DocHandler
	-- end read xml
	
	SELECT @srecommend = srecommend
			,@mrecommend = mrecommend
			,@recommend = recommend
			,@roleid = roleid
	FROM CustInfo WITH(NOLOCK)
	WHERE custid = @custid
	
	--validate stake level
	IF @roleid < 4
	BEGIN
		WHILE (1=1)
		BEGIN
			SELECT TOP (1) @GameTypeID = GameTypeID,
					@StakeLevelList = StakeLevelList 
			FROM @tmpStake
			WHERE isValidated = 0
		
			IF @@ROWCOUNT = 0 BREAK;
		
			IF @RoleID = 3
			BEGIN
				SELECT	@UplineStakeLevelList = StakeLevelList
				FROM	CustGameType with(nolock) 
				WHERE	CustID = @srecommend
						AND GameTypeID = @GameTypeID	
			END									
			ELSE IF @RoleID = 2
			BEGIN
				SELECT	@UplineStakeLevelList = StakeLevelList
				FROM	CustGameType with(nolock)
				WHERE	CustID = @Mrecommend
						AND GameTypeID = @GameTypeID
			END									
			ELSE IF @RoleID = 1
			BEGIN
				SELECT	@UplineStakeLevelList = StakeLevelList
				FROM	CustGameType with(nolock) 
				WHERE	CustID = @recommend
						AND GameTypeID = @GameTypeID
			END
		
			SELECT	TOP 1 @invalidStakeLevelID = ISNULL(Val,0) 	
			FROM	dbo.strSplit(@StakeLevelList,',')
			WHERE	Val not in (SELECT Val FROM dbo.strSplit(@UplineStakeLevelList,','))
		
			IF @invalidStakeLevelID > 0
			BEGIN
				--Return Data
				SELECT @ErrCode = 1000
				BEGIN TRY
					SELECT @ErrMsg = CASE @Language 
								WHEN 'E' THEN 'This user''s upline does not have Stake Level for ' 
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10031,@Language)
							END + typenamee 
					FROM DBAGE.bodb02.dbo.bettype WITH(NOLOCK)
					WHERE TypeID = @GameTypeID
				END TRY
				BEGIN CATCH
					SELECT @ErrMsg = CASE @Language 
								WHEN 'E' THEN 'This user''s upline does not have Stake Level for ' 
								ELSE [dbo].[f_Get_MsgNamebyMsgID](10031,@Language)
							END + typenamee 
					FROM DBTXN.bodb02.dbo.bettype WITH(NOLOCK)
					WHERE TypeID = @GameTypeID
				END CATCH						
			END	
		
			UPDATE @tmpStake
			SET isValidated = 1
			WHERE GameTypeID = @GameTypeID
		
		END
	END
	--end validate
	
	--update stake level
	WHILE (1=1)
	BEGIN
		SELECT TOP (1) @GameTypeID = GameTypeID,
				@StakeLevelList = StakeLevelList 
		FROM @tmpStake
		
		IF @@ROWCOUNT = 0 BREAK;
		
		SELECT @StakeLevelList_Old = ISNULL(StakeLevelList,'')
		FROM CustGameType WITH(NOLOCK)
		WHERE custid = @custid AND GameTypeID = @GameTypeID
		
		IF @StakeLevelList <> @StakeLevelList_Old
		BEGIN
			UPDATE	CustGameType with(UPDLOCK,ROWLOCK)
			SET		StakeLevelList = @StakeLevelList
			WHERE	CustID = @CustID
				AND GameTypeID = @GameTypeID
			
			IF @roleid > 1 --Apply stake level for downlines
			BEGIN
				--Get stake level is unchecked
				IF OBJECT_ID('tempdb..#temp_DelStakeLevelList') IS NOT NULL DROP TABLE #temp_DelStakeLevelList
				IF EXISTS ( SELECT ISNULL(val,'')
							FROM dbo.strSplit(@StakeLevelList_Old,',')
							WHERE val NOT IN (SELECT val FROM strSplit(@StakeLevelList,','))	
							)
				BEGIN
					SELECT	ISNULL(Val,'') Val INTO #temp_DelStakeLevelList
					FROM	dbo.strSplit(@StakeLevelList_Old,',')
					WHERE	ISNULL(Val,'') NOT IN(SELECT ISNULL(val,'') Val FROM dbo.strSplit(@StakeLevelList,',')) 		
				END
				
				--Get lowest stake level to apply to agents/members
				SELECT	top 1 @LowestStakeLevelList = CONVERT(VARCHAR(10),StakeLevelID)
				FROM	dbo.StakeLevel with(nolock)
				WHERE	CHARINDEX('''' + convert(varchar(5),StakeLevelID) + '''','''' + replace(@StakeLevelList,',',''',''') + '''') > 0
						AND MinStake <> 0
						AND MaxStake <> 0
				ORDER BY MinStake, MaxStake	
				
				--delete old data
				TRUNCATE TABLE #CustGameTypeDownlines
				
				IF @roleid = 4
				BEGIN
					INSERT INTO #CustGameTypeDownlines (CustID, srecommend, mrecommend, recommend, roleid ,StakeLevelList)
					SELECT ci.custid, srecommend, mrecommend, recommend, ci.roleid, StakeLevelList
					FROM custinfo ci WITH(NOLOCK)
						INNER JOIN CustGameType cg WITH(NOLOCK) ON ci.custid = cg.custid AND cg.gametypeid = @GameTypeID
					WHERE srecommend = @custid 	
				END
				IF @roleid = 3
				BEGIN
					INSERT INTO #CustGameTypeDownlines (CustID ,srecommend, mrecommend, recommend, roleid ,StakeLevelList)
					SELECT ci.custid, srecommend, mrecommend, recommend, ci.roleid, StakeLevelList
					FROM custinfo ci WITH(NOLOCK)
						INNER JOIN CustGameType cg WITH(NOLOCK) ON ci.custid = cg.custid AND cg.gametypeid = @GameTypeID
					WHERE mrecommend = @custid 
				END
				IF @roleid = 2
				BEGIN
					INSERT INTO #CustGameTypeDownlines (CustID, srecommend, mrecommend, recommend,roleid ,StakeLevelList)
					SELECT ci.custid, srecommend, mrecommend, recommend, ci.roleid, StakeLevelList
					FROM custinfo ci WITH(NOLOCK)
						INNER JOIN CustGameType cg WITH(NOLOCK) ON ci.custid = cg.custid AND cg.gametypeid = @GameTypeID
					WHERE recommend = @custid 
				END	
				
				UPDATE #CustGameTypeDownlines
				SET StakeLevelList_new = @StakeLevelList
				WHERE custid = @custid
																	 	
				SELECT @cntCust = 0, 
						@BetSettings = '<ROOT>'		
				--correct stake level for all downlines
				WHILE (1 = 1)
				BEGIN						
					SELECT TOP 1 @DownlineID = custid , @srecommend = srecommend, @mrecommend = mrecommend, @recommend = recommend,
						 @DownlineRoleid = roleid ,@DownlineStakeLevelList = ISNULL(StakeLevelList,'')
					FROM #CustGameTypeDownlines
					WHERE roleid < @roleid
						and isUpdated= 0
					ORDER BY roleid DESC, custid
					
					SET @rowcount = @@rowcount
					
					IF @rowcount = 0 OR @cntCust = 1000
					BEGIN
						SET @BetSettings = @BetSettings + '</ROOT>'
										
						--call execrep to correct downlines by batch customers
												EXEC Acc_Custsetting3rd_10 
							@Action = 'GoldDeluxe'
							,@GameTypeID = @GameTypeID
							,@BetSettings = @BetSettings
							
						IF @rowcount = 0 
							BREAK;
							
						--reset counter
						SELECT @cntCust = 0,
								@BetSettings = '<ROOT>'						
					END
						
						
					IF OBJECT_ID('tempdb..#temp_DelStakeLevelList') IS NOT NULL
					BEGIN
						IF @DownlineStakeLevelList <> ''
						BEGIN 
							SET @DownlineStakeLevelList_new = ''
							
							SELECT @DownlineStakeLevelList_new = @DownlineStakeLevelList_new + val + ','
							FROM dbo.strSplit(@DownlineStakeLevelList,',')
							WHERE val not in (SELECT val FROM #temp_DelStakeLevelList)
							
							IF @DownlineStakeLevelList_new <> ''
								SET @DownlineStakeLevelList_new = left(@DownlineStakeLevelList_new,len(@DownlineStakeLevelList_new) - 1)
							
							--apply valid stake level for downline
							IF @DownlineStakeLevelList_new = ''
							BEGIN
								IF @DownLineRoleid = 3
									SELECT @UplineStakeLevelList = StakeLevelList_new
									FROM #CustGameTypeDownlines WITH(NOLOCK)
									WHERE custid = @srecommend
								ELSE IF  @DownLineRoleid = 2
									SELECT @UplineStakeLevelList = StakeLevelList_new
									FROM #CustGameTypeDownlines WITH(NOLOCK)
									WHERE custid = @mrecommend
								ELSE IF  @DownLineRoleid = 1
									SELECT @UplineStakeLevelList = StakeLevelList_new
									FROM #CustGameTypeDownlines WITH(NOLOCK)
									WHERE custid = @recommend
																	
								SELECT TOP 1 @UplineLowestStakeLevelList = ISNULL(CONVERT(varchar(10),StakeLevelID),'')
								FROM dbo.StakeLevel WITH(NOLOCK)
								WHERE stakeLevelID IN (SELECT val FROM dbo.strSplit(@UplineStakeLevelList,','))
									AND MinStake <> 0
									AND MaxStake <> 0
								ORDER BY minstake , maxstake
								
								SET @DownlineStakeLevelList_new = ISNULL(@UplineLowestStakeLevelList,'')															
							END
						END
					END
					--check if old stake level list is empty and update stake level list then copy all stake level list to master if update super and 
					--copy lowest stake level to agent/member if update master/agent
					IF RTRIM(ISNULL(@StakeLevelList_Old,'')) = '' AND RTRIM(ISNULL(@StakeLevelList,'')) <> ''
					BEGIN
						IF @DownLineRoleID = 1 or @DownLineRoleID = 2 
							SET @DownlineStakeLevelList_new = ISNULL(@LowestStakeLevelList,'')
						ELSE IF @DownLineRoleID = 3
							SET @DownlineStakeLevelList_new = ISNULL(@StakeLevelList,'')
					END
				
					SELECT @BetSettings = @BetSettings +
										'<Row ID="'+CONVERT(varchar(10),@DownlineID)+'" Stake="'+ @DownlineStakeLevelList_new +'" />',
							@cntCust = @cntCust + 1				
				
					UPDATE #CustGameTypeDownlines
					SET StakeLevelList_new = @DownlineStakeLevelList_new,
						isUpdated = 1
					WHERE CustID = @DownLineID
				END
			END
		END	
	
		
		DELETE @tmpStake WHERE GameTypeID = @GameTypeID				
	END			
	

SELECT @ErrCode, @ErrMsg	