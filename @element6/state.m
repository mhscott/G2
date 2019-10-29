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

% Form kinematic matrix and basic stiffness coefficient
a  = [ -dx(1) -dx(2) 0 dx(1) dx(2) 0 ];

% Deformation - strain based on displacement from last converged state
deps   = a * u(:,2) / L;

% State determination for bilinear material, return estimate of
% stress (sig) and tangent modulus (Et)
[ props Et ] = bilinearMat( deps, el.prop );

s = props.sc * el.a;
kb  = Et * el.a / L;

% Restoring force and tangent stiffness matrix
p = a' * s;
k = a' * kb * a;
