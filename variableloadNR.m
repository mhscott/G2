function [mod, plt, pltel] = variableloadNR(mod, control, plotdofs, plotelem )
% VARIABLELOADNR Nonlinear analysis with Newton-Raphson procedure and variable load step
% 	[MOD,PLT, PLTEL]=VARIABLELOAD(MOD,CONTROL,PLOTDOFS, PLOTELEM) Nonlinear analysis of 
% 	a model using the Newton-Raphson strategy under load control.
%	The loading is applied variable increments as a function of the
%	"effective stiffness" at the current load step. Loading is continued
%	until the maximum load steps is reached or until the maximum load
%	factor is reached.
%	The function returns arrays of specified DOF and element responses
%	for load steps up to NSTEP steps.
%	
%	Input Parameters
%	----------------
%	MOD      = The model to be analyzed
%	CONTROL  = Array of elements for controling solution:
%		CONTROL(1) = maximum number of load steps
%		CONTROL(2) = initial load increment (delta-lambda0)
%		CONTROL(3) = maximum load factor
%		CONTROL(4) = Maximum number of equilibrium iterations
%				per load step
%		CONTROL(5) = Tolerance for equilibrium residual
%				for convergence of load step
%		CONTROL(6) = exponent on "effective stiffness"
%				(default to 1)
%		CONTROL(7) = minimum delta-lambda (default to 0)
%	PLOTDOFS = Array of DOF's for which response is stored (for plotting)
%	PLOTELEM = Array of DOF's for which response is stored (for plotting)
%	
%	Return Variables
%	----------------
%   	MOD   = model with updated state after solution.
%	PLT   = Matrix of load factors (lambda) and values of DOF for
%			each load step. PLT(:,1) contain the load factors (0-1)
%			for the load steps.  PLT(:,1+j) contains the values of
%			dof=PLOTDOF(j) for the load steps.
%	PLTEL = Cell array of element responses.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1a	(modified 3/22/99)
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------


% Variables used in function
% ---------------------------------------------------------
%	nsteps		= maximum number of load steps
%	nstep		= load step number
%	maxiter		= max. equilibrium iterations per load step
%	tol		= tolerance for equilibrium iterations
%	ndof		= number of DOF
%	ntot		= total number ofall  DOF
%	free		= range of free DOF (1:ndof)
%	nelem		= number of elements in elemlist
%	elemlist	= list of elements
%	loadstep	= current load step
%   	dlamb		= load increment
%	lambda		= load factor for current load step
%	maxlamb		= maximum load factor
%	iter		= counter of equilibrium iterations
%	totaliter   	= total number of iterations (equation solves)
%	nplots1		= 1 + number of DOF to plot
%	nplots2		= number of elements to plot
%
%	U		= matrix of displacements for all DOF
%			U(:,1) = current total displacement vector
%			U(:,2) = displ. vector since last committed state
%			U(:,3) = increment displacement vector
%
%	U1old		= previous solution (used only for output if solution
%				does not converge)
%	Ur		= displacement vector used for computing
%				"effective stiffness"; not used for solution
%	Pref		= nodal load vector in model for all DOF		
%	P		= scaled nodal load vector (lambda*Pref)
%	P0		= restoring force vector for all DOF
%	Pr		= residual force vector (P-P0) for free DOF
%	nresidual   	= 2-norm of Pr (Euclidean norm)
%	Kf		= tangent stiffness matrix for all DOF
%	K		= tangent stiffness matrix for free DOF
%	cnd		= condition number of K
% ---------------------------------------------------------

% Define solution parameters
nsteps  = control(1);
dlamb   = control(2);
maxlamb = control(3);
maxiter = control(4);
tol     = control(5);
if length(control) > 5
	gamma = control(6);
else
	gamma = 1;
end
if length(control) > 6
	dlambmin = control(7);
else
	dlambmin = 0;
end

% Get data from model
[ndof ntot Pref elemlist] = getData(mod);
free  = 1:ndof;
nelem = length(elemlist);

% Initialize restoring force vector, stiffness matrix,
% and displacement vectors
P0 = zeros(ntot,1);
Kf = zeros(ntot,ntot);
U  = zeros(ntot,3);
U1old = U(:,1);

% Initialize plot data for displacements and element responses
if nargin > 2 & length(plotdofs) > 0
	checkDOF( mod, plotdofs );
	nplots1  = length(plotdofs) + 1;
	plt      = zeros( nsteps+1, nplots1 );
	plotdofs = plotdofs';
	plotdofflag = 1;
else
	plt = [];
	plotdofflag = 0;
end

if nargin > 3 & length(plotelem) > 0
	checkElem( mod, plotelem )
	nplots2 = length(plotelem);
	pltel   = cell(nsteps+1,nplots2 );
	plotelemflag = 1;
else
	pltel = [];
	plotelemflag = 0;
end


% Initialize element state 
for i=1:nelem
	[id xyz ue]  = localize( mod, i, U);
	elemlist{i}  = initialize( elemlist{i}, xyz, ue, 0 );
end

% Perform linearization in initial state
Kf(:) = 0;
for i=1:nelem
	[id xyz ue] = localize( mod, i, U );
	[ke pe]     = state( elemlist{i}, xyz, ue, 0 );
	Kf(id,id) = Kf(id,id) + ke;
end

% Solve for reference load and compute initial "effective stiffness"
Ur = zeros(ntot,1);
Ur(free) = Kf(free,free) \ Pref(free);
sp0 = (Ur'*Pref)/(Ur'*Ur);

% Print header for summary of load steps
printHead(mod);
disp(sprintf(['SUMMARY OF LOAD STEPS\n' ...
				'Step         Lambda Iters     Residual\n' ...
			  	'--------------------------------------' ]));

totaliter = 0;
lambda    = 0;
nstep     = 0;

% Loop over load steps
				
for loadstep = 1:nsteps
	
	% Break load step loop if current lambda is greater 
	% than maximum lambda
	if lambda > maxlamb
		break
	end
	
	% Perform linearization in current state and compute current
	% "effective stiffness"
	Kf(:) = 0;
	for i=1:nelem
		[id xyz ue] = localize( mod, i, U );
		[ke pe]     = state( elemlist{i}, xyz, ue, 0 );
		Kf(id,id) = Kf(id,id) + ke;
	end
	Ur(free) = Kf(free,free) \ Pref(free);
	sp = (Ur'*Pref)/(Ur'*Ur);		% Note: no dlamb in here 

	% Determine delta-lambda based on "effective stiffness"
	dlamb = dlamb * abs( sp / sp0 ) ^ gamma;
	dlamb = max ([dlamb dlambmin]);
	sp0   = sp;
	
	% Increment load
	lambda = lambda + dlamb;
	P = lambda * Pref;
	
	% Perform equilibrium iterations for load step
	
	iter   = 0;
	for it=1:maxiter
		
		% Loop over elements to assemble tangent stiffness
		% and restoring force

		P0(:) = 0;
		Kf(:) = 0;
		for i=1:nelem
			[id xyz ue] = localize( mod, i, U );
			[ke pe]     = state( elemlist{i}, xyz, ue, lambda );
			Kf(id,id) = Kf(id,id) + ke;
			P0(id)    = P0(id)    + pe;
		end

		% Partition free DOF and compute residual vector
		K  = Kf(free,free);
		Pr = P(free) - P0(free);

		% Exit equilibrium loop if 2-norm of residual vector
		% is less than tolerance
		nresidual = norm(Pr);
		if nresidual < tol
			break
		end
	
		U(free,3) = K \ Pr;

		% Update displacements
		U(:,1) = U(:,1) + U(:,3);
		U(:,2) = U(:,2) + U(:,3);
		
		iter = iter + 1;
	
	end  % End equilibrium iteration loop

	
	% Check that equilibrium iteration loop converged
	% If not, break load step loop after reverting to
	% previous load step that did converge. 
	
	if nresidual > tol
		strc = ['No convergence with residual ' num2str(nresidual) ...
			' > ' num2str(tol)  ' in ' int2str(maxiter) ' iterations' ...
			' for load step ' int2str(loadstep) ];
		disp(strc);
		
		lambda = lambda - dlamb;
		U(:,1) = U1old;
		
		break
	end

	% Commit element state using converged displacements
	for i=1:nelem
		[id xyz ue]  = localize( mod, i, U);
		elemlist{i}  = commit( elemlist{i}, xyz, ue, lambda );
	end
	
	% Update model
	mod = update (mod, elemlist, P, U(:,1) );

	% Zero '2' displacement vector after commit
	U(:,2) = 0;
	
	% Store total displacement for recovery if solution does
	% not converge in next iteration
	U1old = U(:,1);
	
	% Store DOF values and element responses for plotting
	if plotdofflag
		plt(loadstep+1,1)		  = lambda;
		plt(loadstep+1,2:nplots1) = U(plotdofs,1)';
	end

	if plotelemflag
		pltel(loadstep+1,:) = getElemResp( mod, U, lambda, plotelem );
	end
	
	% Print status of load step
	str1 = sprintf(' %3d    %11.3e   %3d  %11.3e', loadstep, lambda, iter, nresidual );
	disp(str1);

	totaliter = totaliter + iter;
	nstep     = nstep + 1;
	
	
end  % End load step loop

% Return plt and pltel for load steps computed
% in the solution
plt   = plt(1:nstep+1,:);
pltel = pltel(1:nstep+1,:);


% Print response after last load step
strf = sprintf(['--------------------------------------\n' ...
	'Total   %11.3e   %3d\n'], lambda, totaliter);
disp(strf);

printDOF      ( mod, U(:,1) );
printElemResp ( mod, U, lambda );
