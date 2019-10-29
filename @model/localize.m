function [id, xyz, ue] = localize(mod,elem,U)
% MODEL/LOCALIZE Get element ID, coordinates, and displacements
% [ID,XYZ,UE]=LOCALIZE(MOD,ELEM,U) returns  ID array,  coordinate array,
% and displacement array for element number ELEM.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% ID Array
n  = mod.ID(elem,1)+1;
id = mod.ID(elem,2:n);

% Nodal coordinates allowing for different number of nodes

con = mod.CONNECT(elem,:);
xyz = [];

for i=1:(length(con)-1)
	nod = con(i);
	if nod > 0
		xyz(i,:) = mod.XYZ(nod,:);
	end
end

% Displacements
ue = U(id,:);
