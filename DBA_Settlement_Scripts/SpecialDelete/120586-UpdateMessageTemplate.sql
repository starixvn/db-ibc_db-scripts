USE bodb02
GO
/*
	Created: 20190930@Kathy
	Task: update message template - [Redmine:#120586]
	DB: DBTXN/bodb02
*/

/*
SELECT JsonValue
FROM TicketVoiding_MessageTemplate
WHERE TemplateId = 35

-- [{"Name":"Score","MsgEnglish":"Wrong Score","MsgChineseTraditional":"Wrong Score (TC)","MsgChineseSimplified":"Wrong Score (SC)","MsgChineseNewSimplified":"Wrong Score (New SC)"}]

*/


UPDATE TicketVoiding_MessageTemplate
	SET JsonValue = '[{"Name":"Score","MsgEnglish":"Wrong Score","MsgChineseTraditional":"Wrong Score (TC)","MsgChineseSimplified":"Wrong Score (SC)","MsgChineseNewSimplified":"Wrong Score (New SC)","Pattern":"Ex: 1-0"}]'
WHERE TemplateId = 35


