function f = printResp( el, xyz, u, lambda, flag )
% ELEMENTn/PRINTRESP Print element response

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

dx = xyz(2,:) - xyz(1,:);	% geometry restricted to 1,2 plane (x,y)
L  = sqrt( dx * dx' );
dx = dx / L;

% Form kinematic matrix
a  = [ -dx(1) -dx(2) 0 dx(1) dx(2) 0 ];

% Evaluate strain and normalize to epsilon-0
v = a * u(:,1);			% deformation using total displacement
eps = v / L / el.eps0;	% normalized strain

% Evaluate stress and then basic force
sig = el.sig0 * ( 3 * eps - eps^3 );
s   = el.a * sig;

f = [ eps*el.eps0 s ]; % strain, axial force

if strcmp(flag,'print')
	str1 = sprintf(['No. %3.0f, Type=' class(el) ...
 	       ',  Strain=%10.3e,  Force=%10.3e'], el.no, f );
	disp(str1)
end
