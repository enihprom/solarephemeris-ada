solarephemeris-ada
==================

ada library for calculating geocentric solar ephemeris - part of the evolving himbeerhome project


... aiming to control miscellaneous smart home stuff like parabol-mirrored solar thermic water heating facilities.
as this part yields comparable results it needs to be released. the correspondent part will be found in the 
himbeerhome project folder 
coming soon.

regarding
types.ads
  - the commonly used 'real' is digits 15 is the largest possible universal real accepted by gnat running on the RPi
  - is a stripped standalone version for more comfortable reuse than the original version


SOG*-credits:
the code is a translation of jay tanners solarephemeris.php into ada 
plus a split-second updating T_now-console using a terminal control module
based on michael feldman's screen.adb (found somewhere along the comprehensive wikibooks
regarding the ada language)

*(shoulders of giants)
