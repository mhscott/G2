function el = element15(a,elno)
% ELEMENT15 2D Truss element: linear elastic material, moderate displacements
%
% Element Description
% ------------------------------------
% Class:           element14
% Type:            Truss
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    2 (Translation only)
% Material:        Linear elastic
% Kinematics:      Moderate  displacements
% State Determ.:   Total Lagrangian
%
% Usage
% ------------------------------------
% el=ELEMENT15(a,elno)
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

el = class(el,'element15');

