function el = element1(a,elno)
% ELEMENT1 2D Truss element: linear elastic material, small displacement
%
% Element Description
% ------------------------------------
% Class:           element1
% Type:            Truss
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    3
% Material:        Linear elastic
% Kinematics:      Small displacements
% State Determ.:   Total
%
% Usage
% ------------------------------------
% el=ELEMENT1(a,elno)
%
% Required:
% elno = Element number
% a(1) = Elastic modulus
% a(2) = Cross sectional area
%
% Optional:
% a(3) = Initial axial force
%
% Object Fields
% ------------------------------------
% Data:
% el.e  = Elastic modulus
% el.a  = Cross sectional area
% el.s0 = Initial axial force

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

el.no = elno;
el.e  = a(1);
el.a  = a(2);

if length(a) == 3
	el.s0  = a(3);
else
	el.s0 = 0;
end

el = class(el,'element1');

