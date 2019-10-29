function [ prop, Et ] = bilinearMat ( deps, prop )
% BILINEARMAT Bilinear material model with path-dependent behavior
%	[PROP,ET]=BILINEARMAT(DEPS,PROPS) For strain increment DEPS
%	and PROPS compute new properties for bilinear material.
%	PROP.SY, PROP.E, PROP.EP are the yield stress, first slope,
%	and second slope respectively.  PROP.SC, PROP.SB, PROP.ES
%	are the current stress, back stress, and current strain,
%	respectively. ET is the current tangent modulus.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Material properties
sigy = prop.sy;		% yield stress
E    = prop.e;		% E
Ep   = prop.ep;		% alpha*E

% State from last converged load step
sig  = prop.sc;		% stress
sigb = prop.sb;		% backstress
code = prop.cd;		% yield code
					%	=0, elastic
					%	=1, plastic

if code==0 | ( code==1 & (sig-sigb)*deps < 0 )
	
	% Strain to plastic loading from elastic state
	deps1 = ( sign(deps) * sigy + sigb - sig ) / E;

	% Elastic
	sig  = sig + E * deps;
	Et   = E;
	code = 0;
	
	% Check if plasic loading from elastic state
	if abs(deps) > abs(deps1)
		sig  = sig  + ( Ep - E ) * ( deps - deps1 );
		sigb = sigb +   Ep       * ( deps - deps1 );
		Et   = Ep;
		code = 1;
	end

else
	
	% Continue plastic loading
	sig  = sig  + Ep * deps;
	sigb = sigb + Ep * deps;
	Et   = Ep;
	code = 1;
	
end

% Return updated state. Update strain, although
% not used in this function. Note: this does
% not commit the state.

prop.sc = sig;
prop.sb = sigb;
prop.cd = code;
prop.es = prop.es + deps;	
