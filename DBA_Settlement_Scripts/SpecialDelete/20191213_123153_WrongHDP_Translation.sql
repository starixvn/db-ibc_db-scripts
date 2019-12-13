/*
	Created: 20191213@Max 
	Task: WrongHDP Translation - [Redmine: #123153]
	DB: DBTRANS/bodb02
*/
USE bodb02
GO

UPDATE TicketVoiding_MessageTemplate WITH (ROWLOCK)
SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於讓球盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "亞洲盤{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "亞洲盤{{Actual Market}}". {{CheckStatement}}不便之處 敬請見諒!'
	, MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
	, MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
WHERE TemplateId IN (8,29,30)
	AND MsgEnglish LIKE '%Due to wrong HDP displayed%'
	
UPDATE TicketVoiding_MessageTemplate WITH (ROWLOCK)
SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於上半場讓球盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "上半場亞洲盤{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "上半場亞洲盤{{Actual Market}}". {{CheckStatement}}不便之處 敬請見諒!'
	, MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于上半场让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
	, MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于上半场让球盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
WHERE TemplateId IN (9,31,32)
	AND MsgEnglish LIKE '%Due to wrong 1H HDP displayed%'

GO