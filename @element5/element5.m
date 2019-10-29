function el = element5(a,elno)
% ELEMENT5 2D Truss element: bilinear material, small displacement
%
% Element Description
% ------------------------------------
% Class:           element5
% Type:            Truss
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    3
% Material:        Bilinear
% Kinematics:      Small displacements
% State Determ.:   Total
%
% Usage
% ------------------------------------
% el=ELEMENT5(a,elno)
%
% Required:
% elno = Element number
% a(1) = Elastic modulus (E),
%			first slope = E
% a(2) = Strain hardening ratio (alpha),
%			second slope = alpha*E
% a(3) = Yield stress
% a(4) = Cross sectional area
%%
% Object Fields
% ------------------------------------
% Data:
% el.e1  = First slope, E
% el.e2  = Second slope, alpha*E
% el.sy  = Yield stress
% el.a   = Cross sectional area

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

el.no = elno;
el.e1 = a(1);
el.e2 = a(2) * el.e1;
el.sy = a(3);
el.ey = el.sy / el.e1;
el.a  = a(4);

el = class(el,'element5');

