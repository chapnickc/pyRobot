% ------------------------------------------------------------------------------ % created: 10/4/16 by tommy schulte, matt boss, claire stonner, chad chapnick
% revision history: none
% 
% purpose: 
%
% input variables: 
%   window      := define median filtering window size
%   sigma       := canny edge filtering sigma value
%   pxthresh    := the threshold for binary filling
%
% output variables:
%   [denoised ,edges filled, cleaned, labels]
% ------------------------------------------------------------------------------
function [denoised ,edges filled, cleaned, labels] = algorithm(img, window, sigma, pxthresh)
    imgray = rgb2gray(img);
    denoised = medfilt2(imgray, window,'symmetric');
    edges = edge(denoised,'Canny',[],sigma); 
    filled = imfill(edges,'holes'); 
    cleaned = bwareaopen(filled, pxthresh);
    labels = bwlabel(cleaned);
end
