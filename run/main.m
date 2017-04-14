% include '.m' files
addpath('./')
addpath('./lib')

% Read sample images 
impaths = glob('./images/edges_*.png');
imgs = {};
for i = 1:length(impaths)
    disp(['Reading image ', num2str(i)])
    imgs{i} = imread(impaths{i});
end

img = imgs{5};
imshow(img)

% define median filtering window size, 
% canny edge filtering sigma value, and 
% the threshold for binary filling
window = [2 2]; sigma = 2; pxthresh=200;
[denoised edges filled cleaned labels]=algorithm(img, window, sigma, pxthresh);
imshow(edges)
imshow(filled)
imshow(cleaned)


%----------------
%   Plotting
%----------------
num_labels = max(max(labels));
imshow(img); imshow(denoised);
imshow(edges); imshow(filled); imshow(cleaned);
imagesc(labels); colormap(jet(num_labels))


%imwrite(img,'../images/present/rgb_input.png') %imwrite(denoised,'../images/present/denoised.png') %imwrite(edges,'../images/present/edges.png') %imwrite(filled,'../images/present/filled.png') %imwrite(cleaned,'../images/present/cleaned.png') %imwrite(labels,'../images/present/labeles.png') 

% get rgb values for each label and store in matrix
s = regionprops(labels, 'Centroid'); 
RGB = zeros(size(s,1), 3);
for label=1:numel(s)
    coordinates = s(label).Centroid;
    c = round(coordinates);
    % if c(2) < b_left_corner_x and c(1) < b_left_corner_y
    %   ignore the point
    % if c(2) > t_left_corner_x and c(1) > t_left_corner_y
    %   ignore the point
    % if c(2) > t_right_corner_x and c(1) > t_right_corner_y
    %   ignore the point
     % if c(2) > b_right_corner_x and c(1) > b_right_corner_y
    %   ignore the point
    % else
    rgb = img(c(2),c(1),:);
    RGB(label,:) = reshape(rgb,1,3);
    % end
end

colors = {};
for row =1:size(RGB,1)
    colors{row} = classify_point(RGB(row,:));
    disp([num2str(row), '  ' colors{row}])
end



% --------------------------------------------
%   Plot objects and labels
% --------------------------------------------
figure(1)
s = regionprops(labels, 'Centroid'); 
imshow(img)
hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    plot(c(1),c(2), 'r.', 'MarkerSize', 45)
    text(c(1), c(2), sprintf('%d', k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'FontSize', 12, 'Color', 'white');
end
hold off

front = s(find(contains(colors, 'pink'))).Centroid;
back = s(find(contains(colors, 'green'))).Centroid;

front, back

imshow(img)

zoom = [100 10];
M = Find_xform(img,zoom);


front_xy, back_xy 
front_xy = rc2xy(M,front');
back_xy = rc2xy(M,back');

calculatePose(front,back)
calculatePose(front_xy,back_xy)
