/*
	Create: 20191223
	Task: hot fix - https://nexdev.net/issues/125919
	DB: DBTXN/bodb02
	
	SELECT * FROM TicketVoiding_MessageTemplate with (nolock)
	WHERE TemplateId IN (8,29,30) 
		AND MsgEnglish LIKE '%Due to wrong HDP displayed%'

	SELECT * FROM TicketVoiding_MessageTemplate with (nolock)
	WHERE TemplateId IN (9,31,32)
		AND MsgEnglish LIKE '%Due to wrong 1H HDP displayed%'
	
*/

USE bodb02
GO

-- update template for 8, 29, 30
UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於亞洲盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "亞洲盤{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "亞洲盤{{Actual Market}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 8

UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於亞洲盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "{{Away team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "{{Home team name}} {{HDP Value}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "{{Away team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "{{Home team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "{{Away team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "{{Home team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 29

UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於亞洲盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "{{Home team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "{{Away team name}} {{HDP Value}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "{{Home team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "{{Away team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "{{Home team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "{{Away team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 30

-------update template for 9, 31, 32
UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於上半場亞洲盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "上半場亞洲盤{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "上半場亞洲盤{{Actual Market}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于上半场亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于上半场亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场亚洲盘{{Wrong Market}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场亚洲盘{{Actual Market}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 9

UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於上半場亞洲盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "上半場  {{Away team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "上半場  {{Home team name}} {{HDP Value}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于上半场亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场  {{Away team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场  {{Home team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于上半场亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场  {{Away team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场  {{Home team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 31

UPDATE ts
	SET MsgChineseTraditional = N'請注意:[{{Sport type}}] 由於上半場亞洲盤顯示錯誤, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注單: "@@" 投注於 "上半場 {{Home team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作廢. 過關以(1)計算. 正確盤口為 "上半場 {{Away team name}} {{HDP Value}}". {{CheckStatement}}不便之處 敬請見諒!'
	,MsgChineseSimplified = N'请注意:[{{Sport type}}] 由于上半场亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场 {{Home team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场 {{Away team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
	,MsgChineseNewSimplified = N'请注意:[{{Sport type}}] 由于上半场亚洲盘显示错误, "{{Home team name}} -vs- {{Away team name}}" [{{League name}} - {{Event Date}}{{Event type}}], 注单: "@@" 投注于 "上半场 {{Home team name}} {{HDP Value}}" {{FromTimeRange}}{{Score}}已被作废. 过关以(1)计算. 正确盘口为 "上半场 {{Away team name}} {{HDP Value}}". {{CheckStatement}}不便之处 敬请见谅!'
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 32

---- Replace for the change #125323
	
UPDATE TicketVoiding_MessageTemplate WITH (ROWLOCK)
SET MsgChineseTraditional = REPLACE (MsgChineseTraditional,N'由於亞洲盤顯示錯誤',N'由於讓球盤顯示錯誤')
	, MsgChineseSimplified = REPLACE (MsgChineseSimplified,N'由于亚洲盘显示错误',N'由于让球盘显示错误')
	, MsgChineseNewSimplified = REPLACE (MsgChineseNewSimplified,N'由于亚洲盘显示错误',N'由于让球盘显示错误')
WHERE TemplateId IN (8,29,30)
	AND MsgEnglish LIKE '%Due to wrong HDP displayed%'
	
UPDATE TicketVoiding_MessageTemplate WITH (ROWLOCK)
SET MsgChineseTraditional = REPLACE (MsgChineseTraditional,N'由於上半場亞洲盤顯示錯誤',	N'由於上半場讓球盤顯示錯誤')
	, MsgChineseSimplified = REPLACE (MsgChineseSimplified,N'由于上半场亚洲盘显示错误',	N'由于上半场让球盘显示错误')
	, MsgChineseNewSimplified = REPLACE (MsgChineseNewSimplified,N'由于上半场亚洲盘显示错误',N'由于上半场让球盘显示错误')
WHERE TemplateId IN (9,31,32)
	AND MsgEnglish LIKE '%Due to wrong 1H HDP displayed%'

