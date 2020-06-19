% Simplified model of Ziemian frame
%   https://wp.me/pbejzW-Ev
%
% Detailed model and reliability analysis
%   https://doi.org/10.1061/(ASCE)0733-9445(2006)132:2(267)
%

% Include self-weight in analysis (0=no, 1=yes)
sw = 0;

% Base units
kN = 1.0;
mm = 1.0;

% Derived units
m = 1000*mm;
cm = 10*mm;
GPa = kN/mm^2;
inch = 25.4*mm;
ft = 12*inch;
kip = 4.448*kN;
lb = kip/1000;

% Nodal coordinates
XYZ = zeros(9,2);
XYZ(2,:) = [0 6.1];
XYZ(3,:) = [0 6.1+4.57];
XYZ(4,:) = [6.1 0];
XYZ(5,:) = [6.1 6.1];
XYZ(6,:) = [6.1 6.1+4.57];
XYZ(7,:) = [6.1+14.63 0];
XYZ(8,:) = [6.1+14.63 6.1];
XYZ(9,:) = [6.1+14.63 6.1+4.57];
XYZ = XYZ*m;

% Boundary conditions
BOUND = zeros(size(XYZ,1),3);
BOUND(1,:) = [1 1 0];
BOUND(4,:) = [1 1 0];
BOUND(7,:) = [1 1 0];

% Element connectivity
%          I J elem
CONNECT = [1 2   2
2 3 2
4 5 2
5 6 2
7 8 2
8 9 2
2 5 2
5 8 2
3 6 2
6 9 2];

E = 200*GPa;

% W12x14
A = 4.16*inch^2;
I = 88.6*inch^4;
MATERIAL{1} = [E A I 0 sw*-14*lb/ft];

% W10x12
A = 3.54*inch^2;
I = 53.8*inch^4;
MATERIAL{2} = [E A I 0 sw*-12*lb/ft];

% W14x99
A = 29.1*inch^2;
I = 1110*inch^4;
MATERIAL{3} = [E A I 0 sw*-99*lb/ft];

% W14x109
A = 32.0*inch^2;
I = 1240*inch^4;
MATERIAL{4} = [E A I 0 sw*-109*lb/ft];
MATERIAL{6} = [E A I 0 sw*-109*lb/ft];

% W14x82
A = 24*inch^2;
I = 881*inch^4;
MATERIAL{5} = [E A I 0 sw*-82*lb/ft];

% W27x84
A = 24.7*inch^2;
I = 2850*inch^4;
MATERIAL{7} = [E A I 1.0*kN/m + sw*84*lb/ft 0];

% W36x135
A = 39.9*inch^2;
I = 7800*inch^4;
MATERIAL{8} = [E A I 1.0*kN/m + sw*135*lb/ft 0];

% W18x40
A = 11.8*inch^2;
I = 612*inch^4;
MATERIAL{9} = [E A I 0.5*kN/m + sw*40*lb/ft 0];

% W27x94
A = 27.6*inch^2;
I = 3270*inch^4;
MATERIAL{10} = [E A I 0.5*kN/m + sw*94*lb/ft 0];


% Nodal loads
LOAD = zeros(size(XYZ,1),3);

% Create model
clear a
a = {'Ziemian Frame', XYZ, BOUND, CONNECT, MATERIAL, LOAD};

m1 = model(a)

linearAnalysis(m1);
