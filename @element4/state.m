function [k, p] = state( el, xyz, u, lambda )
% ELEMENTn/STATE State determination
% [k p]=STATE(el,xyz,u,lambda)

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% This element is formulated in total displacement, so it can
% only represent path-dependent behavior.

dx = xyz(2,:) - xyz(1,:);	% geometry restricted to 1,2 plane (x,y)
L  = sqrt( dx * dx' );
dx = dx / L;

% Form kinematic matrix
a  = [ -dx(1) -dx(2) 0 dx(1) dx(2) 0 ];

% Evaluate strain and normalize to epsilon-0
v = a * u(:,1);			% deformation using total displacement
eps = v / L / el.eps0;	% normalized strain

% Evaluate stress and then basic force
sig = el.sig0 * ( 3 * eps - eps^3 );
s   = el.a * sig;

% Evaluate tangent to stress-strain curve
E  = 3 * (  el.sig0 / el.eps0 ) * ( 1 - eps^2 );
kb = E * el.a / L;

% Restoring force and stiffness matrix
p = a' * s;
k = a' * kb * a;
