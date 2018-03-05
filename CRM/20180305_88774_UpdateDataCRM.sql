/*
	Created by Winnie
	Date: 2018-03-05
	DB: DBCRM.bodb_CRM
	Task: Update col Description. Run in UM
*/

CREATE TABLE #temp(FeedbackID INT, Description NVARCHAR(MAX))
INSERT INTO #temp(FeedbackID,Description)
SELECT FeedbackID,(SELECT '' AS AutoField, Description AS Remark
               FOR XML RAW,ROOT('ROOT'))  
FROM crmFeedback(NOLOCK)


UPDATE c
set c.Description=t.Description
FROM
crmFeedback c WITH(ROWLOCK,UPDLOCK)
INNER JOIN #temp t ON c.FeedbackID=t.FeedbackID
