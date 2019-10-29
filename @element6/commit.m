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

% Form kinematic matrix and basic stiffness coefficient
a  = [ -dx(1) -dx(2) 0 dx(1) dx(2) 0 ];

% Deformation - strain based on displacement from last converged state
deps   = a * u(:,2) / L;

% State determination for bilinear material
[ props Et ] = bilinearMat( deps, el.prop);

% Commit state
el.prop = props;
