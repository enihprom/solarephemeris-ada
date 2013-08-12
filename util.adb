with types;
with ada.numerics;
use ada.numerics;

package body util is

	use math;

	function sgn (x : in real) return real is
	begin
	   if x > 0.0 then
	      return 1.0;
	   elsif x < 0.0 then
	      return -1.0;
	   else
	      return 0.0;
	   end if;
	end sgn;

	function atan2(y,x : in real) return real is
		w : real;
	begin
        if x > 0.0 then
           w :=  arctan (y / x);
        elsif x = 0.0 then
           w :=  sgn (x) * (pi / 2.0);
        elsif x < 0.0 then
           if y >= 0.0 then
              w :=  arctan (y / x) + pi;
           elsif y < 0.0 then
              w :=  arctan (y / x) - pi;
           end if;
        end if;
		return w;
	end atan2;

	function rad_to_deg (t : in real) return real is
	begin
		return 180.0*rad_type(t) / pi;
	exception
		when constraint_error =>
			raise geometry_error with "transcircular t=" & t'img;
	end rad_to_deg;

	function deg_to_rad(d : in real) return real is
	begin
		return pi*d / 180.0;
	end deg_to_rad;

	function deg_to_hours(d : in real) return real is
	begin
		return d/15.0;
	end deg_to_hours;

	function hours_to_deg(h : in real) return real is
	begin
		return h*15.0;
	end hours_to_deg;
	
	function real_time_diff(t0 : in rt.time; t1 : in rt.time := rt.clock) 
		return real 
	is
		use rt;
		t0_sc, t1_sc : seconds_count;
		t0_ts, t1_ts : time_span;
		diff         : real;
	begin
		split(t0, t0_sc, t0_ts);
		split(t1, t1_sc, t1_ts);
		diff := 
			( real(t1_sc) + real(to_duration(t1_ts)) ) - 
			( real(t0_sc) + real(to_duration(t0_ts)) );
		return diff;
	end real_time_diff;
end util;
