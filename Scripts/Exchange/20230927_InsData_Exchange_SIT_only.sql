/*<info serverAlias="DBCUST-CustDB"></info>*/
/*
	Created: 20230927@Evan
	DB: DBCUST-CustDB
	Task: insert data exchange
	
*/
USE CustDB;
GO

INSERT INTO exchange ([exchangeid], [currency], [stakerate], [actualrate], [commaxpayout], [creator], [minbet], [minbetlive], [AUDRate], [ZARRate], [GBPRate], [EURORate], [US$Rate], [Code], [Description], [MultipliedBy], [ExVirtualRate], [OfferSite], [IsActive], [RepUpdateTime], [CurrencyType], [CreditGroupID], [LicenseeGroupID])
VALUES (210, 'DZD', null, 0.03397, null, '22040268', 1, 1, null, null, null, null, null, 'DZD', 'Algerian Dinar', 1, null, 2, 1, '2023-09-27 04:52:09.4093714', '0', null, null),
       (211, 'MAD', null, 0.45142, null, '22040268', 1, 1, null, null, null, null, null, 'MAD', 'Moroccan Dirham', 1, null, 2, 1, '2023-09-27 04:53:02.1327829', '0', null, null),
       (212, 'FRF', null, 0.75603, null, '22040268', 1, 1, null, null, null, null, null, 'FRF', 'French Franc', 1, null, 2, 1, '2023-09-27 04:53:35.5950318', '0', null, null);

GO
