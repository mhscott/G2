function f = printResp( el, xyz, u, lambda, flag )
% ELEMENTn/PRINTRESP Print element response
% f(1:6) are axial forces, shear forces, and moments at ends
% f(7:7+nsec-1) are curvatures at integration points
% f(7+nsec:7+2*nsec-1) are the axial strain at integration points

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

dx = xyz(2,:) - xyz(1,:);	% geometry restricted to 1,2 plane (x,y)
L  = sqrt( dx * dx' );
dx = dx / L;

nsec = el.nsecs;

% Set up response vector, f
nf = 6 + nsec*2;
f  = zeros(1,nf);

% Member forces (from el.si at last commit)
shear  = ( el.si(1) + el.si(2) ) / L;
f(1:2) = el.si(3)  * [ -1 1 ]; 
f(3:4) = shear * [ 1 -1 ];
f(5:6) = el.si(1:2);

% Section deformations
j = 7;
for i=1:nsec
	vs = printResp( el.secs(i) );
	f(j)      = vs(1);	% curvature
	f(j+nsec) = vs(2);	% axial strain
	j = j + 1;
end
    
if strcmp(flag,'print')
	str1 = sprintf(['No. %3d, Type=' class(el) ...
  	',  Axial Force = [%11.3e, %11.3e]\n' ...
 	'                          Shear Force = [%11.3e, %11.3e]\n' ...
  	'                          Moment      = [%11.3e, %11.3e]\n'], ...
	el.no, f(1:6) );	
	disp(str1);
end
