function [k, p] = state( el, xyz, u, lambda )
% ELEMENTn/STATE State determination
% [k p]=STATE(el,xyz,u,lambda)

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

dx = xyz(2,:) - xyz(1,:);	% geometry restricted to 1,2 plan (x,y)
L  = sqrt( dx * dx' );
dx = dx / L;

% Form kinematic matrix
a  = [ -dx(2)/L  dx(1)/L  1  dx(2)/L -dx(1)/L  0;
       -dx(2)/L  dx(1)/L  0  dx(2)/L -dx(1)/L  1;
       -dx(1)   -dx(2)    0  dx(1)    dx(2)    0 ];

% Form basic stiffness matrix
kb = ( el.e / L ) * [ 4*el.I 2*el.I    0;
                      2*el.I 4*el.I    0;
	                     0         0 el.a ];
	  
% Initial basic force
w = lambda * el.q;

mom = w(1) * L^2 / 12;
s0  = [ mom -mom -w(2)*L/2 ]';

% Basic force
s = kb * a * u(:,1) + s0;

% Reactions for basic system
shear = w(1) * L / 2 * [ -dx(2) dx(1) ];
axial = w(2)*L * [-dx(1) -dx(2)];
p0    = [ shear+axial 0 shear+axial 0 ]'; 

% Restoring force and stiffness matrix
p = a' * s + p0;
k = a' * kb * a;
