/*
	Created: 20190318@Helen
	Database: DBARC.bodb_archive
	Original: 
	
	Revisions:
		- 20191126@Helen: Archive TO Control - copy [Redimine:98467]
 */
USE bodb_archive
GO
ALTER TABLE TOControl_Setting_bk 
ADD winlostdate DATETIME