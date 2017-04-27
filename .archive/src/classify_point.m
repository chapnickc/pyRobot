% ------------------------------------------------------------------------------ % Created: 10/4/16 by Tommy Schulte, Matt Boss, Claire Stonner, Chad Chapnick
% 
% Revision History: None
% 
% Purpose: The purpose of this function is used to classify the color of an rgb triplet
%
% Input Variables: 
%   rgb := a row vector containing uint8 red, green and blue values, respectively.
%
% Output Variables:
%   color := one of 'noise', 'pink', 'green', or 'blue'
%
% ------------------------------------------------------------------------------
function color = classify_point(rgb)
    % decision points for four nodes on tree
    p1_gb = [127.66,160.17]; p2_gb= [132.66,161.61]; % green vs blue decision
    p1_rb = [107.88,221.91]; p2_rb= [142.56, 149.73]; % red vs blue decision
    p1_rg = [126.83, 174.22]; p2_rg= [230.87, 129.84]; % red vs green decision

    % compare the energies
    [ix1 dmin1] = nearest_neighbor(double(rgb(1,[2,3])),  [p1_gb; p2_gb]); % blue,green,pink | noise
    [ix2 dmin1] = nearest_neighbor(double(rgb(1,[1,3])),  [p1_rb; p2_rb]); % blue | green,pink 
    [ix3 dmin1] = nearest_neighbor(double(rgb(1,[1,2])),  [p1_rg; p2_rg]); % pink | green 

    % Traverse the decision tree
    if ix1 == 1 % then split blue, pink and green
        if ix2 == 1
            color = 'blue';
            return 
        end

        if ix3 == 1
            color = 'green';
            return
        else
            color = 'pink';
            return 
        end
    elseif ix1 == 2 
        color = 'noise';
    end
end
