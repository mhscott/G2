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

% Form kinematic matrix
a  = [ -dx(2)/L  dx(1)/L  1  dx(2)/L -dx(1)/L  0;
       -dx(2)/L  dx(1)/L  0  dx(2)/L -dx(1)/L  1;
       -dx(1)   -dx(2)    0  dx(1)    dx(2)    0 ];

% Form basic stiffness matrix
kb = ( el.e / L ) * [ 4*el.I 2*el.I    0;
                      2*el.I 4*el.I    0;
	                     0        0 el.a ];

% Initial basic force
w = lambda * el.q;

mom = w(1) * L^2 / 12;
s0  = [ mom -mom -w(2)*L/2 ]';

% Basic force
s = kb * a * u(:,1) + s0;

% Member forces
shear  = ( s(1) + s(2) ) / L;
shear0 = w(1) * L / 2;
axial0 = w(2) * L;

f    =  zeros(1,6);
f(1:2) = s(3)  * [ -1 1 ] + axial0 * [-1 1 ]; 
f(3:4) = shear * [ 1 -1 ] + shear0 * [ 1 1 ];
f(5:6) = s(1:2);

if strcmp(flag,'print')
	str1 = sprintf(['No. %3.0f, Type=' class(el) ...
  	',  Axial Force = [%10.3e, %10.3e]\n' ...
 	'                         Shear Force = [%10.3e, %10.3e]\n' ...
  	'                         Moment      = [%10.3e, %10.3e]'], el.no, f );
	disp(str1);
end
