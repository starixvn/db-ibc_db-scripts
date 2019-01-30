DECLARE @xml_resource varchar(max), @matchID int, @timeStart DATETIME, @timeEnd DATETIME
-------------------------------------------------------------------------------

SET @matchid = (SELECT TOP 1 MatchID FROM DBPRO.bodb02.dbo.Match WHERE matchcode ='VK_20190130_1')
SELECT 'matchid',@matchid
SET @xml_resource = '<Resources><rsc m="100000237"/><rsc m="100000238"/></Resources>'	



-------------------------------------------------------------------------------


DECLARE @ErrCode INT,@ErrMsg NVARCHAR(200)
SELECT @ErrCode = 0,@ErrMsg=''
EXEC NAP_Admin_Settlement_BetBuilder_push_UAT1 @MatchId=@matchid
			,@action='CAL'
			,@IsAuto=1
			,@Resources = @xml_resource
			,@ErrCode=@ErrCode OUTPUT
			,@ErrMsg=@ErrMsg OUTPUT
SELECT @ErrCode,@ErrMsg
