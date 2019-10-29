function printData(el)
% ELEMENTn/PRINTDATA(EL) Print element data

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

str1 = sprintf(['No. %3.0f, Type=' class(el) ...
        ',  A=%10.3e, sig0=%10.3e, eps0=%10.3e'], ...
		el.no, el.a, el.sig0, el.eps0 );
disp(str1);
