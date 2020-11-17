/*<info serverAlias="DB053-bodb_Summary"></info>*/
/*
DB: DB053.bodb_Summary
Create: 20201117@Malcolm
Task: CN88 - Update Wagers, MemberWinloss, HeadlineWinloss in DB053 [RedmineId : #145494]
*/

DECLARE @Tmp TABLE
(
	CustID			INT,
	WinlostDate		SMALLDATETIME,
	ProductId		SMALLINT,
	Sporttype		SMALLINT,
	Bettype			SMALLINT,
	IsLive			BIT,
	Wagers			INT,
	Stake			MONEY,
	ValidStake		MONEY,
	MemberWinloss	MONEY,
	MemberComm		MONEY,
	Agent			MONEY,
	AgentWinloss	MONEY,
	AgentComm		MONEY,
	AgentStock		MONEY,
	AgentResultA	MONEY,
	Master			MONEY,
	MasterWinloss	MONEY,
	MasterComm		MONEY,
	MasterStock		MONEY,
	Super			MONEY,
	SuperWinloss	MONEY,
	SuperComm		MONEY,
	SuperStock		MONEY,
	HeadlineWinloss	MONEY,
	HeadlineComm	MONEY,
	HeadlineStock	MONEY,
	HouseTurnover	MONEY
)

INSERT INTO @Tmp 
(
	CustID		
	,WinlostDate	
	,ProductId	
	,Sporttype	
	,Bettype		
	,IsLive		
	,Wagers		
	,Stake		
	,ValidStake	
	,MemberWinloss
	,MemberComm	
	,Agent		
	,AgentWinloss
	,AgentComm	
	,AgentStock	
	,AgentResultA
	,Master		
	,MasterWinloss
	,MasterComm	
	,MasterStock	
	,Super		
	,SuperWinloss
	,SuperComm	
	,SuperStock	
	,HeadlineWinloss
	,HeadlineComm
	,HeadlineStock
	,HouseTurnover
)
SELECT 
	cs2.CustID		
	,cs2.WinlostDate	
	,cs2.ProductId	
	,cs2.Sporttype	
	,cs2.Bettype		
	,cs2.IsLive		
	,cs2.Wagers		
	,cs2.Stake		
	,cs2.ValidStake	
	,cs2.MemberWinloss
	,cs2.MemberComm	
	,cs2.Agent		
	,cs2.AgentWinloss
	,cs2.AgentComm	
	,cs2.AgentStock	
	,cs2.AgentResultA
	,cs2.Master		
	,cs2.MasterWinloss
	,cs2.MasterComm	
	,cs2.MasterStock	
	,cs2.Super		
	,cs2.SuperWinloss
	,cs2.SuperComm	
	,cs2.SuperStock	
	,cs2.HeadlineWinloss
	,cs2.HeadlineComm
	,cs2.HeadlineStock
	,cs2.HouseTurnover
FROM CS_SumWinloss cs1 WITH(NOLOCK)
	INNER JOIN DB052.bodb_Summary.dbo.CS_SumWinloss cs2 WITH(NOLOCK) 
		ON cs1.CustID		= cs2.CustID	
		AND cs1.WinlostDate = cs2.WinlostDate
		AND cs1.Sporttype	= cs2.Sporttype
		AND cs1.Bettype		= cs2.Bettype
		AND cs1.IsLive		= cs2.IsLive
		AND cs1.WinlostDate = '20201011'
WHERE  cs1.Wagers			<> cs2.Wagers 
	OR cs1.Stake			<> cs2.Stake
	OR cs1.ValidStake		<> cs2.ValidStake
	OR cs1.MemberWinloss	<> cs2.MemberWinloss 
	OR cs1.MemberComm		<> cs2.MemberComm
	OR cs1.Agent			<> cs2.Agent
	OR cs1.AgentWinloss		<> cs2.AgentWinloss
	OR cs1.AgentComm		<> cs2.AgentComm
	OR cs1.AgentStock		<> cs2.AgentStock
	OR cs1.AgentResultA		<> cs2.AgentResultA
	OR cs1.Master			<> cs2.Master
	OR cs1.MasterWinloss	<> cs2.MasterWinloss
	OR cs1.MasterComm		<> cs2.MasterComm
	OR cs1.MasterStock		<> cs2.MasterStock
	OR cs1.Super			<> cs2.Super
	OR cs1.SuperWinloss		<> cs2.SuperWinloss
	OR cs1.SuperComm		<> cs2.SuperComm
	OR cs1.SuperStock		<> cs2.SuperStock
	OR cs1.HeadlineWinloss	<> cs2.HeadlineWinloss
	OR cs1.HeadlineComm		<> cs2.HeadlineComm
	OR cs1.HeadlineStock	<> cs2.HeadlineStock
	OR cs1.HouseTurnover	<> cs2.HouseTurnover


UPDATE cs
	SET 
		 cs.Wagers			= t.Wagers 
		 ,cs.Stake			= t.Stake
		 ,cs.ValidStake		= t.ValidStake
		 ,cs.MemberWinloss	= t.MemberWinloss 
		 ,cs.MemberComm		= t.MemberComm
		 ,cs.Agent			= t.Agent
		 ,cs.AgentWinloss	= t.AgentWinloss
		 ,cs.AgentComm		= t.AgentComm
		 ,cs.AgentStock		= t.AgentStock
		 ,cs.AgentResultA	= t.AgentResultA
		 ,cs.Master			= t.Master
		 ,cs.MasterWinloss	= t.MasterWinloss
		 ,cs.MasterComm		= t.MasterComm
		 ,cs.MasterStock	= t.MasterStock
		 ,cs.Super			= t.Super
		 ,cs.SuperWinloss	= t.SuperWinloss
		 ,cs.SuperComm		= t.SuperComm
		 ,cs.SuperStock		= t.SuperStock
		 ,cs.HeadlineWinloss= t.HeadlineWinloss
		 ,cs.HeadlineComm	= t.HeadlineComm
		 ,cs.HeadlineStock	= t.HeadlineStock
		 ,cs.HouseTurnover	= t.HouseTurnover
FROM CS_SumWinloss cs WITH(ROWLOCK)
	INNER JOIN @Tmp t 
		ON cs.CustID		= t.CustID	
		AND cs.WinlostDate  =  t.WinlostDate
		AND cs.Sporttype	= t.Sporttype
		AND cs.Bettype		= t.Bettype
		AND cs.IsLive		= t.IsLive
		AND cs.WinlostDate = '20201011'

