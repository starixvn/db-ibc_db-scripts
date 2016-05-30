/*
	Created: Daniel
	Date: 20160527
	Task: Select data for importing into table tmpCustGameKindUM (SSIS)
	Source: DBCASINOADMIN.CasinoAdmin
	Destination: DBCUST.CustDB
*/

SELECT	c.IBCCustID CustID,
		ISNULL(SPositionTaking,0) [SPositionTaking], 
		ISNULL(MPositionTaking,0) [MPositionTaking], 
		ISNULL(APositionTaking,0) APositionTaking, 
		ISNULL(MinPresetPositionTaking, 0) MinPresetPositionTaking,
		ISNULL(IsAutoPositionTaking,0) IsAutoPositionTaking, 
		ISNULL(AutoPositionTaking,0) AutoPositionTaking, 
		ISNULL(MaxPositionTaking,0) MaxPositionTaking, 
		ISNULL(MinPositionTaking,0) MinPositionTaking,
		SMAgentRollingRate, 
		MAgentRollingRate, 
		AgentRollingRate, 
		MemberRollingRate,
		ISNULL(IsAutoMPositionTaking,0) IsAutoMPositionTaking, 
		ISNULL(AutoMPositionTaking,0) AutoMPositionTaking
FROM dbo.CustGameKind cs WITH(NOLOCK) 
	INNER JOIN dbo.customer c WITH (NOLOCK) ON cs.CustID = c.CustID
WHERE cs.GameKind = 9