USE bodb_licensee
GO

/*
	Create : 20171220@Harper
	Task : Add Func Exchange Winloss [redmine:#86640]
*/

SET IDENTITY_INSERT Functions ON

INSERT INTO  Functions 
(
	FunctionId,
	Name,
	Description,
	ParentId,
	Url,
	IsMenu,
	IsActive,
	DisplayOrder,
	IsNew,
	FunctionKey,
	Environment,
	IsFunction
)
VALUES (77, 'Exchange Win loss', '', 3, 'ExchangeWinlossReport', 1, 1, 52, 1, 'ExchangeWinloss77', 'UAT', 1)
  
SET IDENTITY_INSERT Functions OFF