function el = commit( el, xyz, u, lambda )
% ELEMENTn/COMMIT Commit current state
% EL=COMMIT(EL,XYZ,U,LAMBDA)

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

% Incremental basic deformations
dv = a * u(:,2);

% Interpolation functions (terms in B matrix)
% evaluated at integration points
x  = (  el.xip + 1 ) / 2;
b1 = (6*x-4)/L;
b2 = (6*x-2)/L;
b3 = ones(size(x))/L;

% Commit state of sections

for i=1:el.nsecs
	
	% Form B matrix and compute section deformation
	B = [ b1(i) b2(i) 0; 0 0 b3(i) ];
	dvs = B * dv;
	
	% Commit section state
	el.secs(i) = commit( el.secs(i), dvs );

end
