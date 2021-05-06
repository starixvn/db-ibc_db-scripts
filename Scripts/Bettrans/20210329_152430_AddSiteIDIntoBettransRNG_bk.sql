/*<info serverAlias="DBARC-bodb_Archive" executers="bodbAdminNet" isFunction="0" isNested="0"></info>*/

/*
Created: 20210329@Malcolm
Task :  add SiteId into bettransRnG_bk [RedmineID : #152430]
DB: DBARC/bodb_Archive
*/

ALTER TABLE bettransRnG_bk
ADD SiteID VARCHAR(7) NULL