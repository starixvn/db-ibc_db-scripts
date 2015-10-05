---DBCUST.CustDB

USE bodb02
GO 

INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'MaxLimit', 200000)
INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'WinningShareSuper', 0.3)
INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'WinningShareMaster', 0.2)
INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'WinningShareAgent', 0.1)

GO
