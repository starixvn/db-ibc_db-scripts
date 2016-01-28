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
FROM	dbo.custInfo AS ci WITH(NOLOCK)
WHERE	ci.custid > @maxCustID_1
	AND	ci.custid <= @maxCustID_2
	AND	NOT EXISTS (
			SELECT	TOP(1) 1
			FROM	dbo.Dep_CustSuper AS dcs WITH(NOLOCK)
			WHERE	dcs.custid = ci.custid
		);
GO

-- Modify virtual rate settings for deposit super lines --
DECLARE	@custid			INT
	,	@maxCustID_1	INT = xxxx
	,	@maxCustID_2	INT = xxxx;

UPDATE	cvs WITH(ROWLOCK,UPDLOCK)
SET		cvs.bitmapVirtual =	CONVERT(
								BINARY(64)
							,	REPLACE(
									REPLACE(	cvs.bitmapVirtual
											,	CAST(CAST(50 AS BINARY(1)) AS VARCHAR)	-- Virtual Rate -50%
											,	CAST(CAST(30 AS BINARY(1)) AS VARCHAR)	-- replaced with Virtual Rate -70%
											)
								,	CAST(CAST(40 AS BINARY(1)) AS VARCHAR)	-- Virtual Rate -60%
								,	CAST(CAST(30 AS BINARY(1)) AS VARCHAR)	-- replaced with Virtual Rate -70%
								)
							)
FROM		dbo.CustVirtualSetting AS cvs
INNER JOIN	##customers AS c
		ON	c.CustID = cvs.custid
WHERE	cvs.bitmapVirtual LIKE '%[' + CAST(CAST(50 AS BINARY(1)) AS VARCHAR) + CAST(CAST(40 AS BINARY(1)) AS VARCHAR) + ']%'
	AND	cvs.custid > @maxCustID_1
	AND	cvs.custid <= @maxCustID_2;
GO