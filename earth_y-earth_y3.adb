separate(earth_y)

function earth_y3(t : in real) return real is
		y3 : real;
begin
   y3 := 0.00000232790*cos(1.83555296287 + 0.2438174835*t);
   y3 := y3 + 0.00000076843*cos(0.95359770708 + 12566.3955174663*t);
   y3 := y3 + 0.00000035331*cos(1.77537067174 + 6283.3196674749*t);
   y3 := y3 + 0.00000005282*cos(0.83410185910 + 18849.4713674577*t);
   y3 := y3 + 0.00000001631*cos(0.72620862558 + 6282.83203250789*t);
   y3 := y3 + 0.00000001483*cos(0.65599216587 + 6438.7400669091*t);
   y3 := y3 + 0.00000001479*cos(2.83072127404 + 6127.8992680407*t);
   y3 := y3 + 0.00000000652*cos(3.13796451313 + 6279.7965491259*t);
   y3 := y3 + 0.00000000656*cos(0.01615422945 + 6286.84278582391*t);
   y3 := y3 + 0.00000000317*cos(1.43157695840 + 6526.04827144891*t);
   y3 := y3 + 0.00000000318*cos(2.05944515679 + 6040.5910635009*t);
   y3 := y3 + 0.00000000227*cos(0.70881980797 + 25132.5472174491*t);
   y3 := y3 + 0.00000000201*cos(5.52615570373 + 6836.8890703173*t);
   y3 := y3 + 0.00000000201*cos(4.23563267830 + 5729.7502646325*t);
   y3 := y3 + 0.00000000036*cos(6.05003898151 + 12569.91863581531*t);
   y3 := y3 + 0.00000000034*cos(0.36912822345 + 4705.9761250271*t);
   y3 := y3 + 0.00000000033*cos(2.65665718326 + 12410.9751180321*t);
   y3 := y3 + 0.00000000032*cos(3.81269087187 + 6257.0213476751*t);
   y3 := y3 + 0.00000000032*cos(2.84133186500 + 6309.61798727471*t);
   y3 := y3 + 0.00000000026*cos(5.21573736647 + 775.7664288075*t);
   y3 := y3 + 0.00000000023*cos(0.44696909593 + 1059.6257476727*t);
   y3 := y3 + 0.00000000025*cos(0.01326357360 + 7860.6632099227*t);
   y3 := y3 + 0.00000000027*cos(0.46730161827 + 12565.9078824993*t);
   y3 := y3 + 0.00000000020*cos(2.19213288615 + 5753.6287023803*t);
   y3 := y3 + 0.00000000019*cos(1.44435756454 + 5885.1706640667*t);
   y3 := y3 + 0.00000000019*cos(4.47976718197 + 6813.0106325695*t);
   y3 := y3 + 0.00000000018*cos(0.72211012099 + 12721.8159169005*t);
   y3 := y3 + 0.00000000017*cos(5.20474716177 + 6681.46867088311*t);
   y3 := y3 + 0.00000000013*cos(2.92478174105 + 5487.0216606585*t);
   y3 := y3 + 0.00000000011*cos(3.72062261949 + 7079.61767429131*t);
   y3 := y3 + 0.00000000010*cos(2.89167021825 + 5507.7970561509*t);
   y3 := y3 + 0.00000000010*cos(1.46762801985 + 11790.8729061423*t);
   y3 := y3 + 0.00000000009*cos(6.21784065295 + 11507.0135872771*t);
   y3 := y3 + 0.00000000011*cos(4.68801103302 + 12592.6938372661*t);
   y3 := y3 + 0.00000000009*cos(3.82179163254 + 7058.8422787989*t);
   y3 := y3 + 0.00000000008*cos(5.97770881958 + 6290.4332144757*t);
   y3 := y3 + 0.00000000008*cos(0.68313431813 + 6276.2061204741*t);
   y3 := y3 + 0.00000000008*cos(1.45990791265 + 796.5418242999*t);
   y3 := y3 + 0.00000000007*cos(4.15465801739 + 4693.75913722409*t);
   y3 := y3 + 0.00000000007*cos(0.35078036011 + 7.3573644843*t);
   y3 := y3 + 0.00000000005*cos(3.29483739022 + 3739.0052475915*t);
   y3 := y3 + 0.00000000005*cos(4.64160679165 + 6070.0205720369*t);
   y3 := y3 + 0.00000000006*cos(2.38483297622 + 6284.2999885431*t);
   y3 := y3 + 0.00000000006*cos(4.26851560652 + 6282.3393464067*t);
   y3 := y3 + 0.00000000005*cos(1.89668032657 + 4137.1542509997*t);
   y3 := y3 + 0.00000000005*cos(2.01213704309 + 6496.6187629129*t);
   return y3*t*t*t;
end earth_y3;
