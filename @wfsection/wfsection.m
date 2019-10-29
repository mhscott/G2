function sec = wfsection(dim,ns,mat)
% wfsection wide flange section class constructor
% SEC=WFSECTION(DIM,NS,MAT) creates a section object from data:
%	dim = [ h bf tf tw ]	height, flange width, flange thick, web thick
%	ns  = [ nf nw ],	number of fibers for flange and web
%	mat = [ E sy, alpha ]	E, yield stress, second slope

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Section geometry
h  = dim(1);	% height
bf = dim(2);	% flange width
tf = dim(3);	% flange thickness
tw = dim(4);	% web thickness

% Section discretization
nf = ns(1);		% fibers in each flange
nw = ns(2);		% fibers in web

% Bilinear material properties
prop.e     = mat(1);			% modulus of elasticity
prop.sy    = mat(2);			% yield stress
prop.ep    = mat(1)*mat(3);		% second slope
prop.sc    = 0;
prop.sb    = 0;
prop.cd    = 0;
prop.es    = 0;

% Properties of fibers (set in loops below)
fiber.as   = [ 0 0 ];
fiber.ar   = 0;
fiber.pr   = prop;

% Create flange fibers

fibthick  = tf / nf;
fiber.ar  = fibthick * bf;

yf = h/2 - fibthick/2;
for i=1:2:nf*2
	
	% top flange
	fiber.as = [ -yf 1 ];
	fibers(i) = fiber;
	
	% bottom flange
	fiber.as = [  yf 1 ];
	fibers(i+1) = fiber;
	
	yf = yf - fibthick;
end

% Create web fibers

fibthick  = ( h - 2*tf ) / nw;
fiber.ar  = fibthick * tw;

yf = h/2 - tf - fibthick/2;
for i=1:nw
	fiber.as = [ -yf 1 ];
	fibers(i+2*nf) = fiber;
	yf = yf - fibthick;
end

% Create section object

sec.fibers = fibers;	% Fiber data
sec.vs	   = [ 0 0]';	% Section deformations

sec = class(sec,'wfsection');
