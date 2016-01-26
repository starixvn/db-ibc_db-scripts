USE [bodb02]
GO
/****** Object:  Trigger [dbo].[bettrans_running_INSERT]    Script Date: 1/26/2016 8:25:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[bettrans_running_INSERT]
   ON  [dbo].[bettrans]
   AFTER INSERT
AS 
/*  
 Created:	unknown
 Task :		Insert data into Bettrans_running
 DB:		DBAGE.bodb02
 Original:  
  
 Revisions:
	- 20150928@Sophia: Add column OddsSpread for Colossus Bets
	- 20160125@Sophia: Add column Transdesc for PH AIO phase 1.2 [Redmime: #50897]

*/

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
    /* -- Viet: remove this bettrans_running table, use synonym from bodb_age instead.
    
	INSERT INTO dbo.bettrans_running (
		[transid],[transdate],[matchid],[refno],[odds],[bettype],[betteam],
		[hdp1],[hdp2],[oddstype],[modds],[stake],[actual_stake],[liveindicator],[livehomescore],[liveawayscore],
		[status],[statusID],[ruben],[comstatus],[betid],[SecAcceptFlag],[checktime],
		[username],[custid],[recommend],[mrecommend],[srecommend],
		[apositiontaking],[mpositiontaking],[spositiontaking],[tpositiontaking],[discount],[adiscount],[sdiscount],
		[IP]
	)
	SELECT
		[transid],[transdate],[matchid],[refno],[odds],[bettype],[betteam],
		[hdp1],[hdp2],[oddstype],[modds],[stake],[actual_stake],[liveindicator],[livehomescore],[liveawayscore],
		[status],[statusID],[ruben],[comstatus],[betid],[SecAcceptFlag],[checktime],
		[username],[custid],[recommend],[mrecommend],[srecommend],
		[apositiontaking],[mpositiontaking],[spositiontaking],[tpositiontaking],[discount],[adiscount],[sdiscount],
		[IP]
	FROM INSERTED
	WHERE statusID IN (0,1)
	*/
	--- @lukas: just for UAT time
	INSERT INTO bodb_AGE.dbo.bettrans_running (
		[transid],[transdate],[matchid],[refno],[odds],[bettype],[betteam],
		[hdp1],[hdp2],[oddstype],[modds],[stake],[actual_stake],[liveindicator],[livehomescore],[liveawayscore],
		[status],[statusID],[ruben],[comstatus],[betid],[SecAcceptFlag],[checktime],
		[username],[custid],[recommend],[mrecommend],[srecommend],
		[apositiontaking],[mpositiontaking],[spositiontaking],[tpositiontaking],[discount],[adiscount],[sdiscount],
		[IP],OddsID,BetCheck,OddsSpread,transdesc
	)
	SELECT
		[transid],[transdate],[matchid],[refno],[odds],[bettype],[betteam],
		[hdp1],[hdp2],[oddstype],[modds],[stake],[actual_stake],[liveindicator],[livehomescore],[liveawayscore],
		[status],[statusID],[ruben],[comstatus],[betid],[SecAcceptFlag],[checktime],
		[username],[custid],[recommend],[mrecommend],[srecommend],
		[apositiontaking],[mpositiontaking],[spositiontaking],[tpositiontaking],[discount],[adiscount],[sdiscount],
		[IP],OddsID,BetCheck,OddsSpread, transdesc
	FROM INSERTED
	WHERE statusID IN (0,1) 
END

