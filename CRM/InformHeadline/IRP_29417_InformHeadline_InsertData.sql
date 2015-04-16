USE [bodb_CRM]
GO

INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45000, 'Done', 1, 1)
INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45001, 'Request to call back', 2, 1)
INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45002, 'No need to call', 3, 1)
INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45003, 'No reply', 4, 1)
INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45004, 'Uncontactable', 5, 1)
INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45005, 'Internal account', 6, 1)
INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45006, 'Never touch', 7, 1)
INSERT INTO crmSetting(SettingName, SettingID, SettingValue, DisplayOrder, IsActive) VALUES ('InformHeadlineStatus', 45007, 'Keep for reference', 8, 1)
          
GO
INSERT INTO crmLogAction (ActionID, SPName, ActionNameEN, IsInternal) VALUES (702, 'Acc_CRM_InformTitleStatusUpd', 'Update Inform Title Status', 0)
INSERT INTO crmLogAction (ActionID, SPName, ActionNameEN, IsInternal) VALUES (703, 'Acc_CRM_InformHeadlineSearchUpd', 'Update Inform Headline', 0)