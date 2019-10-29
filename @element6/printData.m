function printData(el)
% ELEMENTn/PRINTDATA(EL) Print element data

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

str1 = sprintf(['No. %3.0f, Type=' class(el) ...
        ',  E1=%10.3e, E2=%10.3e, Fy=%10.3e\n' ...
		'                         A =%10.3e'], ...
		el.no, el.prop.e, el.prop.ep, el.prop.sy, el.a );
disp(str1);
