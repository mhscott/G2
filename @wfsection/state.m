function [ss, ks] = state( sec, dvs )
% WFSECTION/STATE State determination for fiber section
% [SS KS]=STATE(SEC,DV) For section SEC undergoing a change
% in section deformation DV=[curvature strain], compute
% section forces SS=[moment axial] and the 2x2 tangents
% section stiffness KS.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

fibers = sec.fibers;
numfib = length(fibers);

ks = zeros(2,2);
ss = zeros(2,1);

% Loop over fibers
for i=1:numfib
	
	as = fibers(i).as;
	ar = fibers(i).ar;
	
	% Change in strain
	deps = as * dvs;
	
	% Material state determination for fiber
	[prop Et] = bilinearMat( deps, fibers(i).pr );
	sig = prop.sc;
	
	% Integration -- add contribution of fiber
	ks = ks + as'*as * (ar*Et );
	ss = ss + as'    * (ar*sig);

end



