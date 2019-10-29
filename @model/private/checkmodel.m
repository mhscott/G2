function checkmodel(a)
% CHECKMODEL(A) Check that parameters for model are valid

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

numpar = 6;
if length(a) ~= numpar
	error([int2str(numpar) ' cells required in list for creating model'])
end

nnodes = size(a{2},1);
np=size(a{6},1);

if nnodes ~= size(a{3},1) | ( np > 0 & np ~= nnodes ) 
	error(['Inconsistent number of nodes in model:' a{1}])
end

if size(a{4},1) ~= length(a{5}) 
	error(['Inconsistent number of elements in model:' a{1}])
end

dofnod = size(a{6},2);
if dofnod > 0 & dofnod ~= size(a{3},2)
	error(['Inconsistent number of DOF/node in model:' a{1}])
end
