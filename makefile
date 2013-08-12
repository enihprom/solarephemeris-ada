all: test

test: compile
	./test_geocentric_sun

compile:
	gnatmake -P solarephemeris.gpr

clean:
	gnatclean -P solarephemeris.gpr
