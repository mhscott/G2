function sec = commit( sec, dvs )
% WFSECTION/COMMIT Commit state of fiber section
% [SEC]=COMMIT(SEC,DV) For section SEC undergoing a change
% in section deformation DV=[curvature strain],
% commit new state

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

fibers = sec.fibers;
numfib = length(fibers);

% Loop over fibers
for i=1:numfib
	
	as = fibers(i).as;
	
	% Change in strain
	deps = as * dvs;
	
	% Material state determination
	[prop Et] = bilinearMat( deps, fibers(i).pr );
	
	% Store fiber state
	fibers(i).pr = prop;
	
end

% Commit state of all fibers
sec.fibers = fibers;

% Update section deformations (for output)
sec.vs     = sec.vs + dvs;
