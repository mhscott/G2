function el = element3(a,elno)
% ELEMENT3 2D Beam-column element with moment releases: linear, small displ.
%
% Element Description
% -------------------------------------------
% Class:           element3
% Type:            Beam-column with optional
%			moment release at ends
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    3
% Material:        Linear elastic
% Kinematics:      Small displacements
% State Determ.:   Total
%
% Usage
% -------------------------------------------
% el=ELEMENT3(a,elno)
%
% Required:
% elno = Element number
% a(1) = Elastic modulus
% a(2) = Cross sectional area
% a(3) = Moment of inertia
%
% Optional:
% a(4) = 0-no release; i-release end i=1,2
% a(5) = wn, distributed load, normal direction
% a(6) = ws, distributed load, tangential direction
%
% Object Fields
% ----------------------------------------
% Data:
% el.e  = Elastic modulus
% el.a  = Cross sectional area
% el.I  = Moment of inertia
% el.r  = End moment release code (0,1,2,3)
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

el.r  = 0;
if length(a) > 3
	if a(4) > 0 & a(4) < 4
		el.r = a(4);
	end
end

if length(a) > 4
	el.q = [ a(5) 0 ];	% Normal load only
elseif length(a) > 5
	el.q = [ a(5) a(6) ];	% Both components
else
	el.q = [ 0 0 ];
end

el = class(el,'element3');

