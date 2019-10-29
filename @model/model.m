function mod = model(a)
% MODEL Model class constructor
% MOD=MODEL(A) creates a model object from the cell array a containing
% the following cells:
% 	A{1} = string to describe model
%	A{2} = matrix of geometric coordinates of nodes
%	A{3} = matrix of boundary condition codes for nodes
%	A{4} = matrix of element connectivity and type
%	A{5} = cell array material data for elements
%	A{6} = array of loads applied to nodes.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

if nargin == 0
	mod.NAME     = 'Undefined model';
	mod.DATE     = ' ';
	mod.XYZ      = [];
	mod.BOUND    = [];
	mod.DOF      = [];
	mod.nfree    = 0;
	mod.ID       = [];
	mod.CONNECT  = [];
	mod.MATERIAL = [];
	mod.NODELOAD = [];
	mod.ELEMLIST = [];
	mod.Pfinal   = [];
	mod.Ufinal   = [];
	
	mod = class(mod,'model');
	
elseif isa(a,'model')
	mod = a;
	
else
	checkmodel(a);
	
	mod.NAME     = a{1};
	mod.DATE     = datestr(now);
	mod.XYZ      = a{2};
	mod.BOUND    = a{3};
	[ mod.DOF mod.nfree ntot] = dof_numberer(a{3});
	mod.CONNECT  = a{4};
	mod.ID       = id_numberer(mod.CONNECT,mod.DOF);
	mod.MATERIAL = a{5};
	mod.NODELOAD = a{6};
	mod.ELEMLIST = [];
	mod.Pfinal   = zeros(ntot,1);
	mod.Ufinal   = zeros(ntot,1);

	mod = class(mod,'model');
	
end

% Create elements

ellist = createElements(mod);
mod.ELEMLIST = ellist;
