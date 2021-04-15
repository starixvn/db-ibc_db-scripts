/*<info serverAlias="DBCUST-Licensee"></info>*/

/*
	Created: 20210415@Sophia
	DB: DBCUST-Licensee
	Task: Add Saba 789 to Credit [redmine: #151623]
*/

USE bodb_Licensee
GO

INSERT INTO Labels (LicenseeID,LabelID,LabelName,AffectedDate,IsKPISummary) 
VALUES (18, 509, 'Saba789','2021-02-01 00:00:00.000', 0) 



DELETE FROM LA_ChargeInfo_SystemMapping WITH (ROWLOCK) 
WHERE ChargeID IN ( SELECT ChargeID  
					FROM [OAS_ChargeInfo] WITH (NOLOCK) 
					WHERE Fromparty = 540 )					
					
DELETE FROM [OAS_PartyBaseCurrency] WITH (ROWLOCK) WHERE partyID = 540 

DELETE FROM [OAS_PartyDetail] WITH (ROWLOCK) WHERE partyID = 540  

DELETE FROM [OAS_Party] WITH (ROWLOCK) WHERE partyID = 540  

DELETE FROM [OAS_ChargeInfo] WITH (ROWLOCK)  WHERE Fromparty = 540 

DELETE FROM [LA_FunctionParty] WITH (ROWLOCK) WHERE partyID = 540 

DELETE FROM [LA_InvoiceSetting] WITH (ROWLOCK) WHERE FromPartyId = 540 

DELETE FROM [LA_UserParty] WITH (ROWLOCK) WHERE partyID = 540 
