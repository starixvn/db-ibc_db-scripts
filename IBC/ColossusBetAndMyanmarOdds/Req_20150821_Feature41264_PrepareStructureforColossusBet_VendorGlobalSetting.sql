
/*  
    Created By: Helen  
    Created Date: Aug 18, 2015
    Description: # Colossus Bet Product - [Redmine: #42208]
    
    DB: DBTXN/bodb02  
*/  


USE bodb02
GO
CREATE TABLE VendorGlobalSetting (VendorID INT,VName VARCHAR(50),NumberValue DECIMAL(19,6))

GO

INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'MaxLimit', 200000)
INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'WinningShareSuper', 0.1)
INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'WinningShareMaster', 0.1)
INSERT INTO VendorGlobalSetting (VendorID,VName,NumberValue) VALUES (4, 'WinningShareAgent', 0.1)

GO
