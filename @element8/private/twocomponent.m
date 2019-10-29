function [ s, kt, vh ] = twocomponent( v, my, alpha, EIL )
% TWOCOMPONENT Two-component inelastic beam model.
% [S,KBF,VH]=TWOCOMPONENT(V,MY,ALPHA,EIL) Basic force, tangent matrix, and
%	hinge rotation for two-component model of prismatic beam.
%
%	Input Parameters
%	----------------
%	v	= basic deformation
%	my 	= yield moment
%	alpha	= hardening ratio
%	EIL	= EI/L
%
%	Return Values
%	-------------
%	s	= basic forces
%	kt	= basic tangent stiffness matrix
%	vh	= hinge rotation
%
%	Subfunctions in this m-file
%	---------------------------
%	increment   -	increment basic force, compute kt and hinge rotation
%	eventfactor -	determine event factor to next hinge formation

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

end2 = 0;

% Basic forces for elastic beam
[sr kt vh]    = increment  ( v, 1, alpha, EIL );
[scale end1]  = eventfactor( [ 0 0]', sr, my, 1 );
s =     scale * sr;
v = (1-scale) * v;

% Beam with one hinge
if end1==2 | end1==3
	
	[sr kt vhr]  = increment  ( v, end1, alpha, EIL );
	[scale end2] = eventfactor( s, sr, my, end1 );
	s  = s  + scale * sr;
	vh = vh + scale * vhr;
	v  =  (1-scale) * v;
end

% Check if both hinges have formed
if end1==4 | end2 == 4
	[sr kt vhr] = increment( v, 4, alpha, EIL );
	s  = s  + sr;
	vh = vh + vhr;
end

return


% ------------------------------------------------------------------------

function [ ds, kf, dvh ] = increment( dv, release, alpha, EIL )
% INCREMENT Compute increment of s and rotation for two-component model
% [DS,KF,DVH]=INCREMENT(DV,RELEASE,ALPHA,EIL) Increment in force
%	and hinge rotation for increment DV in basic deformation
%	return basic tangent matrix, KF, and increment in basic force, DS.
%

% Initialize basic stiffness matrix and hinge rotation matrix
% for four cases
%
% No hinges		 Hinge end 1		   Hinge end 2           Two hinges
% (release=1)		 (release=2)		   (release=3)		 (release=4)
% -----------------  --------------------  --------------------  -------------------
kb(:,:,1)=[4 2;2 4]; kb(:,:,2)=[0  0;0 3]; kb(:,:,3)=[3 0;0  0]; kb(:,:,4)=[0 0;0 0];
vr(:,:,1)=[0 0;0 0]; vr(:,:,2)=[1 .5;0 0]; vr(:,:,3)=[0 0;.5 1]; vr(:,:,4)=[1 0;0 1];


% Basic tangent matrix and Increment in basic force
kf = EIL * ( alpha*kb(:,:,1) + (1-alpha)*kb(:,:,release) );
ds = kf * dv;

% Increment in hinge rotation
dvh = vr(:,:,release) * dv;

return


% ------------------------------------------------------------------------


function [ scale, endr ] = eventfactor( s, sr, my, endx )
% EVENTFACTOR Compute event factor for next hinge
% [SCALE,ENDR]=EVENTFACTOR(S,SR,MY,ENDX) returns SCALE factor for next yield
% 	event with release code ENDR, given the current basic force S and 
%	incremental basic force SR.


% Compute scale factors at end 1 and end 2
if sr(1) ~= 0
	g1 = max( [ (my-s(1))/sr(1) (-my-s(1))/sr(1) ] );
else 
	g1 = 2;
end

if sr(2) ~= 0
	g2 = max( [ (my-s(2))/sr(2) (-my-s(2))/sr(2) ] );
else
	g2 = 3;
end

% Check for first or second hinge forming
if endx==1

	if g1 < g2
		endr = 2; scale = g1;	% Hinge at end 1
	elseif g1 > g2
		endr = 3; scale = g2;	% Hinge at end 2
	elseif g1 == g2
		endr = 4; scale = g1;	% Two hinges form
	else
		scale = 1;
	end
	
elseif endx==2
	endr = 4; scale = g2;		% Second hinge at end 2

elseif endx==3
	endr = 4; scale = g1;		% Second hinge at end 1	
end

% Check that there are no changes in hinges indicated by scale
% factor greater than unity
if scale > 1
	endr = endx;
	scale = 1;
end

return

