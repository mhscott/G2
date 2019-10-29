function [ s, kb, vr ] = compatibility ( el, dv, L, control )
% ELEMENT12/COMPATIBILTY Solve compatibility equation for flexibility element

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

if nargin > 3
	maxiter = control(1);
	tol	= control(2);
else
	maxiter = 10;
	tol     = 1e-10;
end

% Basic forces from previous converged load step
si = el.si;

% Interpolation functions for equilibrium
% evaluated at integration points
x  = (  el.xip + 1 ) / 2;
b1 = -( 1 - x );
b2 =        x;  
b3 = ones(size(x));

% Initialize vector of ds for iteration
ds = zeros(3,1);

% Iterate on section forces to determine
% compatibility

for j=1:maxiter
	
	% Compute residual and basic flexibility by
	% summing section properties over integration points
	
	vr = dv;
	fb = zeros(3);
	
	for i=1:el.nsecs
		bs = [ b1(i) b2(i) 0; 0 0 b3(i) ];
		ss = bs * ( ds + si );
		
		% Section state determination
		[dvs, ks ] = equilibrium( el.secs(i), ss );
		
		% Section contribution to residual and flexibility
		vr = vr - bs' * dvs          * ( el.weight(i) * L/2 );
		fb = fb + bs' * inv(ks) * bs * ( el.weight(i) * L/2 );
	end

	if norm(vr) < tol
		break
	end
	
	ds = fb \ vr + ds;
	
end

% Define return variables;
s  = ds + si;
kb = inv(fb);

