--------------------------------------
-- solarephemeris-ada/screen (body) --
--------------------------------------

-- based on
--
-- simple ansi terminal emulator
-- michael feldman, the george washington university

with ada.text_io;	use ada.text_io;



package body ansi_screen is

	package io renames ada.text_io;
	package int_io is new io.integer_io (num => integer);

	procedure beep is
	begin
		io.put (item => ascii.bel);
	end beep;

	procedure clearscreen is
	begin
		io.put (item => ascii.esc);
		io.put (item => "[2J");
		io.put (item => ascii.ff);
	end clearscreen;

	procedure movecursor (to : in position) is
	begin                                                
		io.new_line;
		io.put (item => ascii.esc);
		io.put ("[");
		int_io.put (item => to.row, width => 1);
		io.put (item => ';');
		int_io.put (item => to.column, width => 1);
		io.put (item => 'f');
		beep;
	end movecursor;  

	procedure movecursor (
		row      : in positive;
		column   : in positive	) is
		pos : position;
	begin
		pos.row    := row;
		pos.column := column;
		movecursor(pos);
	end movecursor;
	 
end ansi_screen;
