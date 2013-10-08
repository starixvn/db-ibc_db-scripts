/*-------------------------------------------------------------------
TaskID = 6461
Change Xintiandi Licensee Name to XTD1
---------------------------------------------------------------------*/

Declare @ErrCode int
Declare @ErrMsg nvarchar(4000)
---------------------------------
EXEC dbo.DBA_Lrf_ChangeLicenseeName 
@OldLicenseeName = 'Xintiandi',
@NewLicenseeName = 'XTD1',
@ErrCode = @ErrCode OUTPUT,
@ErrMsg = @ErrMsg OUTPUT
---------------------------------
select 
@ErrCode as ErrCode,
@ErrMsg as ErrMsg

