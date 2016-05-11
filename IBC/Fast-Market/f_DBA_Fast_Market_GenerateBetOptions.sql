use bodb02
go
alter function [dbo].[f_DBA_Fast_Market_GenerateBetOptions] ()
returns @BetOptions table (rowid int identity(0,1), option_name varchar(100) unique
		, option_binary varchar(8), option_ascii tinyint, option_char varchar(1))
AS
/*	Creator: 20160303@Patrick
	Task: DBA - Generate 
	DB: DBTXN/BODB02
	Original: 
	
	Revisions:
		
	Param's Explanation:
	select * from f_DBA_Fast_Market_GenerateBetOptions()
*/
begin
	--declare @betoptions table(rowid int identity(1,1), option_name varchar(100) unique
	--	, option_binary varchar(8), option_ascii tinyint, option_char varchar(1))
	insert into @betoptions(option_binary, option_name)
	select '00000001', 'None' union
	select '00000010', 'Goals' union
	select '00000110', 'Goals_Corners' union
	select '00001010', 'Goals_Free-Kick' union
	select '00010010', 'Goals_Goal-Kick' union
	select '00100010', 'Goals_Throw-In' union
	--select '01000010', 'Goals_Bookings' union
	select '10000010', 'Goals_Penalty' union
	select '00001110', 'Goals_Corners_Free-Kick' union
	select '00010110', 'Goals_Corners_Goal-Kick' union
	select '00100110', 'Goals_Corners_Throw-In' union
	--select '01000110', 'Goals_Corners_Bookings' union
	select '10000110', 'Goals_Corners_Penalty' union
	select '00011110', 'Goals_Corners_Free-Kick_Goal-Kick' union
	select '00101110', 'Goals_Corners_Free-Kick_Throw-In' union
	--select '01001110', 'Goals_Corners_Free-Kick_Bookings' union
	--select '10001110', 'Goals_Corners_Free-Kick_Penalty' union
	select '00111110', 'Goals_Corners_Free-Kick_Goal-Kick_Throw-In' union
	--select '01011110', 'Goals_Corners_Free-Kick_Goal-Kick_Bookings' union
	--select '10011110', 'Goals_Corners_Free-Kick_Goal-Kick_Penalty' union
	--select '01111110', 'Goals_Corners_Free-Kick_Goal-Kick_Throw-In_Bookings' union
	--select '10111110', 'Goals_Corners_Free-Kick_Goal-Kick_Throw-In_Penalty' union
	--select '11111110', 'Goals_Corners_Free-Kick_Goal-Kick_Throw-In_Bookings_Penalty' union

	select '00000100', 'Corners' union
	select '00001100', 'Corners_Free-Kick' union
	select '00010100', 'Corners_Goal-Kick' union
	select '00100100', 'Corners_Throw-In' union
	--select '01000100', 'Corners_Bookings' union
	select '10000100', 'Corners_Penalty' union
	select '00011100', 'Corners_Free-Kick_Goal-Kick' union
	select '00101100', 'Corners_Free-Kick_Throw-In' union
	--select '01001100', 'Corners_Free-Kick_Bookings' union
	--select '10001100', 'Corners_Free-Kick_Penalty' union
	select '00111100', 'Corners_Free-Kick_Goal-Kick_Throw-In' union
	--select '01011100', 'Corners_Free-Kick_Goal-Kick_Bookings' union
	--select '10011100', 'Corners_Free-Kick_Goal-Kick_Penalty' union
	--select '01111100', 'Corners_Free-Kick_Goal-Kick_Throw-In_Bookings' union
	--select '10111100', 'Corners_Free-Kick_Goal-Kick_Throw-In_Penalty' union
	--select '11111100', 'Corners_Free-Kick_Goal-Kick_Throw-In_Bookings_Penalty' union

	select '00001000', 'Free-Kick' union
	select '00011000', 'Free-Kick_Goal-Kick' union
	select '00101000', 'Free-Kick_Throw-In' union
	--select '01001000', 'Free-Kick_Bookings' union
	--select '10001000', 'Free-Kick_Penalty' union
	select '00111000', 'Free-Kick_Goal-Kick_Throw-In' union
	--select '01011000', 'Free-Kick_Goal-Kick_Bookings' union
	--select '10011000', 'Free-Kick_Goal-Kick_Penalty' union
	--select '01111000', 'Free-Kick_Goal-Kick_Throw-In_Bookings' union
	--select '10111000', 'Free-Kick_Goal-Kick_Throw-In_Penalty' union
	--select '11111000', 'Free-Kick_Goal-Kick_Throw-In_Bookings_Penalty' union

	select '00010000', 'Goal-Kick' union
	select '00110000', 'Goal-Kick_Throw-In' union
	--select '01010000', 'Goal-Kick_Bookings' union
	--select '10010000', 'Goal-Kick_Penalty' union
	--select '01110000', 'Goal-Kick_Throw-In_Bookings' union
	--select '10110000', 'Goal-Kick_Throw-In_Penalty' union
	--select '11110000', 'Goal-Kick_Throw-In_Bookings_Penalty' union

	select '00100000', 'Throw-In' union
	--select '01100000', 'Throw-In_Bookings' union
	select '10100000', 'Throw-In_Penalty' union
	--select '11100000', 'Throw-In_Bookings_Penalty' union

	select '01000000', 'Bookings' union
	--select '11000000', 'Bookings_Penalty' union

	select '10000000', 'Penalty'

	--
	update @betoptions
	set option_ascii = dbo.f_Binary_Decimal(option_binary)
	update @betoptions
	set option_char = char(option_ascii)
	
	return
end
--select * from @betoptions
--select * from @betoptions where option_name not like '%Bookings%' and option_name not like '%Penalty%'

