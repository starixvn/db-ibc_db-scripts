Use CUSTDB 
GO 

/*
Create : 20190410@Sophia
Task: Create table CS_HeadlineExtraPTGroup  [redmine: #111696]

*/

CREATE TABLE dbo.CS_HeadlineExtraPTGroup 
(
HeadlineId INT NOT NULL,
GroupID INT NOT NULL,

CONSTRAINT [PK_CS_HeadlineExtraPTGroup] PRIMARY KEY CLUSTERED 
(	HeadlineId ASC,	GroupId ASC
) 
) ON [DATA]
 