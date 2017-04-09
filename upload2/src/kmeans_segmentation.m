
% read in the basic field picture
img = imread('./images/im.png');imshow(img)

% read in the field picture with obstacles
img = imread('./images/imobstacle.png');imshow(img)

% increase the saturation
hsv = rgb2hsv(img);
hsv(:, :, 2) = hsv(:, :, 2) * 2; % 100% more saturation
img = hsv2rgb(hsv);

% apply a three dimensional gaussian filter
img = imgaussfilt3(img);
% imshow(img)

cform = makecform('srgb2lab');
imgLAB= applycform(img, cform);
ab = double(imgLAB(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);

% each row contains the pixel values from the a* and b* layers
ab = reshape(ab,nrows*ncols,2);
ab(1:5,:)

% repeat the clustering 3 times to avoid local minima
nColors = 10 ;
tic;  [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',3); toc



%{ 4. Label Every Pixel in the Image Using the Results from KMEANS %}
% place the pixel labels (ie. 1, 2, or 3 here) 
% in the correct place in the image
pixel_labels = reshape(cluster_idx,nrows,ncols);



% note the [] parameter scales the 
% colors used in the grayscale image 
% to the range of pixel values in 'pixel_labels'
imshow(pixel_labels, []);
colormap(flipud(jet(nColors)))
colorbar


% use the pixel labels to 'white-out' pixels in the 
% original rgb image which 
% do not belong to a given cluster.
segmented_images = cell(1,nColors);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = img;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end


imshow(img)
imshow(segmented_images{1}), title('Floor')
%save('./images/imobst_floor_ncolor2.png')

imshow(segmented_images{2}), title('Obstacle')
%save('./images/imobst_obst_ncolor2.png')


imshow(segmented_images{2})
title('BLUE')
%save('./images/imobst_blue_seg_ncolors4.png')

obst = segmented_images{2};
imshow(obst); 

obst




%------------------

clf
dim = [nColors/5,5]
subplot(dim(1),dim(2),1); imshow(img)
for k=2:dim(1)*dim(2)
    subplot(dim(1),dim(2),k); imshow(segmented_images{k-1}), title(['objects in cluster ',num2str(k-1)])
    axis image; axis off; %set(s1,'position',[-0.3 .65 0.9 0.3])
end



% ------------------------------------

img = imread('./images/im.png');
cform = makecform('srgb2lab');

h = fspecial('gaussian');
imgLAB = applycform(img, cform);
imgLAB(:,:,3) = filter2(h,imgLAB(:,:,3));
img = lab2rgb(double(imgLAB));
imshow(img)


img = imread('./images/im.png');
imshow(img)


imtool(img)

addpath('.')

img = imread('./images/im.png');
I = img;
level = graythresh(I);
BW = im2bw(I,level);
imshow(BW)

I = rgb2gray(img);
mask = false(size(I));
mask(100,100) = true;

W = graydiffweight(I, mask, 'GrayDifferenceCutoff', 15);
thresh = 0.5;
[BW, D] = imsegfmm(W, mask, thresh);

subplot(2,1,1)
imshow(img)
subplot(2,1,2)
imshow(BW); title('Segmented Image')


img = medfilt3(img);
imshow(img)


hsv = rgb2hsv(img);
hsv(:, :, 2) = hsv(:, :, 2) * 2; % 100% more saturation
img = hsv2rgb(hsv);
imgLAB = rgb2lab(img);

%h = fspecial('gaussian');
%imgLAB(:,:,1) = filter2(h, imgLAB(:,:,1));
img = lab2rgb(imgLAB);
imshow(img)




