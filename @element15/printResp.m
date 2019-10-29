function f = printResp( el, xyz, u, lambda, flag )
% ELEMENTn/PRINTRESP Print element response

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Original geometry
dx0 = xyz(2,:) - xyz(1,:);
L0  = sqrt( dx0 * dx0' );

% Current geometry with u(:,1) nodal displacements
du = u(3:4,1) - u(1:2,1);
dx = dx0 + du';
L  = sqrt ( dx * dx' );
dx = dx / L;

% Green-Lagrange strain
es = 0.5 * ( L^2 / L0^2 - 1 );

% Basic force and deformation
s  = el.e * el.a * es + el.s0;
d  = L - L0;

% Response quantities
f = [ d s ];

if strcmp(flag,'print')
	str1 = sprintf(['No. %3.0f, Type=' class(el) ...
        ',  Deform.=%10.3e,  Force=%10.3e'], el.no, f );
	disp(str1);
end
