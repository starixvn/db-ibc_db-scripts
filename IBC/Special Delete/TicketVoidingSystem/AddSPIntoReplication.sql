/*<info serverAlias="DBTXN-bodb02" executers="bodbAdminNet" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[TicketVoiding_Admin_VoidingTransId]
	@TransIds	VARCHAR(MAX)
	,@UserId	INT
AS
/*	Created by: Kathy
	Date 20181212
	Task: void ticket [Redmine:#90155]
	DB: DBTrans_ExecRep
	
	Revisions: 
		- 20181212@Kathy: Create new SP [Redmine:#90155]
	
	Param's explanation:	
		@transIds = '<root>
						<r transid="104730774034" translogid="432934573" betid="1" isMG="1" actual_stake="100"/>
						<r transid="104729373985" />
					</root>'
					isMG: metric gaming ticket
*/
BEGIN
	SET NOCOUNT ON

END
GO

