with types; use types;
with ada.real_time;

package util is
	function sgn (x : in real) return real;
	function atan2(y,x : in real) return real;
	function rad_to_deg (t : in real) return real;
	function deg_to_rad(d : in real) return real;
	function deg_to_hours(d : in real) return real;
	function hours_to_deg(h : in real) return real;

	PAD : constant string := "      ";

	package rt renames ada.real_time;
	function real_time_diff(t0 : in rt.time; t1 : in rt.time := rt.clock) return real;
end util;
