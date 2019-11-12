/*
	Task: Reactivate all dormant members of VCBA - https://nexdev.net/issues/108285
	Creator: Dominic@20190122
	Run at: CustDB@DBCUST
*/
USE CustDB

--Comma separated string of CustID,e.g, '20777706,20777707,20777708'
DECLARE @LstCustID VARCHAR(MAX)

SELECT @LstCustID = STUFF((
		SELECT ',' + CAST(CustID as VARCHAR(15))
		FROM Dep_Customer_Archived
		WHERE username like 'VCBA%'
			AND Status='completed'
		FOR XML PATH('')
		), 1, 1, '');

CREATE TABLE #CustID(CustID INT, IsExecuted BIT)


DECLARE @XML XML
SET @XML = N'<root><r>' + REPLACE(@LstCustID, ',', '</r><r>') + '</r></root>'

INSERT INTO #CustID(CustID,IsExecuted) 
SELECT r.value('.','INT'),0
FROM @xml.nodes('//root/r') AS RECORDS(r)

CREATE UNIQUE CLUSTERED INDEX IX_Cust ON #CustID(CustID)

DELETE #CustID
WHERE CustID IN (SELECT CustID FROM Customer (NOLOCK))

DECLARE @CustID INT

WHILE EXISTS(SELECT 1 FROM #CustID WHERE IsExecuted=0)
BEGIN
	UPDATE TOP(1) t
	SET IsExecuted=1
		,@CustID=CustID
	FROM #CustID t
	WHERE IsExecuted=0

	EXEC [Dot_Dep_Customer_Archive_ReactiveCustomer] @CustID  = @CustID
	
	WAITFOR DELAY '00:00:00.030'
END

DROP TABLE #CustID
 
