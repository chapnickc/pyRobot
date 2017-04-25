% ------------------------------------------------------------------------------ % Created: 10/4/16 by Tommy Schulte, Matt Boss, Claire Stonner, Chad Chapnick
% Revision History: None
% 
% Purpose: 
%
% Input Variables: 
%   window      := define median filtering window size
%   sigma       := canny edge filtering sigma value
%   pxthresh    := the threshold for binary filling
%
% Output Variables:
%   [denoised ,edges filled, cleaned, labels]
% ------------------------------------------------------------------------------
function [denoised ,edges filled, cleaned, labels] = algorithm(img, neighborhood, sigma, pxthresh)
    imgray = rgb2gray(img);
    denoised = medfilt2(imgray, neighborhood,'symmetric');
    edges = edge(denoised,'Canny',[],sigma); 
    filled = imfill(edges,'holes'); 
    cleaned = bwareaopen(filled, pxthresh);
    labels = bwlabel(cleaned);
end
