function str=g2
% G2 Matrix structural analysis
%
% G2 is a Matlab framework for matrix structural analysis.
%
% Matlab 5.0 or greater is required to use G2.  The directory
% structure is important for proper operation.  The G2 directory
% must have a subdirectory '@model' and ore more subdirectories
% '@elementn' where n= 1, 2 , 3 ....  Analysis procudedures are
% normally in the G2 directory.
%
% 'help model' gives information about creating a model.  Use
% 'help elementn' where n=1,2,3 ... for information about the
%  elements.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

g2version = '0.1 (UC Berkeley, CE 221)';

str = sprintf(['G2 - MATRIX STRUCTURAL ANALYSIS WITH MATLAB ' ... 
		version '\nVERSION: ' g2version ]);
