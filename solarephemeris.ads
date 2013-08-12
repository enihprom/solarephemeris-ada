with types; use types;
with ada.calendar;
use ada.calendar;

package solarephemeris is
	
	type solarephemeris_type is
		record
    		ra_deg        : real;
    		decl_deg      : real;
    		dist_au       : real;
    		ang_diam_deg  : real;
    		ecl_lng_deg   : real;
    		ecl_lat_deg   : real;
    		lt_cur        : real;
			jd            : real; 
		end record;
	
	type xyzr_vector_type is
		record
			x,y,z : real;
			r     : real;
		end record;
	
	type calmode_type is (julian, gregorian);
	for calmode_type use 
	(
		julian => 0,
		gregorian => 1
	);

	function epsilon_mean(julian_day : real) return real;
	function earth_hXYZR(jdarg : real) return xyzr_vector_type;
	function geocentric_sun(julian_day : real) return solarephemeris_type;
	function delta_psi_2000B(julian_day : real) return real;
	function delta_epsilon_2000B(julian_day : real) return real;
	

	function jd_for_time(time_spec : in time;
	                     calmode : in calmode_type := gregorian) 
								return real;


end solarephemeris;
