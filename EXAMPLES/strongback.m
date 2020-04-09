% Simplified model of strongback frame system
%   https://wp.me/pbejzW-iV
%
% Detailed model and experimental results
%   https://doi.org/10.1061/(ASCE)ST.1943-541X.0001960
%

% Base units
kN = 1.0;
mm = 1.0;

% Derived units
cm = 10*mm;
GPa = kN/mm^2;
inch = 25.4*mm;

% Nodal coordinates
XYZ = zeros(7,2);
XYZ(2,:) = [0 3099];
XYZ(3,:) = [0 3099+2793];
XYZ(4,:) = [3048 3099];
XYZ(5,:) = [3048+3048 0];
XYZ(6,:) = [3048+3048 3099];
XYZ(7,:) = [3048+3048 3099+2793];
XYZ = XYZ*mm;

% Boundary conditions
BOUND = zeros(size(XYZ,1),3);
BOUND(1,:) = [1 1 1];
BOUND(5,:) = [1 1 0];

% Element connectivity
%          I J elem
CONNECT = [1 2   2
2 3 2
5 6 2
6 7 2
2 4 3 % release
4 6 2
3 7 3 % release
1 4 1 % trusses
4 5 1
4 7 1];

E = 200*GPa;

% W10x54 strong axis
A = 15.8*inch^2;
I = 303*inch^4;
MATERIAL{1} = [E A I];
MATERIAL{2} = [E A I];

% W10x54 weak axis
I = 103*inch^4;
MATERIAL{3} = [E A I];
MATERIAL{4} = [E A I];

% W14x53
A = 15.6*inch^2;
I = 541*inch^4;
MATERIAL{5} = [E A I 1];
MATERIAL{6} = [E A I];
MATERIAL{7} = [E A I 1];

% HSS6x6x1/2
A = 9.74*inch^2;
MATERIAL{9} = [E A];

% HSS8x8x5/8
A = 16.4*inch^2;
MATERIAL{10} = [E A];

% BRB
E = 300*GPa;
A = 32*cm^2;
MATERIAL{8} = [E A];


% Nodal loads
LOAD = zeros(size(XYZ,1),3);
LOAD(2,1) = 1.0/3*kN;
LOAD(3,1) = 2.0/3*kN;



% Create model
clear a
a = {'Strongback Frame', XYZ, BOUND, CONNECT, MATERIAL, LOAD};

m1 = model(a)

linearAnalysis(m1);
