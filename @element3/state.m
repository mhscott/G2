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

% Form basic stiffness matrix and initial force.
% Start by initializing axial component
kb = zeros(3);
s0 = zeros(3,1);
kb(3,3) = el.e * el.a / L;

% Flexure contribution without releases
kbf = ( el.e / L ) * [ 4*el.I 2*el.I;
                       2*el.I 4*el.I ];
					   
% Initial basic force  without releases -- normal only in this version
w = lambda * el.q;

mom = w(1) * L^2 / 12;
s0f = [ mom -mom ]';

% Define basic stiffness and initial basic force for 
% each case with of end moment releases

if el.r == 0				% no releases
	kb(1:2,1:2) = kbf;
	s0(1:2)     = s0f;
	
elseif el.r == 1			% release s1
	kb(2,2) = kbf(2,2) - kbf(2,1) * kbf(1,2) / kbf(1,1);
	s0(2)   = [ -kbf(2,1)/kbf(1,1) 1 ] * s0f;
	
elseif el.r == 2			% release s2
	kb(1,1) = kbf(1,1) - kbf(1,2) * kbf(2,1) / kbf(2,2);
	s0(1)   = [ 1 -kbf(1,2)/kbf(2,2) ] * s0f;
	
else					% release s1 and s2
	kb(1:2,1:2) = 0;
	s0(1:2)     = 0;
end

% Basic force with modified basic stiffness and initial force
s = kb * a * u(:,1) + s0;

% Reactions for basic system  -- normal only in this version
shear = w(1) * L / 2 * [ -dx(2) dx(1) ];
p0    = [ shear 0 shear 0 ]'; 

% Restoring force and stiffness matrix
p = a' * s + p0;
k = a' * kb * a;
