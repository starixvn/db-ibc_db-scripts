Use CUSTDB 
GO 

/*
Create : 20190410@Sophia
Task: Create table CS_HeadlineExtraPTGroup  [redmine: #111696]
DB: DBCUST.CUSTDB
*/

CREATE TABLE dbo.CS_HeadlineExtraPTGroup 
(
HeadlineId INT NOT NULL,
GroupId INT NOT NULL,

CONSTRAINT [PK_CS_HeadlineExtraPTGroup] PRIMARY KEY CLUSTERED 
(	HeadlineId ASC,	GroupId ASC
) 
) ON [DATA]
 