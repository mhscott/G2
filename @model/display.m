function display(mod)
% MODEL/DISPLAY(MOD) Print model

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Print header

disp('------------------------------------------------------------------------');
str1=sprintf([ g2 '\n' ...
              'MODEL:   ' mod.NAME '\n' ...
			  'CREATED: ' mod.DATE '\n' ...
			  '------------------------------------------------------------------------\n' ]);
disp(str1);

% Print nodal coordinates and DOF

[nnodes ndim] = size(mod.XYZ);
ndofn = size(mod.BOUND,2);

if nnodes > 0
	
	% Prepare heading for table
	
	code1 = '   No.  ';
	code2 = '------- ';
	code3 = '   %3.0f  ';
	for i=1:ndim
		code1 = [code1 '    X(' int2str(i) ')    '];
		code2 = [code2 '----------  '];
		code3 = [code3 '%10.3e  '];
	end
	for i=1:ndofn
		code1 = [code1 '  ' int2str(i) ' '];
		code2 = [code2 ' ---' ];
		code3 = [code3 ' %3.0f'];
	end

	% Print table
	
	disp('NODAL COORDINATES AND DOF NUMBERING');
	disp(sprintf(code1));
	disp(sprintf(code2));

	for i=1:nnodes
		
		dofnumbers = mod.DOF(i,:);
		for j=1:ndofn
			if dofnumbers(j) > mod.nfree
				dofnumbers(j) = 0;
			end
		end

		disp(sprintf(code3, i, mod.XYZ(i,:), dofnumbers ));
	end

	disp(sprintf(code2));
end

% Print number of DOF
disp(sprintf('\nNumber of DOF = %6.0f', mod.nfree'));

% Print nodal loads

[nnodes ndofn] = size(mod.NODELOAD);

if nnodes > 0
	
	% Prepare heading for table
	
	code1 = '   No.  ';
	code2 = '------- ';
	code3 = '%6.0f   ';
	for i=1:ndofn
		code1 = [code1 '      ' int2str(i) '    '];
		code2 = [code2 ' ----------' ];
		code3 = [code3 '%10.3e '];
	end

	% Print table
	
	disp(sprintf('\nNODAL LOADS'));
	disp(sprintf(code1));
	disp(sprintf(code2));

	for i=1:nnodes
		disp(sprintf(code3, i, mod.NODELOAD(i,:)) );
	end

	disp(sprintf(code2));
end


% Print element connectivity

[nelem nodelm1] = size(mod.CONNECT);

if nelem > 0
	
	code1 = '   No.  ';
	code2 = '------- ';
	code3 = '%6.0f';
	for i=1:(nodelm1-1)
		code1 = [code1 '  ' int2str(i) '   '];
		code2 = [code2 '----- '];
		code3 = [code3 '  %4.0f'];
	end
	code1 = [code1 ' El. Type'];
	code2 = [code2 ' --------'];
	code3 = [code3 '    %3.0f'];

	disp(sprintf('\nELEMENT CONNECTIVITY AND TYPE'));
	disp(sprintf(code1));
	disp(sprintf(code2));

	% Print table
	
	for i=1:nelem
		disp(sprintf(code3,i,mod.CONNECT(i,:)));
	end
	disp(sprintf(code2));
end

% Print element data

if nelem > 0
	disp(sprintf('\nELEMENT DATA'));
	code2 = '------------------------------------------------------------------------';
	disp(code2);

	for i=1:nelem
		printData(mod.ELEMLIST{i});
	end

	disp(code2);
end
