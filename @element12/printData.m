function printData(el)
% ELEMENTn/PRINTDATA(EL) Print element data

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

kpfact = 20;

% Compute properties for first section
sec1 = el.secs(1);
ky   = el.ky;

% Elastic flexure at curvature=ky
[sy ksy] = state( sec1, [ ky  0 ]' );

% Plastic flexure at curvature=kp
[sp ksp] = state( sec1, [ kpfact*ky  0 ]' );

% Print summary properties of element
str1 = sprintf(['No. %3d, Type=' class(el) ...
        ', EI=%11.3e, EA=%11.3e, \n'  ...
		'                         My=%11.3e, Mp=%11.3e (@%2d*Ky), \n',  ...
		'                         nint =%2d,       Ky=%11.3e' ], ...
		el.no, ksy(1,1),ksy(2,2), sy(1), sp(1), kpfact, el.nsecs, el.ky );
disp(str1);
