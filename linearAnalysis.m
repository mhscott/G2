function linearAnalysis(mod)
% LINEARANALYSIS(MOD) Linear analysis on model MOD.
%
% Input Parameters
% ----------------
% MOD = The model to be analyzed

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Variables used in function
% ---------------------------------------------------------
%	ndof		= number of DOF
%	ntot		= total number of all  DOF
%	free		= range of free DOF (1:ndof)
%	nelem		= number of elements in elemlist
%	elemlist	= list of elements
%	lamba		= 1 (load factor)
%	U		= vector of displacements for all DOF
%	P		= nodal load vector in model for all DOF
%	P0		= restoring force vector for all DOF
%	Kf		= stiffness matrix for all DOF
%	K		= stiffness matrix for free DOF
%	Pr		= residual force vector (P-P0) for free DOF
%	nresidual   	= 2-norm of Pr (Euclidean norm)
% ---------------------------------------------------------

% Get data from model
[ ndof ntot P elemlist] = getData(mod);
free  = 1:ndof;
nelem = length(elemlist);

% Initialize global vectors and matrix
P0 = zeros(ntot,1);
U  = zeros(ntot,1);
Kf = zeros(ntot,ntot);

lambda = 1;

% Initialize element state
for i=1:nelem
	[id xyz ue]  = localize( mod, i, U);
	elemlist{i}  = initialize( elemlist{i}, xyz, [], lambda );
end

% Loop over elements to assemble stiffness matrix and load
% vector

for i=1:nelem
	[id xyz ue] = localize( mod, i, U );
	[ke pe]     = state( elemlist{i}, xyz, ue, lambda );
	Kf(id,id) = Kf(id,id) + ke;
	P0(id)    = P0(id)    + pe;
end

% Partition free DOF and solve
K  = Kf(free,free);
Pr = P(free) - P0(free);

U(free) = K \ Pr;

% Print solution displacements and element response
printHead     ( mod    );
printDOF      ( mod, U );
printElemResp ( mod, U, lambda );

% Loop over elements to compute restoring force
% and check residual

P0(:) = 0;
for i=1:nelem
	[id xyz ue] = localize( mod, i, U );
	[ke pe]     = state( elemlist{i}, xyz, ue, lambda );
	P0(id) = P0(id) + pe;
end

Pr = P(free) - P0(free);
nresidual = norm(Pr);

disp(sprintf('\nResidual after solution: %10.3e', nresidual ));
