function printElemResp(mod, U, lambda )
% MODEL/PRINTELEMRESP(MOD,U,LAMBDA) Print responses of elements

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

ellist   = mod.ELEMLIST;
nelem    = length(ellist);

disp(sprintf('\nELEMENT RESPONSE'));
code2 = '------------------------------------------------------------------------';
disp(code2);

for i=1:nelem
	[id xyz ue] = localize(mod, i, U );
	printResp( ellist{i}, xyz, ue, lambda, 'print' );
end

disp(code2);


