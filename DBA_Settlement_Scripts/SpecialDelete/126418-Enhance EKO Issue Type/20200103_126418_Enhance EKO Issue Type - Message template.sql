/*
	Created: 20200103@Max 
	Task: Enhance EKO Issue Type - [Redmine: #126418]
	DB: DBTXN/bodb02
*/
USE bodb02
GO

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 12

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 13

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 14

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 15

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 16

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 17

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 18

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 19

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 20

UPDATE ts
	SET MsgEnglish = REPLACE(ts.MsgEnglish, N'. Sorry for the inconvenience caused!', N'. {{CheckStatement}}Sorry for the inconvenience caused!')
	,MsgChineseTraditional = REPLACE(ts.MsgChineseTraditional, N'. 不便之處 敬請見諒!', N'. {{CheckStatement}}不便之處 敬請見諒!')
	,MsgChineseSimplified = REPLACE(ts.MsgChineseSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
	,MsgChineseNewSimplified = REPLACE(ts.MsgChineseNewSimplified, N'. 不便之处 敬请见谅!', N'. {{CheckStatement}}不便之处 敬请见谅!')
FROM TicketVoiding_MessageTemplate ts WITH (ROWLOCK)
WHERE ts.TemplateId = 21