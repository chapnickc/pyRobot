%--------------------------------------------------------------------------
% Created: 1/27/14    by William J. Ebel (All Rights Reserved)
%
% Revision History:  
%         Date                Reason
%       2/5/2014    Eliminated the loop to make this run faster
%
% Purpose:  This script uses an affine transformation matrix to convert
%   from pixel coordinates to floor coordinates. 
% 
% Variables:
%   M  - Transformation matrix from pixel to floor coordinates
%   rc - 2xN matrix where each column is an (r,c) row/column value of a
%        pixel to convert 
%
%   xy - 2xN matrix where each column is an (x,y) coordinate values in
%        floor coordinates corresponding to the input matrix rc. 
%
% function xy = rc2xy(M,rc)
%--------------------------------------------------------------------------
function xy = rc2xy(M,rc)

D = size(rc);          
rc = [rc; ones(1,D(2))];   % Convert the rc points to HC form
p = M'*rc;                 % Transform the HC points from rc to xy
p(1,:) = p(1,:)./p(3,:);   % Normalize the x component
p(2,:) = p(2,:)./p(3,:);   % Normalize the y component
xy = p(1:2,:);             % Create the output matrix

end
