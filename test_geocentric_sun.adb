with ada.text_io;     
with ada.calendar;    
with ada.calendar.time_zones;
with ada.calendar.formatting;
with ada.real_time;
with ada.characters;
with ada.characters.latin_1;
use  ada.text_io;
use  ada;

with ansi_screen;
with util;
with solarephemeris;
with types;	use types;


procedure test_geocentric_sun is
	test_date : calendar.time;

	procedure print_current_data(date_spec : in calendar.time) is
		use solarephemeris;
		use util;
		daytime : real;
		epsilon : real;
		jdarg : real;
		gs : solarephemeris_type;
		tz : calendar.time_zones.time_offset;
	begin

		tz := calendar.time_zones.utc_time_offset(date_spec);

		put_line("### calculations @ " & 
				calendar.formatting.image(date_spec, true, tz) &
				" ###" & PAD);

		daytime :=  
				24.0/real(calendar.day_duration'last) * 
						real(calendar.seconds(date_spec));

		put_line("decimal daytime:" & daytime'img & PAD);

		jdarg := jd_for_time(date_spec);

		declare
			package rt   renames real_time;
			package ch   renames characters.latin_1;
			t0_emean : rt.time;
			t0_gs    : rt.time;			
		begin

			put_line("execution times");

			t0_emean  := rt.clock;
			epsilon   := epsilon_mean(jdarg); 
			put_line(
				ch.HT &
				"T_epsilon_mean: " &
				real_time_diff(t0_emean)'img);

         t0_gs     := rt.clock;
			gs        := geocentric_sun(jdarg);
			put_line(
				ch.HT &
				"T_geocentric_sun: " &
				real_time_diff(t0_gs)'img);

		end;

		new_line;
		put_line("--- solar ephemeris data ---" & PAD);
    	put_line("right ascension:    " & gs.ra_deg'img & PAD);
    	put_line("declination:        " & gs.decl_deg'img & PAD);
    	put_line("distance in AU:     " & gs.dist_au'img & PAD);
    	put_line("angular diameter:   " & gs.ang_diam_deg'img & PAD);
    	put_line("ecliptic longitude: " & gs.ecl_lng_deg'img & PAD);
    	put_line("ecliptic latitude:  " & gs.ecl_lat_deg'img & PAD);
    	put_line("lt current:         " & gs.lt_cur'img & PAD);
    	put_line("julian day:         " & gs.jd'img & PAD);
		put_line("ecliptic:           " & epsilon'img & PAD);
		new_line;

	end print_current_data;

	package screen is new ansi_screen;
begin

	screen.clearscreen;
	loop
		test_date := calendar.clock;
		screen.movecursor(row => 1, column => 1);
		put_line("--------------- solarephemeris test ---------------");
		print_current_data(test_date);
		put_line("---------------------------------------------------");
		delay 0.5;
	end loop;
	
end test_geocentric_sun;
