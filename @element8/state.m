function [k, p] = state( el, xyz, u, lambda )
% ELEMENTn/STATE State determination
% [k p]=STATE(el,xyz,u,lambda)

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

dx = xyz(2,:) - xyz(1,:);	% geometry restricted to 1,2 plane (x,y)
L  = sqrt( dx * dx' );
dx = dx / L;

% Form kinematic matrix
a  = [ -dx(2)/L  dx(1)/L  1  dx(2)/L -dx(1)/L  0;
       -dx(2)/L  dx(1)/L  0  dx(2)/L -dx(1)/L  1;
       -dx(1)   -dx(2)    0  dx(1)    dx(2)    0 ];

% Form basic stiffness matrix and force
% Start by initializing axial component
kb = zeros(3);
s  = zeros(3,1);
kb(3,3) = el.e * el.a / L;

% Compute basic deformations
v = a * u(:,1);

% Compute basic forces and tangent matrix for
% two-component model
EIL = el.e * el.I / L;

[ sbf kbf ] = twocomponent( v(1:2), el.my, el.al, EIL );

kb(1:2,1:2) = kbf;
s(1:2)      = sbf;
s(3)        = kb(3,3) * v(3);

% Restoring force and stiffness matrix
p = a' * s;
k = a' * kb * a;
