
/*
	Created by Winnie
	Date: 2018-03-19
	DB: DBCRM.bodb_CRM
	Task: Update col Description. Run in UM
*/

CREATE TABLE #temp(FeedbackID INT, Description NVARCHAR(MAX))

INSERT INTO #temp(FeedbackID,Description)
SELECT FeedbackID,(SELECT '' AS AutoField, Description AS Remark
               FOR XML RAW,ROOT('ROOT'))  
FROM crmFeedback(NOLOCK)
WHERE FeedbackID NOT IN(24571,40926,80165,412192,413912)

INSERT INTO #temp(FeedbackID,Description)
SELECT 24571,(SELECT '' AS AutoField, 'Actual date &amp; time: 9-July-2012 03:23 PM<br>Contact via:&nbsp; skype3129 (skype)<br><br>Super skype request us call to his master s989rk1 (13926890096).due to he has some trouble to login with our agency site.<br>When called to master, he said he login with our agency site, and when click into report, he will back to the login page.<br>Browser: IE8<br>Website : ag.729972.com, agt.t3999.com.<br>Delete cookie &amp; file already.<br>' AS Remark
               FOR XML RAW,ROOT('ROOT'))  

INSERT INTO #temp(FeedbackID,Description)
SELECT 40926,(SELECT '' AS AutoField, 'Actual Date &amp; Time: 22-Nov-2012 09:24 PM<br>Contact Via: here20002 (Skype)<br><br>Super request to get the list of down line member''s for the rejected/voided/refunded tickets from 12/11/2012 to 18/11/2012? due to his boss needed.<br><br>Super: S989N (All downlines)<br>Super S989R -&gt; Master S989RL1 (All downlines)<br>Date: 12/11/12 - 18/11/12<br><br>Super leave down his contact details as below;<br><br>QQ (Chinese Language)：<br>&nbsp;2499688355<br>&nbsp;2228667248<br><br>Mobile Phone: 8615814373740' AS Remark
               FOR XML RAW,ROOT('ROOT'))  


INSERT INTO #temp(FeedbackID,Description)
SELECT 80165,(SELECT '' AS AutoField, 'Actual date &amp; time:4-Oct-13&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.16PM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br>Contact :skype3129(Skype)<br>Contact:&nbsp; (Outgoing)008613670253693,008615916916567,0086 13640809899,0086 13066978662&nbsp;&nbsp; <br>Handle by:Coey <br><br>Question 1:Super skype in claimed that he is Super s989r, he claimed that he saw the message from Agency site which informed that effective from now our Company will request all SMAs level must set the Sportbook Min PT as 40%&nbsp; so he call to confirm it.<br><br>Question 2: Super asked that can he set the min PT for his downline?' AS Remark
               FOR XML RAW,ROOT('ROOT'))  

INSERT INTO #temp(FeedbackID,Description)
SELECT 412192,(SELECT '' AS AutoField, '20170929/04:02AM/LiveChat <br>Actual Date &amp; Time : 30-Sept -2017, 4:02AM <br><br>Member asked for payout for below ticket:<br><br>&nbsp;Ref No: 102733994066<br>9/29/2017 2:54:04 PMOver 141.5 [Live]<br>Over/Under<br>BC Tsmoki-Minsk (BLR) - vs - Nanterre 92 (FRA)<br>Basketball Basketball Champions League Qualification<br><br>' AS Remark
               FOR XML RAW,ROOT('ROOT'))  


INSERT INTO #temp(FeedbackID,Description)
SELECT 413912,(SELECT '' AS AutoField, '20171004/11:27PM/What''sApp - (Headline-S56RM Group)<br><br>Mr.Hock request to check below member betting behavior member ticket whether is normal due to Agent claim that Member win a lot. <br><br>Username: S56IISY01034<br>Site : INDO<br>Account created date: &nbsp;&nbsp;&nbsp; 9/11/2017 5:02 AM (System time)<br>Product : Gold Deluxe<br>Check date: 11-Sep-2017 till 04-Oct-2017<br>Net Turnover: 957,413.89 &nbsp;&nbsp;&nbsp; <br>Win/Lose amount: 21,777.50 <br>Winning margin: 2.27%<br>S/M/A PT: 93% / 0% / 0%<br><br>Username: S56IISY01039&nbsp; <br>Site : &nbsp;&nbsp;&nbsp; INDO<br>Account created date: &nbsp;&nbsp;&nbsp; 9/12/2017 8:16 PM (System time)<br>Product : Gold Deluxe<br>Check date: 12-Sep-2017 till 04-Oct-2017<br>Net Turnover: 1,035,423.85 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <br>Win/Lose amount: -50,259.00<br>Winning margin: -4.85%<br>S/M/A PT: 93% / 0% / 0%<br><br>' AS Remark
               FOR XML RAW,ROOT('ROOT'))  

UPDATE c
set c.Description=t.Description
FROM
crmFeedback c WITH(ROWLOCK,UPDLOCK)
INNER JOIN #temp t ON c.FeedbackID=t.FeedbackID

DROP TABLE #temp
