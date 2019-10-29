function [k, p] = state( el, xyz, u, lambda )
% ELEMENTn/STATE State determination
% [k p]=STATE(el,xyz,u,lambda)

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Original geometry
dx0 = xyz(2,:) - xyz(1,:);
L0  = sqrt( dx0 * dx0' );

% Current geometry with u(:,1) nodal displacements
du = u(3:4,1) - u(1:2,1);
dx = dx0 + du';
L  = sqrt ( dx * dx' );

% Geometry at last converged state
dui = u(3:4,2) - u(1:2,2);
dxi = dx0 + ( du - dui)';
Li  = sqrt ( dxi * dxi' );
dxi = dxi / Li;

% Green-Lagrange strain
es = 0.5 * ( L^2 / L0^2 - 1 );

% Basic system
kb = el.e * el.a / L;
s  = el.e * el.a * es + el.s0;

% Rotation perpendicular to member
dw = ( dui' / L ) * [ -dxi(2) dxi(1) ]';

% Transformation vector
a = [ -1 -dw 1 dw ];

% Geometric stiffness
c  = [ 0 -1 0 1 ];
kg = c'*c * ( s / L );

% Element stiffness and element force
% in local coordinate system
ke = a' * kb * a + kg;
pe = a' * s;

% Transform to global coordinates
R = [ dxi(1) dxi(2)   0     0;
     -dxi(2) dxi(1)   0     0;
	   0     0     dxi(1) dxi(2);
	   0     0    -dxi(2) dxi(1); ];

k = R' * ke * R;
p = R' * pe;

