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
function predicted = classify_rgb(rgb,ix)
    predicted = [];
    if size(rgb,2) < 3; return; end
    if nargin < 2; ix=1; end
    load('./trained-SVMModels.mat')
    classes={'noise','blue','green','pink'};
    
    if predict(models{ix}, rgb) == 1
        predicted = classes{ix}; 
    elseif ix < length(classes)
        ix = ix +1;
        predicted=classify_rgb(rgb,ix);
    end



end
