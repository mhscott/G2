function checkElem(mod,elemlist)
% MODEL/CHECKELEM Check element numbers are valid
% CHECKELEM(MOD,ELMELIST) check that elements in ELEMLIST array
% are valid elements.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

if max( elemlist > length(mod.ELEMLIST) ) == 1
	error('Specified elements are not valid.');
end
