function el = element4(a,elno)
% ELEMENT4 2D Truss element: nonlinear material, small displacement
%
% Element Description
% ------------------------------------
% Class:           element4
% Type:            Truss
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    3
% Material:        Nonlinear (cubic)
% Kinematics:      Small displacements
% State Determ.:   Total
%
% Usage
% ------------------------------------
% el=ELEMENT4(a,elno)
%
% Required:
% elno = Element number
% a(1) = Cross sectional area
% a(2) = sigma-0
% a(3) = epsilon-0
%
% Object Fields
% ------------------------------------
% Data:
% el.sig0  = sigma-0
% el.eps0  = epsilon-0
% el.a     = Cross sectional area

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

el.no    = elno;
el.a     = a(1);
el.sig0  = a(2);
el.eps0  = a(3);

el = class(el,'element4');

