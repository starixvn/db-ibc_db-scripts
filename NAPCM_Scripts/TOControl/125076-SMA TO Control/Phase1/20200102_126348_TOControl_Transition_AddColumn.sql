/*
    Created: 20200102@Malcolm
	Task: Separate setting and notification into Live/Non-Live and bettypes - [Redmine: #126348]
	DB: DBAGE/bodb02
*/
USE bodb02
GO

ALTER TABLE [dbo].[TOControl_Transition]  ADD liveindicator  BIT NULL, bettypeID SMALLINT NULL
GO