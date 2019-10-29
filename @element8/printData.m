function printData(el)
% ELEMENTn/PRINTDATA(EL) Print element data

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

str1 = sprintf(['No. %3.0f, Type=' class(el) ...
        ',  E =%10.3e, A=%10.3e, I=%10.3e,\n'  ...
		'                         My=%10.3e, alpha=%10.3e'], ...
		el.no, el.e, el.a, el.I, el.my, el.al );
disp(str1);
