% ------------------------------------------------------------------------------
% 
% Created: 10/4/16 by Tommy Schulte, Matt Boss, Claire Stonner, Chad Chapnick
% Revision History: None
% 
% Purpose: The purpose of the function is to find the nearest point to the
% loaded point.
%
% Input Variables: 
%   m       :=  coordinate to be classified
%   decV    :=  a 2x2 matrix which specifies the coordinates 
%               of two points on different sides of a boundary.
%               one row defines a single point
%
% Output Variables:
%   indx    := group index of the closest point
%   dmin    := distance to the closest point 
%
% function [indx dmin] = Nearest_neighbor(m,decV)
% ------------------------------------------------------------------------------
function [indx dmin] = Nearest_neighbor(m,decV)
    indx = []; dmin = [];
    %chech the size of decV and m
    k = size(decV);
if  length(m)==2 && k(1)==2 && k(2)==2
    % extract coordinates of p1 and p2
    p1 = decV(1,:); 
    p2 = decV(2,:);
    % distance from point to p1 and p2
    d1 = sqrt(sum((p1 - m).^2));
    d2 = sqrt(sum((p2 - m).^2));
    %check which one is closer
    if (d1 < d2)
        indx = 1; dmin = d1;
    elseif (d2 < d1)
        indx = 2; dmin = d2;
    elseif (d2 == d1)
        disp('d1 == d2');
        return
    end
else
    return 
end

