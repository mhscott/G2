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

% Basic forces from previous converged load step
si = el.si;

% Interpolation functions for equilibrium
% evaluated at integration points
x  = (  el.xip + 1 ) / 2;
b1 = -( 1 - x );
b2 =        x  ;
b3 = ones(size(x));

% Initialize vector of ds for iteration
ds = zeros(3,1);

% Parameters for iteration
maxiter = 10;
tol     = 1e-10;

% Section deformations
nsec  = el.nsecs;
dvsec = zeros(2,nsec);

% Iterate on section forces to determine
% compatibility

for j=1:maxiter
	
	% Compute residual and basic flexibility by
	% summing section properties over integration points
	
	vr = dv;
	fb = zeros(3);
	
	for i=1:nsec
		bs = [ b1(i) b2(i) 0; 0 0 b3(i) ];
		ss = bs * ( ds + si );
		
		% Section state determination
		[ dvs, ks ] = equilibrium( el.secs(i), ss );
		dvsec(:,i) = dvs;
				
		% Section contribution to residual and flexibility
		vr = vr - bs' * dvs          * ( el.weight(i) * L/2 );
		fb = fb + bs' * inv(ks) * bs * ( el.weight(i) * L/2 );
	end

	if norm(vr) < tol
		break
	end
	
	ds = fb \ vr + ds;
	
end

% Commit section state with converged dvs
for i=1:nsec
	el.secs(i) = commit( el.secs(i), dvsec(:,i) );
end
	
% Commit basic forces for element
el.si = ds + si;
