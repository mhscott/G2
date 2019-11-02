% Cantilever Beam
% Inelastic behavior using element12
% CE 221

% The solution follows the steps below:

% (1) Define model parameters and loads
% (2) Define model of cantilever beam
% (3) Perform nonlinear analysis (uniform or variable laod steps)
% (4) Plot displaced shape and load-displacement curve
% (5) Extract curvature and strain distributions
% (6) Plot curvature, axial strain, and depth distributions
% (7) Compute maximum strain


% (1) Define model parameters and loads
% -------------------------------------
% Number of elements and integration points/element
nelem = 10;
nint  = 5;

% Strain hardening
alpha=0.02;

% Loading at cantilever tip
maxload = 125;
maxaxial = 500;

% Reference loads for load stepping solution
nstep = 10;				% Number of load steps
ref   = maxload/nstep;			% Reference lateral load
Axial = maxaxial/nstep;			% Reference axial load

minlamb = 0.1;				% Minimum load step
					% (variableLoadNR)


% (2) Define model of cantilever beam
% -----------------------------------
len   = 120;	% Length of beam

XYZ   = zeros(nelem+1,2);
BOUND = zeros(size(XYZ,1),3);
BOUND(1,:) = [ 1 1 1 ];

CONNECT = zeros(nelem,3);
CONNECT(:,3) = 12;	%element12

for i=1:nelem
	XYZ(i+1,1) = i*(len/nelem);
	CONNECT(i,1:2) = [ i i+1];
end

% Rectangular section (h=12 in., b=10 in.)
% Material properties (E=30000 ksi, sigy=36 ksi)
h = 12;
b = 10;
nfib = 6;
mat = [ h b 3 b nfib nfib 30000 36 alpha nint];

MATERIAL = cell(nelem,1);
for i=1:nelem
	MATERIAL{i} = [ mat ];
end

% Loads
LOAD            = zeros(nelem+1,3);
LOAD(nelem+1,:) = [-Axial ref 0];		% Load at tip

% Creat model
a  = { 'Inelastic Cantilever', XYZ, BOUND, CONNECT, MATERIAL, LOAD };
m1 = model(a)


% (3) Perform nonlinear analysis
% ------------------------------
tol = 1e-4;
dof = 3*nelem - 1; % Vertical DOF at tip

% Uniform load increment
%[m1,plt,plte] = simpleNewtonRaphson(m1, [ nstep 1 10 tol],[dof],[1:nelem]);

% Variable load increment
gamma = 1.0;
[m1,plt,plte] = variableloadNR(m1,[ nstep*2 2 nstep 10 tol gamma minlamb], ... 
			[dof],[1:nelem]);
nstep = size(plt,1) - 1;


% (4) Plot displaced shape and load-displacement curve
% ----------------------------------------------------
plot(m1)

% Plot lateral load as function of tip displacement
figure(2)
clf

sr = 1:(nstep+1);
plot(plt(sr,2),plt(sr,1)*ref,'b-square')
grid
xlabel('Tip Displacement (in.)')
ylabel('Lateral Load (kip)')

tlab = sprintf(['Cant. Beam: nelem=%2d, nint=%1d, alpha=%5.3f,' ...
		' Axial=%6.1f'], nelem,nint,alpha,maxaxial);
title(tlab)


% (5) Extract curvature and strain distributions
% ----------------------------------------------

% Recover the deformations at the sections and plots the
% distribution of deformation for the load steps

% Form curvature and axial strain distribution arrays
curv = zeros(nstep,nelem*nint);
eaxr = zeros(nstep,nelem*nint);

for i=1:nstep
	for j=1:nelem
		f=plte{i+1,j};
		rran=((j-1)*nint+1):(j*nint);
		curv(i,rran) = f(7:(7+nint-1));
		eaxr(i,rran) = f((7+nint):(7+nint*2-1));
	end
end

% x-coordinate along beam according to integration points
xint = Gauss(nint);		% change to Lobatto if rule is used

x = zeros(1,nelem*nint);

for i=1:nelem
	nd = CONNECT(i,1:2);
	xn = XYZ(nd,1);
	
	% transform element i to x-coordinate and store 
	x(((i-1)*nint+1):(i*nint)) = sum(xn)/2 + xint * diff(xn)/2;
end

% Depth of neutral axis from top of beam
depth = h/2 - eaxr./curv;


% (6) Plot curvature, axial strain, and depth distributions
% ---------------------------------------------------------
figure(3)
clf

% Curvature
subplot(3,1,1)
plot(x,curv)
grid
ylabel('Curvature (1/in)')
title(tlab)

% Axial strain at reference axis
subplot(3,1,2)
plot(x,eaxr)
axis([0 len -.01 0 ])
grid
ylabel('Strain')

% Depth of neutral axis (from top)
subplot(3,1,3)
plot(x,depth)
grid
axis([0 len 0 12 ]);
ylabel('NA Depth (in.)')
xlabel('X (in.)')


% (7) Compute maximum strain
% --------------------------

% Maximum strain at first integration point for element 1
km  = curv(nstep,1);
eam = eaxr(nstep,1);
em  = eam - h/2 * km;

str2 = sprintf('\nMax. curv=%11.3e, Max. ea=%11.3e\nMaximum Strain=%11.3e', ...
		km, eam, em );
disp(str2)
