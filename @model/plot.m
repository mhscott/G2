function plot( mod, title, scale )
% MODEL/PLOT Plot the model MOD.
% PLOT(MODE,TITLE, SCALE) plot MOD.  TITLE is an optional label for
% 	the plot.  SCALE is an optional scale factor for the
% 	displaced shape; the default value is 0.15 (the maximum displacement
%	is plotted as 15% of the largest dimension of the model.
% 	Plotting is restricted to models with two-node elements in the 1,2 plane.
%
%	Usage:
%	PLOT(MOD)		Plot model MOD.
%	PLOT(MOD,TITLE)		Plot model MOD with the string TITLE printed
%				at the top.  TITLE can be a cell array of
%				strings, one cell per line.
%	PLOT(MOD,TITLE,SC)	Plot model MOD with string TITLE.  Scale
%				displaced shape by SC, which is the ratio
%				between the largest displacement and the
%				largest X1 or X2 dimension of the model.

% G2 - Matrix Structural Analysis with Matlab
% Version 0.1
% University of California, Berkeley
% Copyright 1999, Gregory L. Fenves
% fenves@ce.berkeley.edu
% --------------------------------------

defaultscale = 0.15;		% Default scale factor for
				% displaced shape
							
% Coordinates and size of model

xyz = mod.XYZ(:,1:2);
con = mod.CONNECT(:,1:2);

nnodes = size(xyz,1);
sz     = max ( [ max(xyz(:,1)) - min(xyz(:,1)),  ...
	         max(xyz(:,2)) - min(xyz(:,2)) ] );

% Construct graph of the model

gr = zeros(nnodes);
for i=1:size(con,1)
	n1 = con(i,1);
	n2 = con(i,2);
	gr(n1,n2) = 1;
	gr(n2,n1) = 1;
end

% Determine scale factor for displaced shape
 
Uf  = mod.Ufinal;
idx = mod.DOF(:,1);
idy = mod.DOF(:,2);
um  = [ min(Uf(idx)) max(Uf(idx)) ...
        min(Uf(idy)) max(Uf(idy)) ];
usz = max(abs(um));

if nargin > 2
	fac = scale;		% Third argument is scale factor
else
	fac = defaultscale;
end

if usz ~= 0
	fac  = fac * sz/usz; lcol ='r';
else
	fac  = 0; lcol = 'b';
end

% Define coordinates for displaced shape

xyzd = zeros(size(xyz));
for j=1:nnodes
	id = mod.DOF(j,1:2);
	xyzd(j,1:2) = xyz(j,1:2) + Uf(id)' * fac;
end

% Determine axis based on largest dimension of model and
% displaced shape

ax = [ min( [ xyz(:,1); xyzd(:,1) ] )  max( [ xyz(:,1); xyzd(:,1) ] )  ...
       min( [ xyz(:,2); xyzd(:,2) ] )  max( [ xyz(:,2); xyzd(:,2) ] ) ];

% Create the figure for plotting

figNumber=figure( ...
      'Name',mod.NAME, ...
      'NumberTitle','off', ...
      'Visible','off', ...
      'DoubleBuffer','on', ...
      'BackingStore','off', ...
      'Colormap',[], ...
      'Pointer', 'crosshair' );
axes( ...
      'Units','normalized', ...
      'Position',[0.08 0.2 0.85 0.75], ...
      'Visible','off', ...
      'NextPlot','add');

axis(ax);
axis image;
axis off;
set(figNumber,'Visible','on' );

% Plot model

[xd, yd] = gplot(gr,xyz);
h = plot(xd,yd);
set(h,'XData',xd,'YData',yd);
set(h,'Color',lcol,'Marker','square');

% Plot displaced shape

if fac ~= 0
	[xd1 yd1] = gplot(gr,xyzd);
	h = plot(xd1,yd1);
	set(h,'XData',xd1,'YData',yd1);
	set(h,'Color','b','Marker','+');
end

% Set up axes for other information

h1 = axes ('Position',[0 0 1 1],'Visible','off', ...
		'NextPlot','add');
set(gcf,'currentaxes',h1);

% Title, if specified in the second argument

if nargin > 1
	titlecolor = 'b';
	text(0.06,0.90,title,'FontUnits','normalized','FontSize',.03, ...
		'FontName','helvetica','Color',titlecolor);
end

% Label block

str='G2';
text(.70,.09,str,'FontUnits','normalized','FontSize',.08, ...
	'FontName','helvetica','FontAngle','italic', 'Color','b')
str1(1)={'Matrix Structural'};
str1(2)={'Analysis with Matlab'};
text(.79,.10,str1,'FontUnits','normalized','FontSize',.024, ...
	'FontName','helvetica');
str2='University of California, Berkeley';
text(.71,.045,str2,'FontUnits','normalized','FontSize',.02, ...
	'FontName','helvetica');
	
str3(1)={mod.NAME};
str3(2)={mod.DATE};
text(.38,.115,str3,'FontUnits','normalized','FontSize',.024, ...
	'FontName','helvetica');
	
% Border lines

axis([0 1 0 1]);
zs = 0.03; zb = 0.97;
line( 'XData',[zs zb],'YData',[ .15 .15 ] );
line( 'XData',[.69 .69],'YData',[zs .15 ] );
line( 'XData',[zs zb],'YData',[zs zs] );
line( 'XData',[zs zb],'YData',[zb zb] );
line( 'XData',[zs zs],'YData',[zs zb] );
line( 'XData',[zb zb],'YData',[zs zb] );

% Plot axes and maximum displacement values

corner = .045; cend = corner+.06;
line( 'XData',[corner-.01 cend],'YData',[ corner corner ] );
line( 'XData',[corner corner],'YData',[ corner-.01 cend ] );

if usz ~= 0
	ust1 = sprintf('U1 = [%11.3e, %11.3e]', um(1:2) );
	ust2 = sprintf('U2 = [%11.3e, %11.3e]', um(3:4) );
	text(cend+.02,corner+.01,ust1,'FontUnits','normalized','FontSize',.024, ...
		'FontName','times');
	text(corner,cend+.02,ust2,'FontUnits','normalized','FontSize',.024, ...
		'FontName','times');

end
