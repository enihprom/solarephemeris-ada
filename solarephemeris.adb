with ada.numerics;
with ada.calendar;
with types;
with util;

use util;
use types;
use ada;

with earth_x;
with earth_y;
with earth_z;

with ada.text_io; use ada.text_io; -- fixme remove

package body solarephemeris is
	use math;

	function earth_hXYZR(jdarg : real) return xyzr_vector_type is 
		t  : real := (jdarg - 2_451_545.0) / 365_250.0;
		h  : xyzr_vector_type; 
		use earth_x;
		use earth_y;
		use earth_z;
	begin
		h.x :=	earth_x0(t) + earth_x1(t) + earth_x2(t) +
		      	earth_x3(t) + earth_x4(t) + earth_x5(t);
		h.y :=	earth_y0(t) + earth_y1(t) + earth_y2(t) +
		     		earth_y3(t) + earth_y4(t) + earth_y5(t);
		h.z :=	earth_z0(t) + earth_z1(t) + earth_z2(t) +
		     		earth_z3(t) + earth_z4(t);
		h.r :=	sqrt(h.x*h.x + h.y*h.y + h.z*h.z);
		return h;
	end earth_hXYZR;

	function geocentric_sun(julian_day : real) return solarephemeris_type is

		gs              : solarephemeris_type;
		radius          : constant := 696_000_000.0;
		deg_per_rad     : constant := 180.0 / numerics.pi;
		m_per_au        : constant := 149_597_870_691.0;
		t               : real;
		k               : constant := m_per_au / SOL / 86_400.0;
		he              : xyzr_vector_type; -- reminder: h_?e = he.?
		g_xs, g_ys, 
		g_zs            : real;
		h_xs, h_ys,
		h_zs, h_rs      : real := 0.0;
		r_es, r_ep      : real;
		r_ps            : real;
		eps             : real;
		e_true          : real;
		precision_limit : constant := 0.000000000001;
		lt_prev         : real;
		x, y            : real;
		u, w            : real;
		l_prime         : real;

	begin

		t := (julian_day - 2_451_545.0) / 36_525.0;
		
		he := earth_hXYZR(julian_day);

		r_es := he.r;
		
		h_xs := 0.0;
		h_ys := 0.0;
		h_zs := 0.0;
		h_rs := 0.0;

		g_xs := h_xs - he.x;
		g_ys := h_ys - he.y;
		g_zs := h_zs - he.z;

		r_ps := h_rs;

		gs.dist_au := sqrt(g_xs*g_xs + g_ys*g_ys + g_zs*g_zs);
		gs.lt_cur := gs.dist_au * k;

		lt_prev := 0.0;

		while (abs(gs.lt_cur - lt_prev) > precision_limit) loop
			lt_prev := gs.lt_cur;
			he := earth_hXYZR(julian_day - gs.lt_cur);
			r_es := he.r;
			h_xs := 0.0;
			h_ys := 0.0;
			h_zs := 0.0;
			h_rs := 0.0;
			r_ps := h_rs;
			g_xs := h_xs - he.x;
			g_ys := h_ys - he.y;
			g_zs := h_zs - he.z;
			r_ep := sqrt(g_xs*g_xs + g_ys*g_ys + g_zs*g_zs);
			gs.lt_cur := r_ep * k;
		end loop;
		
		gs.ecl_lng_deg := rad_to_deg(atan2(g_ys, g_xs));
		if gs.ecl_lng_deg < 0.0 then
			gs.ecl_lng_deg := gs.ecl_lng_deg + 360.0;
		end if;
		gs.ecl_lat_deg := rad_to_deg(atan2(g_zs, sqrt(g_xs*g_xs + g_ys*g_ys)));
		u := deg_to_rad(gs.ecl_lat_deg);
		l_prime := deg_to_rad(gs.ecl_lng_deg - 1.397*t - 0.00031 * t * t);
		w := 	gs.ecl_lng_deg + 
					(0.03916*(cos(l_prime) + sin(l_prime))*tan(u) - 0.09033) 
				/ 3_600.0;
		u := deg_to_rad(gs.ecl_lng_deg - 1.397 * t - 0.00031*t*t);
		gs.ecl_lat_deg := gs.ecl_lat_deg + 
					(0.03916*(cos(u)-sin(u)) / 3_600.0);
		gs.ecl_lng_deg := w;

		gs.ecl_lng_deg := gs.ecl_lng_deg + delta_psi_2000B(julian_day);

		e_true := epsilon_mean(julian_day) + delta_epsilon_2000B(julian_day);

		u := deg_to_rad(gs.ecl_lng_deg);
		w := deg_to_rad(gs.ecl_lat_deg);
		eps := deg_to_rad(e_true);
		y := sin(u)*cos(eps) - tan(w)*sin(eps);
		x := cos(u);
		gs.ra_deg := rad_to_deg(atan2(y,x));
		if(gs.ra_deg < 0.0) then
			gs.ra_deg := gs.ra_deg + 360.0;
		end if;
		w := arcsin(sin(w)*cos(eps) + cos(w)*sin(u)*sin(eps));
		gs.decl_deg := rad_to_deg(w);
		gs.ang_diam_deg := deg_per_rad * radius * 2.0 / m_per_au / r_ep;

		gs.jd := julian_day;
		
		return gs;
	end geocentric_sun;

	--function epsilon_mean_v1(julian_day : real) return real is
	--	t, p, w, em : real;
	--begin

	--	t := (julian_day - 2_451_545.0) / 3_652_500.0;

	--	w :=    84_381.448;			p := t;
	--	w := w -  4_680.93*p;		p := p * t;
	--	w := w -      1.55*p;		p := p * t;
	--	w := w +  1_999.25*p;		p := p * t;
	--	w := w -     51.38*p;		p := p * t;
	--	w := w -    249.67*p;		p := p * t;
	--	w := w -     39.05*p;		p := p * t;
	--	w := w +      7.12*p;		p := p * t;
	--	w := w +     27.87*p;		p := p * t;
	--	w := w +      5.79*p;		p := p * t;
	--	w := w +      2.45*p;

	--	em := w / 3600.0;

	--	return em;

	--end epsilon_mean;

	function epsilon_mean(julian_day : real) return real is
		t, p, w, em_deg : real;
	begin
		t := (julian_day - 2_451_545.0) / 36_525.0 / 100.0;

		p := t*t;

		w := 84_381.448 - 4_680.93*t;

		w := w -    1.55*p;  p := p * t;
		w := w + 1999.25*p;  p := p * t;
		w := w -   51.38*p;  p := p * t;
		w := w -  249.67*p;  p := p * t;
		w := w -   39.05*p;  p := p * t;
		w := w +    7.12*p;  p := p * t;
		w := w +   27.87*p;  p := p * t;
		w := w +    5.79*p;  p := p * t;
		w := w +    2.45*p;


		em_deg := w / 3_600.0;

		return em_deg;

	end epsilon_mean;

	function delta_psi_2000B(julian_day : real) return real is
		d_psi_deg   : real;
		t           : real;
		t2, t3, t4  : real;
		l           : real;
		l_p         : real;
		f           : real;
		o_m         : real;
		s           : real;
		d           : real;
	begin
		t := (julian_day - 2_451_545.0) / 36_525.0;

		t2 := t * t;
		t3 := t * t2;
		t4 := t * t3;

		l := deg_to_rad(
				(485_868.249036 + 1_717_915_923.2178*t + 31.8792*t2 + 
				 0.051635*t3 - 0.0002447*t4) 
				/ 3_600.0);
		 	
		l_p := deg_to_rad((1_287_104.79305 + 129_596_581.0481*t
		    - 0.5532*t2  + 0.000136*t3 - 0.00001149*t4) / 3_600.0);

		f := deg_to_rad((335_779.526232 + 1_739_527_262.8478*t
		    - 12.7512*t2 - 0.001037*t3 + 0.00000417*t4) / 3_600.0);
	
		d := deg_to_rad((1_072_260.70369 + 1_602_961_601.2090*t
		    - 6.3706*t2  + 0.006593*t3 - 0.00003169*t4) / 3_600.0);
		
		--
		--// ----------------------------------------------------------------
		--// Mean longitude of the mean ascending node of the Moon in radians
		--
		--$Om = deg2rad((450160.398036 - 6962890.5431*$T
		--    + 7.4722*$T2  + 0.007702*$T3 - 0.00005939*$T4) / 3600.0);
		o_m := deg_to_rad((450_160.398036 - 6_962_890.5431*t
		    + 7.4722*t2  + 0.007702*t3 - 0.00005939*t4) / 3_600.0);
		--
		--
		--// SUM SERIES FOR NUTATION IN LONGITUDE (dPsi) IN ARC SEC * 10E+7
		--
		s := 0.0;
		s := s + (-172_064_161.0 - 174_666.0*t)*sin(o_m) + 33_386.0*cos(o_m);
		s := s + (-13_170_906.0 - 1_675.0*t)*sin(2.0*(f - d + o_m)) - 13_696.0*cos(2.0*(f - d + o_m));
		s := s + (-2_276_413.0 - 234.0*t)*sin(2.0*(f + o_m)) + 2_796.0*cos(2.0*(f + o_m));
		s := s + (2_074_554.0 + 207.0*t)*sin(2.0*o_m) - 698.0*cos(2.0*o_m);
		s := s + (1_475_877.0 - 3_633.0*t)*sin(l_p) + 11_817.0*cos(l_p);
		s := s + (-516_821.0 + 1_226.0*t)*sin(l_p + 2.0*(f - d + o_m)) - 524.0*cos(l_p + 2.0*(f - d + o_m));
		s := s + (711_159.0 + 73.0*t)*sin(l) - 872.0*cos(l);
		s := s + (-387_298.0 - 367.0*t)*sin(2.0*f + o_m) + 380.0*cos(2.0*f + o_m);
		s := s + (-301_461.0 - 36.0*t)*sin(l + 2.0*(f + o_m)) + 816.0*cos(l + 2.0*(f + o_m));
		s := s + (215_829.0 - 494.0*t)*sin(2.0*(f - d + o_m) - l_p) + 111.0*cos(2.0*(f - d + o_m) - l_p);
		s := s + (128_227.0 + 137.0*t)*sin(2.0*(f - d) + o_m) + 181.0*cos(2.0*(f - d) + o_m);
		s := s + (123_457.0 + 11.0*t)*sin(2.0*(f + o_m) - l) + 19.0*cos(2.0*(f + o_m) - l);
		s := s + (156_994.0 + 10.0*t)*sin(2.0*d - l) - 168.0*cos(2.0*d - l);
		s := s + (63_110.0 + 63.0*t)*sin(l + o_m) + 27.0*cos(l + o_m);
		s := s + (-57_976.0 - 63.0*t)*sin(o_m - l) - 189.0*cos(o_m - l);
		s := s + (-59_641.0 - 11.0*t)*sin(2.0*(f + d + o_m) - l) + 149.0*cos(2.0*(f + d + o_m) - l);
		s := s + (-51_613.0 - 42.0*t)*sin(l + 2.0*f + o_m) + 129.0*cos(l + 2.0*f + o_m);
		s := s + (45_893.0 + 50.0*t)*sin(2.0*(f - l) + o_m) + 31.0*cos(2.0*(f - l) + o_m);
		s := s + (63_384.0 + 11.0*t)*sin(2.0*d) - 150.0*cos(2.0*d);
		s := s + (-38_571.0 - t)*sin(2.0*(f + d + o_m)) + 158.0*cos(2.0*(f + d + o_m));
		s := s + 32_481.0*sin(2.0*(f - l_p - d + o_m));
		s := s - 47_722.0*sin(2.0*(d - l)) + 18.0*cos(2.0*(d - l));
		s := s + (-31_046.0 - t)*sin(2.0*(l + f + o_m)) + 131.0*cos(2.0*(l + f + o_m));
		s := s + 28_593.0*sin(l + 2.0*(f - d + o_m)) - cos(l + 2.0*(f - d + o_m));
		s := s + (20_441.0 + 21.0*t)*sin(2.0*f - l + o_m) + 10.0*cos(2.0*f - l + o_m);
		s := s + 29_243.0*sin(2.0*l) - 74.0*cos(2.0*l);
		s := s + 25_887.0*sin(2.0*f) - 66.0*cos(2.0*f);
		s := s + (-14_053.0 - 25.0*t)*sin(l_p + o_m) + 79.0*cos(l_p + o_m);
		s := s + (15_164.0 + 10.0*t)*sin(2.0*d - l + o_m) + 11.0*cos(2.0*d - l + o_m);
		s := s + (-15_794.0 + 72.0*t)*sin(2.0*(l_p + f - d + o_m)) - 16.0*cos(2.0*(l_p + f - d + o_m));
		s := s + 21_783.0*sin(2.0*(d - f)) + 13.0*cos(2.0*(d - f));
		s := s + (-12_873.0 - 10.0*t)*sin(l - 2.0*d + o_m) - 37.0*cos(l - 2.0*d + o_m);
		s := s + (-12_654.0 + 11.0*t)*sin(o_m - l_p) + 63.0*cos(o_m - l_p);
		s := s - 10_204.0*sin(2.0*(f + d) - l + o_m) - 25.0*cos(2.0*(f + d) - l + o_m);
		s := s + (16_707.0 - 85.0*t)*sin(2.0*l_p) - 10.0*cos(2.0*l_p);
		s := s - 7_691.0*sin(l + 2.0*(f + d + o_m)) - 44.0*cos(l + 2.0*(f + d + o_m));
		s := s - 11_024.0*sin(-2.0*l + 2.0*f) + 14.0*cos(2.0*(f - l));
		s := s + (7_566.0 - 21.0*t)*sin(l_p + 2.0*(f + o_m)) - 11.0*cos(l_p + 2.0*(f + o_m));
		s := s + (-6_637.0 - 11.0*t)*sin(2.0*(f + d) + o_m) + 25.0*cos(2.0*(f + d) + o_m);
		s := s + (-7_141.0 + 21.0*t)*sin(2.0*(f + o_m) - l_p) + 8.0*cos(2.0*(f + o_m) - l_p);
		s := s + (-6_302.0 - 11.0*t)*sin(2.0*d + o_m) + 2.0*cos(2.0*d + o_m);
		s := s + (5_800.0 + 10.0*t)*sin(l + 2.0*(f - d) + o_m) + 2.0*cos(l + 2.0*(f - d) + o_m);
		s := s + 6_443.0*sin(2.0*(l + f - d + o_m)) - 7.0*cos(2.0*(l + f - d + o_m));
		s := s + (-5_774.0 - 11.0*t)*sin(2.0*(d - l) + o_m) - 15.0*cos(2.0*(d - l) + o_m);
		s := s - 5_350.0*sin(2.0*(l + f) + o_m) - 21.0*cos(2.0*(l + f) + o_m);
		s := s + (-4_752.0 - 11.0*t)*sin(2.0*(f - d) - l_p + o_m) - 3.0*cos(2.0*(f - d) - l_p + o_m);
		s := s + (-4_940.0 - 11.0*t)*sin(o_m - 2.0*d) - 21.0*cos(o_m - 2.0*d);
		s := s + 7_350.0*sin(2.0*d - l - l_p) - 8.0*cos(2.0*d - l - l_p);
		s := s + 4_065.0*sin(2.0*(l - d) + o_m) + 6.0*cos(2.0*(l - d) + o_m);
		s := s + 6_579.0*sin(l + 2.0*d) - 24.0*cos(l + 2.0*d);
		s := s + 3_579.0*sin(l_p + 2.0*(f - d) + o_m) + 5.0*cos(l_p + 2.0*(f - d) + o_m);
		s := s + 4_725.0*sin(l - l_p) - 6.0*cos(l - l_p);
		s := s - 3_075.0*sin(2.0*(f - l  + o_m)) + 2.0*cos(2.0*(f - l  + o_m));
		s := s - 2_904.0*sin(3.0*l + 2.0*(f + o_m)) - 15.0*cos(3.0*l + 2.0*(f + o_m));
		s := s + 4_348.0*sin(2.0*d - l_p) - 10.0*cos(2.0*d - l_p);
		s := s - 2_878.0*sin(l - l_p + 2.0*(f + o_m)) - 8.0*cos(l - l_p + 2.0*(f + o_m));
		s := s - 4_230.0*sin(d) - 5.0*cos(d);
		s := s - 2_819.0*sin(2.0*(f + d + o_m) - l - l_p) - 7.0*cos(2.0*(f + d + o_m) - l - l_p);
		s := s - 4_056.0*sin(2.0*f - l) - 5.0*cos(2.0*f - l);
		s := s - 2_647.0*sin(2.0*(f + d + o_m) - l_p) - 11.0*cos(2.0*(f + d + o_m) - l_p);
		s := s - 2_294.0*sin(o_m - 2.0*l) + 10.0*cos(o_m - 2.0*l);
		s := s + 2_481.0*sin(l + l_p + 2.0*(f + o_m)) - 7.0*cos(l + l_p + 2.0*(f + o_m));
		s := s + 2_179.0*sin(2.0*l + o_m) - 2.0*cos(2.0*l + o_m);
		s := s + 3_276.0*sin(l_p - l + d) + cos(l_p - l + d);
		s := s - 3_389.0*sin(l + l_p) - 5.0*cos(l + l_p);
		s := s + 3_339.0*sin(l + 2.0*f) - 13.0*cos(l + 2.0*f);
		s := s - 1_987.0*sin(2.0*(f - d) - l + o_m) + 6.0*cos(2.0*(f - d) - l + o_m);
		s := s - 1_981.0*sin(l + 2.0*o_m);
		s := s + 4_026.0*sin(d - l) - 353.0*cos(d - l);
		s := s + 1_660.0*sin(d + 2.0*(f + o_m)) - 5.0*cos(d + 2.0*(f + o_m));
		s := s - 1_521.0*sin(2.0*(f + 2.0*d + o_m) - l) - 9.0*cos(2.0*(f + 2.0*d + o_m) - l);
		s := s + 1_314.0*sin(l_p - l + d + o_m);
		s := s - 1_283.0*sin(2.0*(f - l_p - d) + o_m);
		s := s - 1_331.0*sin(l + 2.0*(f + d) + o_m) - 8.0*cos(l + 2.0*(f + d) + o_m);
		s := s + 1_383.0*sin(2.0*(f - l + d + o_m)) - 2.0*cos(2.0*(f - l + d + o_m));
		s := s + 1_405.0*sin(2.0*o_m - l) + 4.0*cos(2.0*o_m - l);
		s := s + 1_290.0*sin(l + l_p + 2.0*(f - d + o_m));
		
		d_psi_deg := s / 36_000_000_000.0;
		
		return d_psi_deg;
		
	end delta_psi_2000B;

	function delta_epsilon_2000B(julian_day : real) return real is
		d_eps_deg   : real;
		t           : real;
		t2, t3, t4  : real;
		l           : real;
		l_p         : real;
		f           : real;
		d           : real;
		o_m         : real;
		s           : real;
	begin

		--// ------------------------------------------------------
		--// Compute time in Julian centuries reckoned from J2000.0
		--// correspomding to the JD number.
		--
		--   $T = ($JD - 2451545.0) / 36525.0;
		t := (julian_day - 2_451_545.0) / 36_525.0;

		--
		--// -------------------
		--// Compute powers of T
		--
		--   $T2 = $T * $T;
		--   $T3 = $T * $T2;
		--   $T4 = $T * $T3;
		t2 := t * t;
		t3 := t * t2;
		t4 := t * t3;

		--
		--// -----------------------------------
		--// Mean anomaly of the Moon in radians
		--
		--$L  = deg2rad((485868.249036 + 1717915923.2178*$T + 31.8792*$T2
		--    + 0.051635*$T3 - 0.00024470*$T4) / 3600.0);
		l := deg_to_rad((485_868.249036 + 1_717_915_923.2178*t + 31.8792*t2
		   + 0.051635*t3 - 0.00024470*t4) / 3_600.0);

		--
		--
		--// ----------------------------------
		--// Mean anomaly of the Sun in radians
		--
		--$Lp = deg2rad((1287104.79305 + 129596581.0481*$T
		--    - 0.5532*$T2  + 0.000136*$T3 - 0.00001149*$T4) / 3600.0);
		l_p := deg_to_rad((1_287_104.79305 + 129_596_581.0481*t
		    - 0.5532*t2  + 0.000136*t3 - 0.00001149*t4) / 3_600.0);
		
		--
		--// ----------------------------------------------------
		--// Mean argument of the latitude of the Moon in radians
		--
		--$F  = deg2rad((335779.526232 + 1739527262.8478*$T
		--    - 12.7512*$T2 - 0.001037*$T3 + 0.00000417*$T4) / 3600.0);
		f := deg_to_rad((335_779.526232 + 1_739_527_262.8478*t
		    - 12.7512*t2 - 0.001037*t3 + 0.00000417*t4) / 3_600.0);
		
		--
		--// ---------------------------------------------------
		--// Mean elongation of the Moon from the Sun in radians
		--
		--$D  = deg2rad((1072260.70369 + 1602961601.2090*$T
		--    - 6.3706*$T2  + 0.006593*$T3 - 0.00003169*$T4) / 3600.0);
		d := deg_to_rad((1_072_260.70369 + 1_602_961_601.2090*t
		    - 6.3706*t2  + 0.006593*t3 - 0.00003169*t4) / 3_600.0);
		
		--
		--// ----------------------------------------------------------------
		--// Mean longitude of the mean ascending node of the Moon in radians
		--
		o_m := deg_to_rad((450_160.398036 - 6_962_890.5431*t
		    + 7.4722*t2  + 0.007702*t3 - 0.00005939*t4) / 3_600.0);
		
		--
		--// SUM SERIES FOR NUTATION IN OBLIQUITY (dEps) IN ARC SEC * 10E+7
		--
		s := 0.0;
		s := s + (92_052_331.0 + 9_086.0*t)*cos(o_m) + 15_377.0*sin(o_m);
		s := s + (5_730_336.0 - 3_015.0*t)*cos(2.0*(f - d + o_m)) - 4_587.0*sin(2.0*(f - d + o_m));
		s := s + (978_459.0 - 485.0*t)*cos(2.0*(f + o_m)) + 1_374.0*sin(2.0*(f + o_m));
		s := s + (-897_492.0 + 470.0*t)*cos(2.0*o_m) - 291.0*sin(2.0*o_m);
		s := s + (73_871.0 - 184.0*t)*cos(l_p) - 1_924.0*sin(l_p);
		s := s + (224_386.0 - 677.0*t)*cos(l_p + 2.0*(f - d + o_m)) - 174.0*sin(l_p + 2.0*(f - d + o_m));
		s := s - 6_750.0*cos(l) - 358.0*sin(l);
		s := s + (200_728.0 + 18.0*t)*cos(2.0*f + o_m) + 318.0*sin(2.0*f + o_m);
		s := s + (129_025.0 - 63.0*t)*cos(l + 2.0*(f + o_m)) + 367.0*sin(l + 2.0*(f + o_m));
		s := s + (-95_929.0 + 299.0*t)*cos(2.0*(f - d + o_m) - l_p) + 132.0*sin(2.0*(f - d + o_m) - l_p);
		s := s + (-68_982.0 - 9.0*t)*cos(2.0*(f - d) + o_m) + 39.0*sin(2.0*(f - d) + o_m);
		s := s + (-53_311.0 + 32.0*t)*cos(2.0*(f + o_m) - l) - 4.0*sin(2.0*(f + o_m) - l);
		s := s - 1_235.0*cos(2.0*d - l) - 82.0*sin(2.0*d - l);
		s := s - 33_228.0*cos(l + o_m) + 9.0*sin(l + o_m);
		s := s + 31_429.0*cos(o_m - l) - 75.0*sin(o_m - l);
		s := s + (25_543.0 - 11.0*t)*cos(2.0*(f + d + o_m) - l) + 66.0*sin(2.0*(f + d + o_m) - l);
		s := s + 26_366.0*cos(l + 2.0*f + o_m) + 78.0*sin(l + 2.0*f + o_m);
		s := s + (-24_236.0 - 10.0*t)*cos(2.0*(f - l) + o_m) + 20.0*sin(2.0*(f - l) + o_m);
		s := s - 1_220.0*cos(2.0*d) - 29.0*sin(2.0*d);
		s := s + (16_452.0 - 11.0*t)*cos(2.0*(f + d + o_m)) + 68.0*sin(2.0*(f + d + o_m));
		s := s - 13_870.0*cos(2.0*(f - l_p - d + o_m));
		s := s + 477.0*cos(2.0*(d - l)) - 25.0*sin(2.0*(d - l));
		s := s + (13_238.0 - 11.0*t)*cos(2.0*(l + f + o_m)) + 59.0*sin(2.0*(l + f + o_m));
		s := s + (-12_338.0 + 10.0*t)*cos(l + 2.0*(f - d + o_m)) - 3.0*sin(l + 2.0*(f - d + o_m));
		s := s - 10_758.0*cos(2.0*f - l + o_m) + 3.0*sin(2.0*f - l + o_m);
		s := s - 609.0*cos(2.0*l) - 13.0*sin(2.0*l);
		s := s - 550.0*cos(2.0*f) - 11.0*sin(2.0*f);
		s := s + (8_551.0 - 2.0*t)*cos(l_p + o_m) - 45.0*sin(l_p + o_m);
		s := s - 8_001.0*cos(2.0*d - l + o_m) + sin(2.0*d - l + o_m);
		s := s + (6_850.0 - 42.0*t)*cos(2.0*(l_p + f - d + o_m)) - 5.0*sin(2.0*(l_p + f - d + o_m));
		s := s - 167.0*cos(2.0*(d - f)) - 13.0*sin(2.0*(d - f));
		s := s + 6_953.0*cos(l - 2.0*d + o_m) - 14.0*sin(l - 2.0*d + o_m);
		s := s + 6_415.0*cos(o_m - l_p) + 26.0*sin(o_m - l_p);
		s := s + 5_222.0*cos(2.0*(f + d) - l + o_m) + 15.0*sin(2.0*(f + d) - l + o_m);
		s := s + (168.0 - t)*cos(2.0*l_p) + 10.0*sin(2.0*l_p);
		s := s + 3_268.0*cos(l + 2.0*(f + d + o_m)) + 19.0*sin(l + 2.0*(f + d + o_m));
		s := s + 104.0*cos(2.0*(f - l)) + 2.0*sin(2.0*(f - l));
		s := s - 3_250.0*cos(l_p + 2.0*(f + o_m)) + 5.0*sin(l_p + 2.0*(f + o_m));
		s := s + 3_353.0*cos(2.0*(f + d) + o_m) + 14.0*sin(2.0*(f + d) + o_m);
		s := s + 3_070.0*cos(2.0*(f + o_m) - l_p) + 4.0*sin(2.0*(f + o_m) - l_p);
		s := s + 3_272.0*cos(2.0*d + o_m) + 4.0*sin(2.0*d + o_m);
		s := s - 3_045.0*cos(l + 2.0*(f - d) + o_m) + sin(l + 2.0*(f - d) + o_m);
		s := s - 2_768.0*cos(2.0*(l + f - d + o_m)) + 4.0*sin(2.0*(l + f - d + o_m));
		s := s + 3_041.0*cos(2.0*(d - l) + o_m) - 5.0*sin(2.0*(d - l) + o_m);
		s := s + 2_695.0*cos(2.0*(l + f) + o_m) + 12.0*sin(2.0*(l + f) + o_m);
		s := s + 2_719.0*cos(2.0*(f - d) - l_p + o_m) - 3.0*sin(2.0*(f - d) - l_p + o_m);
		s := s + 2_720.0*cos(o_m - 2.0*d) - 9.0*sin(o_m - 2.0*d);
		s := s - 51.0*cos(2.0*d - l - l_p) - 4.0*sin(2.0*d - l - l_p);
		s := s - 2_206.0*cos(2.0*(l - d) + o_m) - sin(2.0*(l - d) + o_m);
		s := s - 199.0*cos(l + 2.0*d) - 2.0*sin(l + 2.0*d);
		s := s - 1_900.0*cos(l_p + 2.0*(f - d) + o_m) - sin(l_p + 2.0*(f - d) + o_m);
		s := s - 41.0*cos(l - l_p) - 3.0*sin(l - l_p);
		s := s + 1_313.0*cos(2.0*(f - l + o_m)) - sin(2.0*(f - l + o_m));
		s := s + 1_233.0*cos(3.0*l + 2.0*(f + o_m)) + 7.0*sin(3.0*l + 2.0*(f + o_m));
		s := s - 81.0*cos(2.0*d - l_p) - 2.0*sin(2.0*d - l_p);
		s := s + 1_232.0*cos(l - l_p + 2.0*(f + o_m)) + 4.0*sin(l - l_p + 2.0*(f + o_m));
		s := s - 20.0*cos(d) + 2.0*sin(d);
		s := s + 1_207.0*cos(2.0*(f + d + o_m) - l - l_p) + 3.0*sin(2.0*(f + d + o_m) - l - l_p);
		s := s + 40.0*cos(2.0*f - l) - 2.0*sin(2.0*f - l);
		s := s + 1_129.0*cos(2.0*(f + d + o_m) - l_p) + 5.0*sin(2.0*(f + d + o_m) - l_p);
		s := s + 1_266.0*cos(o_m - 2.0*l) - 4.0*sin(o_m - 2.0*l);
		s := s - 1_062.0*cos(l + l_p + 2.0*(f + o_m)) + 3.0*sin(l + l_p + 2.0*(f + o_m));
		s := s - 1_129.0*cos(2.0*l + o_m) + 2.0*sin(2.0*l + o_m);
		s := s - 9.0*cos(l_p + d - l);
		s := s + 35.0*cos(l + l_p) - 2.0*sin(l + l_p);
		s := s - 107.0*cos(l + 2.0*f) - sin(l + 2.0*f);
		s := s + 1_073.0*cos(2.0*(f - d) - l + o_m) - 2.0*sin(2.0*(f - d) - l + o_m);
		s := s + 854.0*cos(l + 2.0*o_m);
		s := s - 553.0*cos(d - l) + 139.0*sin(d - l);
		s := s - 710.0*cos(2.0*(f + o_m) + d) + 2.0*sin(2.0*(f + o_m) + d);
		s := s + 647.0*cos(2.0*(f + 2.0*d + o_m) - l) + 4.0*sin(2.0*(f + 2.0*d + o_m) - l);
		s := s - 700.0*cos(l_p - l + d + o_m);
		s := s + 672.0*cos(2.0*(f - l_p - d) + o_m);
		s := s + 663.0*cos(l + 2.0*(f + d) + o_m) + 4.0*sin(l + 2.0*(f + d) + o_m);
		s := s - 594.0*cos(2.0*(f - l + d + o_m)) + 2.0*sin(2.0*(f - l + d + o_m));
		s := s - 610.0*cos(2.0*o_m - l) - 2.0*sin(2.0*o_m - l);
		s := s - 556.0*cos(l + l_p + 2.0*(f - d + o_m));
		
		d_eps_deg := s / 36_000_000_000.0;
		
		return d_eps_deg;
		
	end delta_epsilon_2000B;



	function jd_for_time(
		time_spec  : in time; 
		calmode : in calmode_type := gregorian) return real 
	is
		use ada.calendar;
		y         : real := real(year(time_spec));
		m         : real := real(month(time_spec));
		d         : real := real(day(time_spec));
		sd        : real := real(seconds(time_spec));
		a,b,c     : real;
		jd        : real;
		jd_frac   : real;
		w         : real;
		v_calmode : real := real(calmode_type'pos(calmode)); 
	begin
	
		jd_frac := sd/real(day_duration'last) - 0.5;

		if (y < 0.0) then 
			w := y+1.0;
		else 
			w := y;
		end if;

		a := real'floor((14.0-m) / 12.0);
		b := w - a;
		c := real'floor(b/100.0);

		jd := real'floor(30.6001*(12.0*a + m + 1.0))
				+ real'floor(365.25*(b + 4_716.0)) - 1_524.0
				+ v_calmode*(real'floor(c/4.0) - c + 2.0) + d
				+ jd_frac;

		return jd;

	end jd_for_time;


end solarephemeris;
