USE [bodb02]
GO
/****** Object:  StoredProcedure [dbo].[DBA_Fast_Market_ResultDetailUpd]    Script Date: 05/09/2017 14:07:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[DBA_Fast_Market_ResultDetailUpd] @MatchId int, @bettype smallint = 0, @mode int = 1
as
/*	Creator: 20160303@Patrick
	Task: DBA - Generate 
	DB: DBTXN/BODB02
	Original: 
	
	Revisions:
		
	Param's Explanation:
	 - @mode: 1: insert 
			  2: select

	exec DBA_Fast_Market_ResultDetailUpd @MatchId = 71000001, @bettype = 0, @mode = 1
	exec DBA_Fast_Market_ResultDetailUpd @MatchId = 17162430, @bettype = 0, @mode = 1
	exec DBA_Fast_Market_ResultDetailUpd @MatchId = 17765474, @bettype = 0, @mode = 1
	exec DBA_Fast_Market_ResultDetailUpd @MatchId = 71000001, @bettype = 0, @mode = 1
	exec DBA_Fast_Market_ResultDetailUpd @MatchId = 71000050, @bettype = 0, @mode = 1

*/
begin
	set nocount on

	declare @results table(resourceid varchar(50), homevalue varchar(50), awayvalue varchar(50))
	declare @BetOptions table (rowid int identity(0,1), option_name varchar(100) unique
			, option_binary varchar(8), option_ascii tinyint, option_char varchar(1))

	declare @maxoption int, @optionId int, @option_name_temp varchar(100)
		, @option_ascii_temp tinyint, @optionId_temp int

	insert into @BetOptions(option_name, option_binary, option_ascii, option_char)
	select option_name, option_binary, option_ascii, option_char 
	from dbo.f_DBA_Fast_Market_GenerateBetOptions() order by newid()
	set @maxoption = @@rowcount

	select * from @BetOptions where option_name = 'CornersFreeKickGoalKickPenalty'
	

	declare @index int = 0, @count int = 0
		, @betoption tinyint, @option_name varchar(100)
		, @homevalue_221 varchar(50) = replicate(char('0'), 50), @awayvalue_221 varchar(50) = replicate(char('0'), 50)
		, @homevalue_222 varchar(50) = replicate(char('0'), 50), @awayvalue_222 varchar(50) = replicate(char('0'), 50)
		, @homevalue_223 varchar(50) = replicate(char('0'), 50), @awayvalue_223 varchar(50) = replicate(char('0'), 50)
		, @homevalue_224 varchar(50) = replicate(char('0'), 50), @awayvalue_224 varchar(50) = replicate(char('0'), 50)
		, @homevalue_225 VARCHAR(50) = REPLICATE(CHAR('0'), 50), @awayvalue_225 VARCHAR(50) = REPLICATE(CHAR('0'), 50)

	declare @options_name table(option_name varchar(100))
	
	while @index <= 89
	begin
		delete from @options_name

		if @count = @maxoption
			set @count = 0

		set @optionId = @count
		set @count += 1

		select @betoption = option_ascii, @option_name = option_name from @betoptions where rowid = @optionId
	
		insert into @options_name(option_name)
		select val from dbo.strSplit(@option_name, '_')

		--print @optionId
		--for bettype 221
		if @bettype = 0 or @bettype = 221
		begin
			select @option_name_temp = null, @option_ascii_temp = 0
			select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
			from @options_name where option_name not in ('Bookings', 'Penalty')

			if exists (select 1 from @betoptions where option_name = @option_name_temp)
				select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			else 
				select @option_ascii_temp = option_ascii from @betoptions where option_name = 'None'

			if @index <= 44
				select @homevalue_221 = (select data  FROM dbo.f_Set_SetByte_xtest(@homevalue_221, @index, @option_ascii_temp))
			else
				select @awayvalue_221 = (SELECT data FROM dbo.f_Set_SetByte_xtest(@awayvalue_221, @index, @option_ascii_temp))
		end

		--for bettype 222
		if @bettype = 0 or @bettype = 222
		begin
			select @option_name_temp = null, @option_ascii_temp = 0
			select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
			from @options_name where option_name not in ('Free-Kick', 'Goal-Kick', 'Throw-In', 'Bookings')

			if exists (select 1 from @betoptions where option_name = @option_name_temp)
				select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			else 
				select @option_ascii_temp = ascii(replicate(char('0'), 8))

			if @index <= 85
			begin
				if @index <= 44
					select @homevalue_222 = (select data  FROM dbo.f_Set_SetByte_xtest(@homevalue_222, @index, @option_ascii_temp))
				else
					select @awayvalue_222 = (select data  FROM dbo.f_Set_SetByte_xtest(@awayvalue_222, @index, @option_ascii_temp))
			end
		end

		--for bettype 223
		if @bettype = 0 or @bettype = 223
		begin
			select @option_name_temp = null, @option_ascii_temp = 0
			select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
			from (
				select top 1 option_name
				from @options_name where option_name not in ('Bookings', 'Penalty')
			)t

			if exists (select 1 from @betoptions where option_name = @option_name_temp)
				select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			else 
				select @option_ascii_temp = ascii(replicate(char('0'), 8))

			if @index <= 44
				select @homevalue_223 = (select data  FROM dbo.f_Set_SetByte_xtest(@homevalue_223, @index, @option_ascii_temp))
			else
				select @awayvalue_223 = (select data  FROM dbo.f_Set_SetByte_xtest(@awayvalue_223, @index, @option_ascii_temp))
		end

		--for bettype 224
		if @bettype = 0 or @bettype = 224
		begin
			select @option_name_temp = null, @option_ascii_temp = 0
			select @option_name_temp = coalesce(@option_name_temp + '_' + cast(option_name as varchar), cast(option_name as varchar))
			from (
				select top 1 option_name
				from @options_name where option_name not in ('Free-Kick', 'Goal-Kick', 'Throw-In')
			)t

			if exists (select 1 from @betoptions where option_name = @option_name_temp)
				select @option_ascii_temp = option_ascii from @betoptions where option_name = @option_name_temp
			else 
				select @option_ascii_temp = ascii(replicate(char('0'), 8))

			if @index <= 85
			begin
				if @index <= 44
					select @homevalue_224 = (select data  FROM dbo.f_Set_SetByte_xtest(@homevalue_224, @index, @option_ascii_temp))
				else
					select @awayvalue_224 = (select data  FROM dbo.f_Set_SetByte_xtest(@awayvalue_224, @index, @option_ascii_temp))
			end
		end
		
		--for bettype 225
		if @bettype = 0 or @bettype = 225
		begin
			select @option_name_temp = null, @option_ascii_temp = 0
			
			select TOP 1 @option_name_temp = option_name
			from @options_name where option_name IN ( 'CornersFreeKickGoalKickPenalty', 'none')
			
			if @index <= 44
				select @homevalue_225 = (select data  FROM dbo.f_Set_SetByte_xtest(@homevalue_225, @index, 156))
			else
				select @awayvalue_225 = (select data  FROM dbo.f_Set_SetByte_xtest(@awayvalue_225, @index, 156))
		end
		
		set @index = @index + 1
	end
	
	if @mode = 1
	begin
		if @bettype = 0 or @bettype = 221
		begin
			delete from dbo.ResultDetail with(rowlock) 
			where matchid = @matchid and resourceid in (22100,22101)

			insert into dbo.ResultDetail(MatchId, ResourceId, HomeValue, AwayValue)
			select @matchid, (221 * 100) as ResourceId, replicate(2, 50) as HomeValue, replicate(2, 50) as AwayValue union --221 - result status
			select @matchid, (221 * 100) + 1 as ResourceId
				, @homevalue_221 + replicate(char('0'), 50 - datalength(@homevalue_221)) as HomeValue
				, @awayvalue_221 + replicate(char('0'), 50 - datalength(@awayvalue_221)) as AwayValue --221 - result
		end

		if @bettype = 0 or @bettype = 222
		begin
			delete from dbo.ResultDetail with(rowlock) 
			where matchid = @matchid and resourceid in (22200,22201)

			insert into dbo.ResultDetail(MatchId, ResourceId, HomeValue, AwayValue)
			select @matchid, (222 * 100) as ResourceId, replicate(2, 50) as HomeValue, replicate(2, 50) as AwayValue union --222 - result status
			select @matchid, (222 * 100) + 1 as ResourceId
				, @homevalue_222 + replicate(char('0'), 50 - datalength(@homevalue_222)) as HomeValue
				, @awayvalue_222 + replicate(char('0'), 50 - datalength(@awayvalue_222)) as AwayValue
		end

		if @bettype = 0 or @bettype = 223
		begin
			delete from dbo.ResultDetail with(rowlock) 
			where matchid = @matchid and resourceid in (22300,22301)

			insert into dbo.ResultDetail(MatchId, ResourceId, HomeValue, AwayValue)
			select @matchid, (223 * 100) as ResourceId, replicate(2, 50) as HomeValue, replicate(2, 50) as AwayValue union --223 - result status
			select @matchid, (223 * 100) + 1 as ResourceId
				, @homevalue_223 + replicate(char('0'), 50 - datalength(@homevalue_223)) as HomeValue
				, @awayvalue_223 + replicate(char('0'), 50 - datalength(@awayvalue_223)) as AwayValue
		end

		if @bettype = 0 or @bettype = 224
		begin
			delete from dbo.ResultDetail with(rowlock) 
			where matchid = @matchid and resourceid in (22400,22401)

			insert into dbo.ResultDetail(MatchId, ResourceId, HomeValue, AwayValue)
			select @matchid, (224 * 100) as ResourceId, replicate(2, 50) as HomeValue, replicate(2, 50) as AwayValue union --223 - result status
			select @matchid, (224 * 100) + 1 as ResourceId
				, @homevalue_224 + replicate(char('0'), 50 - datalength(@homevalue_224)) as HomeValue
				, @awayvalue_224  + replicate(char('0'), 50 - datalength(@awayvalue_224))as AwayValue --223 - result
		end
		
		if @bettype = 0 or @bettype = 225
		begin
			delete from dbo.ResultDetail with(rowlock) 
			where matchid = @matchid and resourceid in (22500,22501)
			
			insert into dbo.ResultDetail(MatchId, ResourceId, HomeValue, AwayValue)
			select @matchid, (225 * 100) as ResourceId, replicate(2, 50) as HomeValue, replicate(2, 50) as AwayValue union 
			select @matchid, (225 * 100) + 1 as ResourceId
				, @homevalue_225 + replicate(char('0'), 50 - datalength(@homevalue_225)) as HomeValue
				, @awayvalue_225 + replicate(char('0'), 50 - datalength(@awayvalue_225)) as AwayValue 
		end

		select * from dbo.ResultDetail where matchid = @matchid
	end
	else if @mode = 2
	begin
		select *
		from (
			select 221 as bettype, f.pos as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@homevalue_221) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 221 as bettype, f.pos + 45 as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@awayvalue_221) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 222 as bettype, f.pos as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@homevalue_222) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 222 as bettype, f.pos + 45 as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@awayvalue_222) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 223 as bettype, f.pos as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@homevalue_223) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 223 as bettype, f.pos + 45 as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@awayvalue_223) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 224 as bettype, f.pos as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@homevalue_224) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 224 as bettype, f.pos + 45 as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@awayvalue_224) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45
			
			UNION ALL
			select 225 as bettype, f.pos as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@homevalue_225) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

			union all
			select 225 as bettype, f.pos + 45 as Position, f.bitmap as BetOption, ff.ResultStatus
			from dbo.f_Set_GetBytes_xtest(@awayvalue_225) f
				inner join dbo.f_Set_GetChars_xtest(replicate(2, 50)) ff on f.pos = ff.pos
			where f.pos < 45

		)t
		where (bettype IN (222,224) AND Position <= 85)
			or bettype IN (221,223, 225)
		--exec dbo.NAP_Set_FastMarket_MatchSelDetail @MatchId = @matchid
	end

end
