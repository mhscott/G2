function [ndof, ntot, P, ellist, Pf, Uf] = getData(mod)
% MODEL/GETDATA(MOD) Get data from model for analysis

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

ndof  = mod.nfree;
[nnodes numdofnod ] = size(mod.DOF);
ntot  = nnodes * numdofnod;

% Create load vector

P = zeros(ntot,1);

if size(mod.NODELOAD,1) > 0
	for i=1:nnodes
		id = mod.DOF(i,:);
		P(id) = P(id) + mod.NODELOAD(i,:)';
	end
end

% Element list
ellist = mod.ELEMLIST;

% Current nodal loads and displacements
Pf = mod.Pfinal;
Uf = mod.Ufinal;
