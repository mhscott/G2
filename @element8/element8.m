function el = element8(a,elno)
% ELEMENT8 2D Beam-column inelastic element with two component model
%
% Element Description
% -------------------------------------------
% Class:           element8
% Type:            Beam-column 
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    3
% Material:        Two-component inelastic
% Kinematics:      Small displacements
% State Determ.:   Total
%
% Usage
% -------------------------------------------
% el=ELEMENT8(a,elno)
%
% Required:
% elno = Element number
% a(1) = Elastic modulus
% a(2) = Strain hardening ratio
% a(3) = Yield moment
% a(4) = Cross sectional area
% a(5) = Moment of inertia
%
% Object Fields
% ----------------------------------------
% Data:
% el.e  = Elastic modulus
% el.a  = Cross sectional area
% el.I  = Moment of inertia
% el.al = Strain hardening ratio (alpha)
% el.my = Yield moment

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% ----------------------------------------

el.no = elno;
el.e  = a(1);
el.al = a(2);
el.my = a(3);
el.a  = a(4);
el.I  = a(5);

el = class(el,'element8');

