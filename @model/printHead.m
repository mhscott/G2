function printHead(mod)
% MODEL/PRINTHEAD(MOD) Print header for solution

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Print header

disp('------------------------------------------------------------------------');
str1=sprintf([ g2 '\n' ...
              'MODEL:   ' mod.NAME '\n' ...
			  'CREATED: ' mod.DATE '\n' ...
			  'RUN:     ' datestr(now) '\n' ...
			  '------------------------------------------------------------------------\n' ]);
disp(str1);
