function f = printResp( el, xyz, u, lambda, flag )
% ELEMENTn/PRINTRESP Print element response

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

dx = xyz(2,:) - xyz(1,:);	% geometry restricted to 1,2 plan (x,y)
L  = sqrt( dx * dx' );
dx = dx / L;

% Form kinematic matrix and basic stiffness coefficient
a  = [ -dx(1) -dx(2) 0 dx(1) dx(2) 0 ];
kb = el.e * el.a / L;

% Deformation and basic force
v = a * u(:,1);
s = kb * v + el.s0;

f = [ v s ];

if strcmp(flag,'print')
	str1 = sprintf(['No. %3.0f, Type=' class(el) ...
        ',  Deform.=%10.3e,  Force=%10.3e'], el.no, f );
	disp(str1);
end
