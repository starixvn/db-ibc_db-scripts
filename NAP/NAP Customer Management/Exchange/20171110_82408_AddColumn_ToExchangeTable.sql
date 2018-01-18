USE CustDB
GO

/*
	Created: 20171110@Harper
	Description: Add column on Exchange table and initialize data for it [RedmineID: #82408]
*/

-- Add New Column 
ALTER TABLE dbo.exchange ADD ExVirtualRate FLOAT