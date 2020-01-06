/*
	Created: 20200106@Max 
	Task: Update message translation of Wrong HDP issue - [Redmine: #126628]
	DB: DBTXN/bodb02
*/
USE bodb02
GO

UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於讓球盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "讓球盤{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "讓球盤{{Actual Market}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "让球盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "让球盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "让球盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "让球盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 8

UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於上半場讓球盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "上半場讓球盤{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "上半場讓球盤{{Actual Market}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于上半场让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场让球盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场让球盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于上半场让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场让球盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场让球盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 9

