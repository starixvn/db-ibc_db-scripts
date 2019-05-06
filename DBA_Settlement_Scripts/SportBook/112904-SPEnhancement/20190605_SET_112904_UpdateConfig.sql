/*
	Created: 20190506@Helen
	Task: Update config - SP Tuning Performance - Phase 1: Cal_1 & MP_Push - [Redmine:112904]
	DB: DBTRANS/MonDB
	
*/
USE MonDB
GO
UPDATE T
	SET AbnormalCost = 4000, NormalCost =  2000
FROM Mon_SPPF_List T WITH (ROWLOCK)
WHERE SPName = 'NAP_Admin_Settlement_MP_Push'

UPDATE T
	SET AbnormalCost = 20000, NormalCost = 5000 
FROM Mon_SPPF_List T WITH (ROWLOCK)
WHERE SPName = 'NAP_Admin_Calculate_1'

