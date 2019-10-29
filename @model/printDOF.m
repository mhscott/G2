function printDOF( mod, U )
% MODEL/PRINTDOF(MOD,U) Print nodal displacements

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Print nodal displacements

[nnodes ndim] = size(mod.XYZ);
ndofn = size(mod.BOUND,2);

if nnodes > 0
	
	% Prepare heading for table
	
	code1 = '   No.  ';
	code2 = '------- ';
	code3 = '%6.0f  ';
	for i=1:ndofn
		code1 = [code1 '     ' int2str(i) '      '];
		code2 = [code2 '----------  '];
		code3 = [code3 '%10.3e  '];
	end

	% Print table
	
	disp('NODAL DISPLACEMENTS');
	disp(sprintf(code1));
	disp(sprintf(code2));

	for i=1:nnodes
		dof = mod.DOF(i,:);
		disp(sprintf(code3, i, U(dof) ));
	end

	disp(sprintf(code2));
end
