/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20230802@Evan
	DB: DBCUST-CustDB
	Task: Gen data ExchangeDaily_Crypto for testing
	
*/
SET NOCOUNT ON

DECLARE @ExchangeDaily_Crypto TABLE (
       ExchangeId    INT,
       USDT   FLOAT
)

INSERT INTO @ExchangeDaily_Crypto  ( [ExchangeId], [USDT])
VALUES (136, 0.05855328069),
       (137, 0.09042824057),
       (138, 2.728927173),
       (139, 1.216745818),
       (140, 1.990519716),
       (141, 1.324588687),
       (142, 1),
       (143, 1),
       (144, 0.002115452572),
       (145, 0.005740487262),
       (146, 0.01939020469),
       (147, 0.006382915368),
       (148, 0.02492606703),
       (149, 0.03564301853),
       (150, 0.02283647449),
       (151, 0.4836200275),
       (152, 0.3821217996),
       (153, 0.2645174528),
       (154, 0.6424),
       (155, 0.10741443),
       (156, 1.117087685),
       (157, 0.7441856322),
       (158, 20.60077737),
       (159, 4.304548664),
       (160, 4.391910895),
       (161, 14.62584745),
       (162, 6.110961972),
       (163, 0.09272886862),
       (164, 1.97541289),
       (165, 0.6719403056),
       (166, 0.04461214718),
       (167, 2.820084288),
       (168, 0.001012674605),
       (169, 0.002608666993),
       (170, 3.099566458),
       (171, 1.002134345),
       (172, 0.03138955743),
       (173, 0.0003578687196),
       (174, 0.0631444571),
       (175, 0.001189917623),
       (176, 0.001371995913),
       (177, 0.1457007903),
       (178, 0.005517218611),
       (179, 0.01981868954),
       (180, 1.655844159),
       (181, 0.002488),
       (182, 0.004102532545),
       (183, 1.714315239),
       (184, 3.875812542),
       (185, 1.475841814),
       (186, 0.003994311331),
       (187, 2.380244873),
       (188, 0.206),
       (189, 0.1122681742),
       (190, 0.05380737931),
       (191, 0.001526325334),
       (192, 1.764567714),
       (193, 0.003751737711),
       (194, 3.32),
       (195, 16.12587286),
       (196, 0.0111784951),
       (197, 0.1537),
       (198, 0.004004992256),
       (199, 0.2031950755),
       (200, 1.594890182),
       (201, 3.41465822);

DECLARE @FromDate SMALLDATETIME = '20230901'
DECLARE @ToDate SMALLDATETIME = '20230930'
DECLARE @rowcount INT = 0

WHILE (@FromDate <= @ToDate)
BEGIN
       
       INSERT INTO ExchangeDaily_Crypto (ExchangeDate, ExchangeId, USDT)
       SELECT @FromDate, a.[ExchangeId], a.USDT
       FROM @ExchangeDaily_Crypto a LEFT JOIN ExchangeDaily_Crypto b WITH(NOLOCK) 
              ON a.ExchangeId = b.ExchangeId AND b.ExchangeDate = @FromDate
       WHERE b.ExchangeId IS NULL

       SET @rowcount = @@ROWCOUNT
       PRINT 'Done - ' + CONVERT (VARCHAR(20),@FromDate,105) +' - ' + CONVERT (VARCHAR(10),@rowcount) + ' rows affected' 
       SET @FromDate = DATEADD(DAY,1,@FromDate)

END
GO
