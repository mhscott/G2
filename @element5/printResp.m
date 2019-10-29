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

% Form kinematic matrix and basic stiffness coefficient
a  = [ -dx(1) -dx(2) 0 dx(1) dx(2) 0 ];

% Deformation
eps = a * u(:,1) / L;

% State determination for bilinear material
if abs(eps) <= el.ey
	
	% Elastic
	kb  = el.e1 * el.a / L;
	sig = el.e1 * eps;

else
	
	% Post yield - strain hardening
	kb  = el.e2 * el.a / L;
	sig = ( el.sy + el.e2 * ( abs(eps) - el.ey ) ) * sign(eps);

end

s = sig * el.a;
f = [ eps s ];

if strcmp(flag,'print')
	str1 = sprintf(['No. %3.0f, Type=' class(el) ...
        ',  Strain=%10.3e,  Force=%10.3e'], el.no, f );
	disp(str1);
end
