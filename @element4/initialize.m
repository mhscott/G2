function el = initialize( el, xyz, u, lambda )
% ELEMENTn/INITIALIZE Initialize element state
% EL=STATE(el,xyz,u,lambda)

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

dx = xyz(2,:) - xyz(1,:);	% geometry restricted to 1,2 plane (x,y)
L  = sqrt( dx * dx' );

if L < eps
	error(['Element number' int2str(el.elno) ' has zero length.']);
end
