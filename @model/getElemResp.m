function elemresp = gettElemResp(mod, U, lambda, plotelem )
% MODEL/GETELEMRESP(MOD,U,LAMBDA,PLOTELEM) Get responses of elements
% in array PLOTELEM

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

ellist   = mod.ELEMLIST;
nelem    = length(plotelem);
elemresp = cell(1,nelem);

for i=1:nelem
	el = plotelem(i);
	[id xyz ue] = localize(mod, el, U );
	elemresp{1,i} = printResp( ellist{el}, xyz, ue, lambda, 'noprint' );
end


