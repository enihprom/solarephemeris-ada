--------------------------------------
-- solarephemeris-ada/screen (spec) --
--------------------------------------

generic
	screen_height_nchars  : positive := 24;
	screen_width_nchars   : positive := 78; 	
package ansi_screen is

	screen_height  : constant positive := screen_height_nchars;
	screen_width   : constant positive := screen_width_nchars;
	
	subtype height is integer range 1 .. screen_height;
	subtype width  is integer range 1 .. screen_width;

	type position is record
		row    : height := 1;
		column : width  := 1;
	end record;

	procedure beep; 

	procedure clearscreen; 

	procedure movecursor (to : in position);

	procedure movecursor (
		row      : in positive;
		column   : in positive	);
	 
end ansi_screen;   
