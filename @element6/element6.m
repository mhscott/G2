function el = element6(a,elno)
% ELEMENT6 2D Truss element: bilinear material (path-dependent), small displacement
%
% Element Description
% ------------------------------------
% Class:           element6
% Type:            Truss
% Dimension:       2 (x-y plane)
% Number of Nodes: 2
% DOF per Node:    3
% Material:        Bilinear
% Kinematics:      Small displacements
% State Determ.:   Path dependent
%
% Usage
% ------------------------------------
% el=ELEMENT6(a,elno)
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
% el.prop  = Material properties: E, alpha*E, sigma-y; and
%				current state: sigma, sigma-b, epsilon, code
% el.a   = Cross sectional area

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

properties.e  = a(1);			% elastic modulus
properties.ep = a(2) * a(1);	% second slope (plastic modulus
properties.sy = a(3);			% yield stress

properties.sc = 0;				% current stress
properties.sb = 0;				% back stress
properties.es = 0;				% current strain
properties.cd = 0;				% yield code

el.no   = elno;
el.prop = properties;
el.a    = a(4);					% cross sectional area

el = class(el,'element6');

