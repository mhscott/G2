function [xIP,weight] =  Lobatto (nIP)
% locations (xIP) and weights (weight) for nIP integration points

xIP    = zeros(nIP,1);
weight = zeros(nIP,1);

switch nIP
  case 2
    xIP (1)   = -1.;
    weight(1) =  1.;
    xIP (2)   =  1.;
    weight(2) =  1.;

  case 3
    xIP (1)   = -1.;
    weight(1) =  1/3;
    xIP (2)   =  0.;
    weight(2) =  4/3;
    xIP (3)   =  1.;
    weight(3) =  1/3;

	case 4
	xIP (1)   = -1.;
    weight(1) =  1/6;
    xIP (2)   = -0.44721360;
    weight(2) =  5/6;
    xIP (3)   =  0.44721360;
    weight(3) =  5/6;
    xIP (4)   =  1.;
    weight(4) =  1/6;
 
	case 5
	xIP(1)    = -1.;
    weight(1) =  0.1;
    xIP(2)    = -0.65465367;
    weight(2) =  0.5444444444;
    xIP(3)    =  0.;
    weight(3) =  0.7111111111;
    xIP(4)    =  0.65465367;
    weight(4) =  0.5444444444;
    xIP(5)    =  1.;
    weight(5) =  0.1;

  case 6
    xIP(1)    = -1.;
    weight(1) =  0.06666666667;
    xIP(2)    = -0.7650553239;
    weight(2) =  0.3784749562;
    xIP(3)    = -0.2852315164;
    weight(3) =  0.5548583770;
	xIP(4)    = -xIP(3);
	weight(4) =  weight(3);
	xIP(5)    = -xIP(2);
	weight(5) =  weight(2);
	xIP(6)    = -xIP(1);
	weight(6) =  weight(1);

  case 7
    xIP (1)   = -1.;
    weight(1) =  0.04761904762;
    xIP (2)   = -0.8302238962;
    weight(2) =  0.2768260473;
    xIP (3)   = -0.4688487934;
    weight(3) =  0.4317453812;
	xIP (4)   =  0.;
	weight(4) =  0.4876190476;
	xIP (5)   = -xIP(3);
	weight(5) =  weight(3);
	xIP (6)   = -xIP(2);
	weight(6) =  weight(2);
	xIP (7)   = -xIP(1);
	weight(7) =  weight(1);

  case 8
    xIP(1)    = -1.;
    weight(1) =  0.03571428571;
    xIP(2)    = -0.8717401485;
    weight(2) =  0.2107042271;
    xIP(3)    = -0.5917001814;
    weight(3) =  0.3411226924;
    xIP(4)    = -0.2092992179;
    weight(4) =  0.4124587946;
    xIP(5)    = -xIP(4);
    weight(5) =  weight(4);  
	xIP(6)    = -xIP(3);
    weight(6) =  weight(3);
	xIP(7)    = -xIP(2);
    weight(7) =  weight(2);
	xIP(8)    = -xIP(1);
    weight(8) =  weight(1);

  case 9
    xIP (1)   = -1.;
    weight(1) =  0.02777777778;
    xIP (2)   = -0.8997579954;
    weight(2) =  0.1654953615;
    xIP (3)   = -0.6771862795;
    weight(3) =  0.2745387125;
    xIP (4)   = -0.3631174638;
    weight(4) =  0.3464285109;
    xIP (5)   =  0.;
    weight(5) =  0.3715192743;
    xIP (6)   = -xIP (4);
    weight(6) =  weight(4);  
	xIP (7)   = -xIP (3);
    weight(7) =  weight(3);
	xIP (8)   = -xIP (2);
    weight(8) =  weight(2);
	xIP (9)   = -xIP (1);
    weight(9) =  weight(1);

  case 10
    xIP (1)   = -1.;
    weight(1) =  0.02222222222;
    xIP (2)   = -0.9195339082;
    weight(2) =  0.1333059908;
    xIP (3)   = -0.7387738651;
    weight(3) =  0.2248893421;
    xIP (4)   = -0.4779249498;
    weight(4) =  0.2920426836;
    xIP (5)   = -0.1652789577;
    weight(5) =  0.3275397611;
    xIP (6)   = -xIP (5);
    weight(6) =  weight(5);  
	xIP (7)   = -xIP (4);
    weight(7) =  weight(4);
	xIP (8)   = -xIP (3);
    weight(8) =  weight(3);
	xIP (9)   = -xIP (2);
    weight(9) =  weight(2);
	xIP (10)  = -xIP (1);
    weight(10)=  weight(1);

  otherwise
	error('Invalid order for Lobatto integration.')
	
end
