Declare @ErrCode int
Declare @ErrMsg nvarchar(4000)
---------------------------------
EXEC dbo.DBA_Lrf_ChangeLicenseeName 
@OldLicenseeName = @OldLicenseeName,
@NewLicenseeName = @NewLicenseeName,
@ErrCode = @ErrCode OUTPUT,
@ErrMsg = @ErrMsg OUTPUT
---------------------------------
select 
@ErrCode as ErrCode,
@ErrMsg as ErrMsg