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
a  = [ -dx(2)/L  dx(1)/L  1  dx(2)/L -dx(1)/L  0;
       -dx(2)/L  dx(1)/L  0  dx(2)/L -dx(1)/L  1;
       -dx(1)   -dx(2)    0  dx(1)    dx(2)    0 ];

% Form basic stiffness matrix and initial force
% Start by initializing axial component
kb = zeros(3);
s  = zeros(3,1);
kb(3,3) = el.e * el.a / L;

% Compute basic deformations
v = a * u(:,1);

% Compute basic forces, tangent matrix, and hinge rotations
% for two-component model
EIL = el.e * el.I / L;

[ sbf kbf vh ] = twocomponent( v(1:2), el.my, el.al, EIL );

s(1:2)      = sbf;
s(3)        = kb(3,3) * v(3);

% Member forces
shear  = ( s(1) + s(2) ) / L;

f      =  zeros(1,8);
f(1:2) = s(3)  * [ -1 1 ]; 
f(3:4) = shear * [ 1 -1 ];
f(5:6) = s(1:2);
f(7:8) = vh;	% plastic hinge rotation

if strcmp(flag,'print')
	str1 = sprintf(['No. %3.0f, Type=' class(el) ...
  	',  Axial Force = [%10.3e, %10.3e]\n' ...
 	'                         Shear Force = [%10.3e, %10.3e]\n' ...
  	'                         Moment      = [%10.3e, %10.3e]\n' ...
	'                         Plastic Rot.= [%10.3e, %10.3e]'], ...
	el.no, f );	
	disp(str1);
end
