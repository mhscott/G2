function el = element2(a,elno)
% ELEMENT2 2D Beam-column element: linear elastic material, small displacement
%
% Element Description
% ----------------------------------------
% Class:           element2
% Type:            Beam-column
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    3
% Material:        Linear elastic
% Kinematics:      Small displacements
% State Determ.:   Total
%
% Usage
% ----------------------------------------
% el=ELEMENT2(a,elno)
%
% Required:
% elno = Element number
% a(1) = Elastic modulus
% a(2) = Cross sectional area
% a(3) = Moment of inertia
%
% Optional:
% a(4) = wn, distributed load, normal direction
% a(5) = ws, distributed load, tangential direction
%
% Object Fields
% ----------------------------------------
% Data:
% el.e  = Elastic modulus
% el.a  = Cross sectional area
% el.I  = Moment of inertia
% el.q  = [ wn ws ]

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% ----------------------------------------

el.no = elno;
el.e  = a(1);
el.a  = a(2);
el.I  = a(3);

if length(a) > 3
	el.q  = [ a(4) a(5) ];
else
	el.q = [ 0 0 ];
end

el = class(el,'element2');

