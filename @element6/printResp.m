function f = printResp( el, xyz, u, lambda, flag )
% ELEMENTn/PRINTRESP Print element response

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

% Use last committed state

s = el.prop.sc * el.a;
f = [ el.prop.es s ];	% Current strain and current axial force

if strcmp(flag,'print')
	str1 = sprintf(['No. %3.0f, Type=' class(el) ...
        ',  Strain=%10.3e,  Force=%10.3e'], el.no, f );
	disp(str1);
end
