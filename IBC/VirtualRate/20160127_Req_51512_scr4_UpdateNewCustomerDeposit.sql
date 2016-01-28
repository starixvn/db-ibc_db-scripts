/*
	Created: 20160127@Billy
	Task: Modify Virtual Rate data following new requirements
	DB: DBCUST/CustDB
*/

-- BEGIN STEP 1: DEPLOY THIS SCRIPT ON DBCUST/CustDB	 --
-----------------------------------------------------------

-- Select super lines for importing data --
DECLARE	@maxCustID_1	INT = xxxx
	,	@maxCustID_2	INT = xxxx;

CREATE TABLE	##customers (
					CustID		INT
				);

INSERT INTO ##customers (CustID)
SELECT	ci.custid
FROM		dbo.custInfo AS ci WITH(NOLOCK)
INNER JOIN	dbo.Dep_CustSuper AS dcs WITH(NOLOCK)
		ON	dcs.custid = ci.srecommend
WHERE	ci.custid > @maxCustID_1
	AND	ci.custid <= @maxCustID_2;
GO

-- Modify virtual rate settings for deposit super lines --
DECLARE	@custid			INT
	,	@maxCustID_1	INT = xxxx
	,	@maxCustID_2	INT = xxxx;

UPDATE	cvs WITH(ROWLOCK,UPDLOCK)
SET		cvs.bitmapVirtual =	CONVERT(
								BINARY(64)
							,	REPLACE(
									cvs.bitmapVirtual
								,	CAST(CAST(20 AS BINARY(1)) AS VARCHAR)	-- Virtual Rate -80%
								,	CAST(CAST(10 AS BINARY(1)) AS VARCHAR)	-- replaced with Virtual Rate -90%
								)
							)
FROM		dbo.CustVirtualSetting AS cvs
INNER JOIN	##customers AS c
		ON	c.CustID = cvs.custid
WHERE	cvs.bitmapVirtual LIKE '%[' + CAST(CAST(20 AS BINARY(1)) AS VARCHAR) + ']%'
	AND	cvs.custid > @maxCustID_1
	AND	cvs.custid <= @maxCustID_2;
GO