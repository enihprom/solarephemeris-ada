with ada.calendar; 
with ada.numerics;
with ada.numerics.generic_elementary_functions;

package types is
	use ada;
	use numerics;

	AU : constant := 149_597_871_000.0;
	SOL : constant := 299_792_458.0;

	type real is digits 15;
	
	subtype rad_type is real range -pi .. pi;
	subtype deg_type is real range 0.0 .. 360.0; --?

	type fix_deg_type is delta 0.00001 range -360.0 .. 360.0;
	type fix_rad_type is delta 0.00000001 range -pi .. pi;
	
	package math is new numerics.generic_elementary_functions(real);
	
	type daytime_type is delta 1.0/calendar.day_duration'last 
			range 0.0 .. 1.0;
	
	geometry_error : exception;

end types;
