function  [ DOF, nfree, ntot] = dof_numberer ( BOUND )
% DOF_NUMBERER Number DOF from boundary condition code
% [DOF NFREE NTOT]=DOF_NUMBERER(BOUND) takes a matrix of boundary
% condition codes.  BOUND(i,j)=0 means that node i in global direction
% j is free; BOUND(i,j) != 0 means that node i in global direction j
% is constrained to zero.  The function returns matrix DOF, the same
% size as BOUND with the degree-of-freedom numbering.  DOF 1 to nfree
% are the free degrees-of-freedom.  The total number of DOF, NTOT, is
% the number of elements in BOUND and DOF.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

nnodes = size(BOUND,1);
ndof   = size(BOUND,2);
n      = nnodes*ndof;

DOF = zeros(size(BOUND));
k   = 0;

for i = 1:nnodes
	for j = 1:ndof
		if BOUND(i,j) == 0
			k =  k + 1;
			DOF(i,j) = k;
		else
			DOF(i,j) = n;
			n = n - 1;
		end
	end % loop j
end % loop i

nfree = k;
ntot  = n;
