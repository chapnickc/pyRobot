%--------------------------------------------------------------------------
% Created: 2/4/14    by William J. Ebel (All Rights Reserved)
%
% Revision History:  
%         Date                Reason
%       2/5/2014    Eliminated the loop to make this run faster
%
% Purpose:  This script uses an affine transformation matrix to convert
%   from floor coordinates to pixel coordinates.  The affine transformation
%   matrix converts from (r,c) coordinates to (x,y) coordinates.  Therefore
%   it needs to be inversed in this function (division on the left). 
% 
% Variables:
%   M  - Transformation matrix from pixel to floor coordinates
%   xy - 2xN matrix where each column is an (x,y) floor coordinate value
%
%   rc - 2xN matrix where each column is an (r,c) pixel coordinate
%
% function rc = xy2rc(M,xy)
%--------------------------------------------------------------------------
function rc = xy2rc(M,xy)

D = size(xy);
xy = [xy; ones(1,D(2))];   % Convert the rc points to HC form
p = (M')\xy;               % Transform the HC points from xy to rc
p(1,:) = p(1,:)./p(3,:);   % Normalize the r component
p(2,:) = p(2,:)./p(3,:);   % Normalize the c component
rc = p(1:2,:);             % Create the output matrix

end