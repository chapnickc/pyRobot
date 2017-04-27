% ------------------------------------------------------------------------------ % created: 10/4/16 by tommy schulte, matt boss, claire stonner, chad chapnick
% revision history: none
% 
% purpose: 
%   read a regular expression of images into cell array
%
% input variables: 
%   window      := define median filtering window size
%   sigma       := canny edge filtering sigma value
%   pxthresh    := the threshold for binary filling
%
% output variables:
%   img
% ------------------------------------------------------------------------------
%addpath('./lib')
function imgs = readimgs(impaths)
    N = length(impaths);
    disp(['Found  ', num2str(N), ' images'])
    imgs = {};
    for i = 1:length(N)
        imgs{i} = imread(impaths{i});
    end
end
