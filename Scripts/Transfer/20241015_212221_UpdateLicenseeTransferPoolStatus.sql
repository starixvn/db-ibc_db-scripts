/*<info serverAlias="DBCTG-bodb02" isFunction="0" isNested=""></info>*/
/*
	Created: 20220809@Danny
	DB: DBCTG.bodb02
	Task: update licensee transfer pool status [Redmind: #195120]

*/

USE bodb02

GO 

-- 1 rows
UPDATE dbo.LicenseeTransferPool WITH(ROWLOCK)
SET	 Status = 'Skipped'
WHERE Status = 'Failed'

