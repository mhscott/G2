function ellist = createElements(mod)
% MODEL/CREATEELEMENTS(MOD) Create element list for model

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

[nelem nnodes1] = size(mod.CONNECT);
ellist = cell(1,nelem);

for i=1:nelem
	eltyp = mod.CONNECT(i,nnodes1);
	elstr = ['element' int2str(eltyp)];
	elno  = int2str(i);
	
	eval([ 'el=' elstr '(mod.MATERIAL{' elno '},' elno ');']);
		
	ellist{i} = el;
end

