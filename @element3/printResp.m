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

% Form basic stiffness matrix and initial force.
% Start by initializing axial component
kb = zeros(3);
s0 = zeros(3,1);
kb(3,3) = el.e * el.a / L;

% Flexure contribution without releases
kbf = ( el.e / L ) * [ 4*el.I 2*el.I;
                       2*el.I 4*el.I ];

% Compute basic deformations
v = a * u(:,1);

% Initial basic force  without releases -- normal only in this version
w = lambda * el.q;

mom = w(1) * L^2 / 12;
s0f = [ mom -mom ]';

% Define basic stiffness and initial basic force for 
% each case with end moment releases

if el.r == 0				% no releases
	kb(1:2,1:2) = kbf;
	s0(1:2)     = s0f;
	
elseif el.r == 1			% release s1
	kb(2,2) = kbf(2,2) - kbf(2,1) * kbf(1,2) / kbf(1,1);
	s0(2)   = [ -kbf(2,1)/kbf(1,1) 1 ] * s0f;
		
elseif el.r == 2			% release s2
	kb(1,1) = kbf(1,1) - kbf(1,2) * kbf(2,1) / kbf(2,2);
	s0(1)   = [ 1 -kbf(1,2)/kbf(2,2) ] * s0f;
		
else					% release s1 and s2
	kb(1:2,1:2) = 0;
	s0(1:2)		= 0;
	
end

% Basic force with modified basic stiffness and initial force
s = kb * v + s0;

% Member forces
shear  = ( s(1) + s(2) ) / L;
shear0 = w(1) * L / 2;

f      =  zeros(1,8);
f(1:2) = s(3)  * [ -1 1 ]; 
f(3:4) = shear * [ 1 -1 ] + shear0 * [ 1 1 ];
f(5:6) = s(1:2);

% Rotations at releases          (EDITED FOR HOMEWORK # 3)
if el.r == 0       % no releases
   f(7:8) = 0;
   
elseif el.r == 1   % release s1
   v1r  = (-kbf(1,2) * v(2) - s0f(1)) / kbf(1,1);
   f(7) = v(1) - v1r;
   f(8) = 0;
   
elseif el.r == 2   % release s2
   v2r  = (-kbf(2,1) * v(1) - s0f(2)) / kbf(2,2);
   f(7) = 0;
   f(8) = v(2) - v2r;
   
elseif el.r == 3   % release s1 and s2
   v1r  = (-kbf(2,2) * s0f(1) + kbf(1,2) * s0f(2)) / ...
                      (kbf(1,1) * kbf(2,2) - kbf(1,2) * kbf(2,1));
   v2r  = -(-kbf(2,1) * s0f(1) + kbf(1,1) * s0f(2)) / ...
                      (kbf(1,1) * kbf(2,2) - kbf(1,2) * kbf(2,1));
   f(7) = v(1) - v1r;
   f(8) = v(2) - v2r;

end

if strcmp(flag,'print')

	if el.r == 0
		str1 = sprintf(['No. %3.0f, Type=' class(el) ...
  		',  Axial Force = [%10.3e, %10.3e]\n' ...
 		'                         Shear Force = [%10.3e, %10.3e]\n' ...
  		'                         Moment      = [%10.3e, %10.3e]'],  ... 
		el.no, f(1:6) );
	else 
		str1 = sprintf(['No. %3.0f, Type=' class(el) ...
  		',  Axial Force = [%10.3e, %10.3e]\n' ...
 		'                         Shear Force = [%10.3e, %10.3e]\n' ...
  		'                         Moment      = [%10.3e, %10.3e]\n' ...
		'                         Release Rot.= [%10.3e, %10.3e]'], el.no, f );
	end
	
	disp(str1);
end
