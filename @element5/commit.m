function el = commit( el, xyz, u, lambda )
% ELEMENTn/COMMIT Commit current state
% EL=COMMIT(EL,XYZ,U,LAMBDA)

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% No commit required because the element is linear and
% the formulation is in terms of displacement at last
% converged step.
