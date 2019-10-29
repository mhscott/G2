function [dvs, ks, sr] = equilibrium( sec, ss, control )
% WFSECTION/EQUILIBRIUM Compute section deformations for forces
% [DVS,KS,SR]=EQUILIBRIUM(SEC,SS,CONTROL) For section SEC compute
% section forces give change in section deformations
% from last converged state.
%	
%	Input Parameters
%	----------------
%	SEC	= Section
%	SS	= Section forces
%	CONTROL	= Array of elements for controling solution (optional):
%		CONTROL(1) = Maximum number of equilibrium iterations
%		CONTROL(2) = Tolerance for equilibrium residual
%	
%	Return Variables
%	----------------
%	DVS	= Change in section deformations.
%	KS	= Section stiffness matrix
%	SR	= Residual vector

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

if nargin > 2
	maxiter = control(1);
	tol	= control(2);
else
	maxiter = 10;
	tol     = 1e-10;
end

% Initialize vector of dvs for iteration
u = zeros(2,1);

% Iterate on section equilibrium
for j=1:maxiter
	
	[ssj, ks] = state( sec, u );
	ssres     = ss - ssj;
	
	if norm(ssres) < tol
		break
	end

	u = ks \ ssres + u;
	
end

% Define return variables
dvs = u;
sr  = ssres;
