function checkDOF(mod,doflist)
% MODEL/CHECKDOF Check dofs in last are free
% CHECKDOF(MOD,DOFLIST) check that elements in DOFLIST array
% are free.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

if max( doflist > mod.nfree ) == 1
	error('Specified DOF is not a free.');
end
