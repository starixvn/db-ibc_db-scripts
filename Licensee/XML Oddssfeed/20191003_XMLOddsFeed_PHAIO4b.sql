use bodb_oddsfeed
go

/*
	Created: 20191003@Percy
	DB: DBODDSFEED.bodb_oddsfeed
	Task: PHAIO 4b - Add new bet types + Remove bet type 11 and 199
*/

-- Remove bet type 11 and 199
update dbo.SystemSetting with (rowlock)
set SValue = REPLACE(REPLACE(SValue, ',11,', ','), ',199,', ',')
where SName = 'SupportedBettypes' and Type = 'BetTypes'
go


-- Add bet types of PHAIO 4b
update dbo.SystemSetting with (rowlock)
set SValue = SValue + ',467,470,471,472,473,474,475,476,477,478,479,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497'
where SName = 'SupportedBettypes' and Type = 'BetTypes'
go