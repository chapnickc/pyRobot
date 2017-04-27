% extract the coordinates and 
% find the indicies of each  color in the labels array
function [coordinates, ixs]= findColor(centers,labels, name)

coordinates = []; ixs = []; 

try
    ixs = find(contains(labels, name));
    coordinates = centers(ixs).Centroid;
catch err
    if strcmp(err.identifier, 'MATLAB:needMoreRhsOutputs')
        disp([name, ' not found'])
    else
        disp(err.identifier)
        rethrow(err);
    end
end

