function  ID = id_numberer ( CON, DOF )
% ID_NUMBERER Creates ID table
% ID=ID_NUMBERER(CON,DOF) creates ID table from connectivity table
% CON and dof table DOF.  The first column of DOF is the number of 
% non-zero dof in the rest of the table.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

[nelem nodelm1] = size(CON);
nodelm = nodelm1 - 1;
dofnod = size(DOF,2);
ID     = zeros(nelem,1+nodelm*dofnod);

for i=1:nelem
	
	num = 0;
	lid = [];
	for j=1:nodelm
		nod = CON(i,j);
		if nod > 0 
			lid = [ lid DOF(nod,:) ];
			num = num + dofnod;
		end
	end

	ID(i,1)                 = num;
	ID(i,2:(1+length(lid))) = lid;
	
end
