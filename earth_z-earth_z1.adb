separate(earth_z)

function earth_z1(t : in real) return real is
		z1 : real;
begin
   z1 := 0.00000009031*cos(3.89751156799 + 5507.5532386674*t);
   z1 := z1 + 0.00000006179*cos(1.73051337995 + 5223.6939198022*t);
   z1 := z1 + 0.00000003793*cos(5.24575814515 + 2352.8661537718*t);
   z1 := z1 + 0.00000002840*cos(2.47694599818 + 1577.3435424478*t);
   z1 := z1 + 0.00000001817*cos(0.41874743765 + 6283.0758499914*t);
   z1 := z1 + 0.00000001499*cos(1.83320979291 + 5856.4776591154*t);
   z1 := z1 + 0.00000001463*cos(5.68891324948 + 5753.3848848968*t);
   z1 := z1 + 0.00000001302*cos(2.18800611215 + 9437.762934887*t);
   z1 := z1 + 0.00000001239*cos(4.95327097854 + 10213.285546211*t);
   z1 := z1 + 0.00000001029*cos(0.09367831611 + 7860.4193924392*t);
   z1 := z1 + 0.00000000975*cos(0.08833256880 + 14143.4952424306*t);
   z1 := z1 + 0.00000000851*cos(1.79547916132 + 3930.2096962196*t);
   z1 := z1 + 0.00000000581*cos(2.26949174067 + 5884.9268465832*t);
   z1 := z1 + 0.00000000515*cos(5.64196681593 + 529.6909650946*t);
   z1 := z1 + 0.00000000473*cos(6.22750969242 + 6309.3741697912*t);
   z1 := z1 + 0.00000000449*cos(1.52767374606 + 18073.7049386502*t);
   z1 := z1 + 0.00000000360*cos(3.62344325932 + 13367.9726311066*t);
   z1 := z1 + 0.00000000372*cos(3.22470721320 + 6275.9623029906*t);
   z1 := z1 + 0.00000000260*cos(1.87645933242 + 11790.6290886588*t);
   z1 := z1 + 0.00000000322*cos(0.94084045832 + 6069.7767545534*t);
   z1 := z1 + 0.00000000232*cos(0.27531852596 + 7058.5984613154*t);
   z1 := z1 + 0.00000000217*cos(6.03652873142 + 10977.078804699*t);
   z1 := z1 + 0.00000000232*cos(2.93325646109 + 22003.9146348698*t);
   z1 := z1 + 0.00000000204*cos(3.86264841382 + 6496.3749454294*t);
   z1 := z1 + 0.00000000189*cos(2.88937704419 + 15720.8387848784*t);
   z1 := z1 + 0.00000000179*cos(4.90537280911 + 12036.4607348882*t);
   z1 := z1 + 0.00000000222*cos(3.98495366315 + 6812.766815086*t);
   z1 := z1 + 0.00000000213*cos(1.57516933652 + 4694.0029547076*t);
   z1 := z1 + 0.00000000157*cos(1.08259734788 + 5643.1785636774*t);
   z1 := z1 + 0.00000000154*cos(5.99434678412 + 5486.777843175*t);
   z1 := z1 + 0.00000000137*cos(2.67760436027 + 6290.1893969922*t);
   z1 := z1 + 0.00000000179*cos(2.05905949693 + 7084.8967811152*t);
   z1 := z1 + 0.00000000121*cos(5.90212574947 + 9225.539273283*t);
   z1 := z1 + 0.00000000125*cos(2.24111392416 + 1059.3819301892*t);
   z1 := z1 + 0.00000000150*cos(2.00175038718 + 5230.807466803*t);
   z1 := z1 + 0.00000000149*cos(5.06157254516 + 17298.1823273262*t);
   z1 := z1 + 0.00000000118*cos(5.39979058038 + 3340.6124266998*t);
   z1 := z1 + 0.00000000161*cos(3.32421999691 + 6283.3196674749*t);
   z1 := z1 + 0.00000000115*cos(5.92406672373 + 4705.7323075436*t);
   z1 := z1 + 0.00000000118*cos(4.40207874911 + 19651.048481098*t);
   z1 := z1 + 0.00000000128*cos(4.35489873365 + 25934.1243310894*t);
   z1 := z1 + 0.00000000109*cos(2.52157834166 + 6438.4962494256*t);
   z1 := z1 + 0.00000000099*cos(2.70727488041 + 5216.5803728014*t);
   z1 := z1 + 0.00000000122;
   z1 := z1 + 0.00000000103*cos(0.93782340879 + 8827.3902698748*t);
   z1 := z1 + 0.00000000083*cos(4.12473540351 + 8635.9420037632*t);
   z1 := z1 + 0.00000000097*cos(5.50959692365 + 29864.334027309*t);
   z1 := z1 + 0.00000000073*cos(1.73905345744 + 11506.7697697936*t);
   z1 := z1 + 0.00000000083*cos(5.69169692653 + 775.522611324*t);
   z1 := z1 + 0.00000000072*cos(0.21891639822 + 21228.3920235458*t);
   z1 := z1 + 0.00000000071*cos(2.86755026812 + 6681.2248533996*t);
   z1 := z1 + 0.00000000074*cos(2.20184828895 + 37724.7534197482*t);
   z1 := z1 + 0.00000000063*cos(4.45586625948 + 7079.3738568078*t);
   z1 := z1 + 0.00000000047*cos(2.04946724464 + 3128.3887650958*t);
   z1 := z1 + 0.00000000061*cos(0.63918772258 + 33794.5437235286*t);
   z1 := z1 + 0.00000000047*cos(3.32543843300 + 26087.9031415742*t);
   z1 := z1 + 0.00000000049*cos(1.60680905005 + 6702.5604938666*t);
   z1 := z1 + 0.00000000057*cos(0.11215813438 + 29088.811415985*t);
   z1 := z1 + 0.00000000049*cos(3.02832204050 + 20426.571092422*t);
   z1 := z1 + 0.00000000041*cos(5.55329394890 + 11015.1064773348*t);
   z1 := z1 + 0.00000000041*cos(5.91861144924 + 23581.2581773176*t);
   z1 := z1 + 0.00000000045*cos(2.00068583743 + 426.598190876*t);
   z1 := z1 + 0.00000000045*cos(4.95273290181 + 5863.5912061162*t);
   z1 := z1 + 0.00000000050*cos(3.62740835096 + 41654.9631159678*t);
   z1 := z1 + 0.00000000046*cos(1.65798680284 + 25158.6017197654*t);
   z1 := z1 + 0.00000000036*cos(5.61836577943 + 12566.1516999828*t);
   z1 := z1 + 0.00000000036*cos(6.24373396652 + 6283.14316029419*t);
   z1 := z1 + 0.00000000036*cos(0.40465162918 + 6283.0085396886*t);
   z1 := z1 + 0.00000000032*cos(6.09025731476 + 64809.80550494129*t);
   z1 := z1 + 0.00000000032*cos(6.03707103538 + 2942.4634232916*t);
   z1 := z1 + 0.00000000041*cos(4.86809570283 + 1592.5960136328*t);
   z1 := z1 + 0.00000000037*cos(1.04055368426 + 213.299095438*t);
   z1 := z1 + 0.00000000031*cos(3.62641145030 + 13095.8426650774*t);
   z1 := z1 + 0.00000000028*cos(4.38359423735 + 7632.9432596502*t);
   z1 := z1 + 0.00000000030*cos(2.03616887071 + 12139.5535091068*t);
   z1 := z1 + 0.00000000028*cos(6.03334294232 + 17789.845619785*t);
   z1 := z1 + 0.00000000026*cos(3.88971333608 + 5331.3574437408*t);
   z1 := z1 + 0.00000000031*cos(1.44666331503 + 16730.4636895958*t);
   z1 := z1 + 0.00000000026*cos(6.26376705837 + 23543.23050468179*t);
   z1 := z1 + 0.00000000023*cos(4.44388985550 + 18849.2275499742*t);
   z1 := z1 + 0.00000000025*cos(4.13395006026 + 3154.6870848956*t);
   z1 := z1 + 0.00000000028*cos(1.53862289477 + 6279.4854213396*t);
   z1 := z1 + 0.00000000028*cos(1.96831814872 + 6286.6662786432*t);
   z1 := z1 + 0.00000000028*cos(5.78094918529 + 15110.4661198662*t);
   z1 := z1 + 0.00000000025*cos(0.62040343662 + 10988.808157535*t);
   z1 := z1 + 0.00000000022*cos(6.02390113954 + 16496.3613962024*t);
   z1 := z1 + 0.00000000026*cos(2.48165809843 + 5729.506447149*t);
   z1 := z1 + 0.00000000020*cos(3.85655029499 + 9623.6882766912*t);
   z1 := z1 + 0.00000000021*cos(5.83006047147 + 7234.794256242*t);
   z1 := z1 + 0.00000000021*cos(0.69628570421 + 398.1490034082*t);
   z1 := z1 + 0.00000000022*cos(5.02222806555 + 6127.6554505572*t);
   z1 := z1 + 0.00000000020*cos(3.47611265290 + 6148.010769956*t);
   z1 := z1 + 0.00000000020*cos(0.90769829044 + 5481.2549188676*t);
   z1 := z1 + 0.00000000020*cos(0.03081589303 + 6418.1409300268*t);
   z1 := z1 + 0.00000000020*cos(3.74220084927 + 1589.0728952838*t);
   z1 := z1 + 0.00000000018*cos(1.58348238359 + 2118.7638603784*t);
   z1 := z1 + 0.00000000019*cos(0.85407021371 + 14712.317116458*t);
   return z1*t;
end earth_z1;
