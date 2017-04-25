% ------------------------------------------------------------------------
% Author: William J. Ebel (all rights reserved)
% Created: 3/26/2012
% Revision History: None
%
% Purpose: Acquires a user-selected set of points from the image in the
%   input arguments. 
%
% Variables: 
%   im   - input image
%   Npts - Number of points to select from the image
%   zoompercent - vector which gives the percentage zoom for each
%          successive iteration of the pixel selection.  The vector values
%          must be decreasing with increasing index and must all lie within
%          the range (0 100]. 
%
% function pts = Select_im_pts(im,Npts,zoompercent)
% ------------------------------------------------------------------------
function pts = Select_im_pts(im,Npts,zoom)

if nargin < 3;  zoom = 100; end
if nargin < 2;  Npts = 1;          end

fg = figure('name','Select_im_pts');
Size_fig(2,2);

dd = size(im);
Nr = dd(1);
Nc = dd(2);

%disp(['* Select ' num2str(Npts) ' points in the image using zoom = ' num2str(zoompercent)])
pt0 = round([Nc Nr]/2);
pts = zeros(Npts,2);
for k0 = 1:Npts
  for k1 = 1:length(zoom)
    dr = round(zoom(k1)*Nr/100);
    dc = round(zoom(k1)*Nc/100);

    row0 = pt0(2)-dr; row0 = max(1, row0);
    row1 = pt0(2)+dr; row1 = min(Nr,row1);
    col0 = pt0(1)-dc; col0 = max(1, col0);
    col1 = pt0(1)+dc; col1 = min(Nc,col1);

% If im is a color image, then display normally
		if length(dd) > 2
      imshow(im(row0:row1,col0:col1,:),'InitialMagnification','fit');
		else
% If im is a grayscale image, then show its full dynamic range
      Imin = min(min(im(row0:row1,col0:col1)));
      Imax = max(max(im(row0:row1,col0:col1)));
      imshow(im(row0:row1,col0:col1),[Imin Imax],'InitialMagnification','fit');
		end
    drawnow;

    disp(['  Zoom: ' num2str(zoom(k1)) ' Enter point... '])
    pts(k0,:) = round(ginput(1));
    pts(k0,2) = pts(k0,2) + row0 - 1;
    pts(k0,1) = pts(k0,1) + col0 - 1;
    pt0 = pts(k0,:);
  end
end

% Put pts in (row,col) form
pts = [pts(:,2) pts(:,1)];
pts = pts';

close(fg)

end

%-------------------------------------------------------------
% Created: 1/18/14  by William J. Ebel (All Rights Reserved)
%
% Revision History:  None
%
% Purpose:  Scale the figure window relative to its current size.  If the
%   arguments are both 1, then the figure is not changed in size.  If the
%   arguments are (2,1), then the width of the figure window is doubled and
%   the height is unchanged, with the new window centered at the same
%   position as the old window.  This function always keeps the top of the 
%   window at the same height on the screen.  
%
% Variables: 
%    Sx - Scale in the horizontal screen direction
%    Sy - Scale in the vertical screen direction
%    pos   - 4 component vector defining the new window position in units
%            of screent pixels: 
%            pos(1) = pixels to the right of the screen left-hand-side
%            pos(2) = pixels above the bottom of the screen
%            pos(3) = figure window width in pixels
%            pos(4) = figure window height in pixels
%
% function pos = Size_fig(Sx,Sy)
%-------------------------------------------------------------
function pos = Size_fig(Sx,Sy)

% Get the current figure window position
pos = get(gcf,'Position');

width  = Sx*pos(3);
height = Sy*pos(4);
bottom = round(pos(2) - (height-pos(4)));
left   = round(pos(1) - (width-pos(3))/2);

pos = [left bottom width height];
set(gcf,'Position',pos);

end
