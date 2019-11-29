/*
	Created: 20191129@Max 
	Task: TicketListing and WrongScoreMsg - [Redmine: #124516]
	DB: DBTRANS/bodb02
*/
USE bodb02
GO

UPDATE TicketVoiding_SubIssueType 
	SET SubIssueTypeName = 'No Onwards'
WHERE SubIssueTypeId = 7

SET IDENTITY_INSERT TicketVoiding_SubIssueType ON
INSERT INTO TicketVoiding_SubIssueType (SubIssueTypeId,IssueTypeId,SubIssueTypeName)
VALUES (35,3,'Onwards')
SET IDENTITY_INSERT TicketVoiding_SubIssueType OFF

INSERT [dbo].[TicketVoiding_MessageTemplate] ([TemplateId], [MsgEnglish], [MsgChineseTraditional]
, [MsgChineseSimplified]
, [MsgChineseNewSimplified]
, [JsonValue], [CreatedDate], [ModifiedDate], [Creator], [LastModifiedBy]) 
VALUES (36
, N'Attn:[{{Sport type}}] Due to wrong score displayed, the match between "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], bet ID: "@@" {{PlacedFromTimeRange}}{{WrongScoreOW}}are considered VOID. Parlay counted as (1). The actual score is "{{Actual ScoreOW}}". {{CheckStatement}}Sorry for the inconvenience caused!'
, N'請注意:[{{Sport type}}] 由於比分顯示錯誤,"{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" {{PlacedFromTimeRange}}{{WrongScoreOW}}已被作廢. 過關以(1)計算. 正確比分為 "{{Actual ScoreOW}}". {{CheckStatement}}不便之處 敬請見諒!'

, N'请注意:[{{Sport type}}] 由于比分显示错误,"{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" {{PlacedFromTimeRange}}{{WrongScoreOW}}已被作废. 过关以(1)计算. 正确比分为 "{{Actual ScoreOW}}". {{CheckStatement}}不便之处 敬请见谅!'
, N'请注意:[{{Sport type}}] 由于比分显示错误,"{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" {{PlacedFromTimeRange}}{{WrongScoreOW}}已被作废. 过关以(1)计算. 正确比分为 "{{Actual ScoreOW}}". {{CheckStatement}}不便之处 敬请见谅!'

, N'[{"Name":"WrongScoreOW","MsgEnglish":"Wrong Score","MsgChineseTraditional":"Wrong Score (TC)","MsgChineseSimplified":"Wrong Score (SC)","MsgChineseNewSimplified":"Wrong Score (New SC)","Pattern":"Ex: 1-0"},{"Name":"ActualScoreOW","MsgEnglish":"Actual Score","MsgChineseTraditional":"Actual Score (TC)","MsgChineseSimplified":"Actual Score (SC)","MsgChineseNewSimplified":"Actual Score (New SC)","Pattern":"Ex: 1-0"}]'
, NULL, NULL, NULL, NULL)

INSERT INTO TicketVoiding_MessageTemplateSetting (TemplateId, SubIssueTypeId)
VALUES (36,35)

GO