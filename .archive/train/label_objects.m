% include '.m' files
addpath('./')
addpath('./lib')

% Read sample images 
imgs = myimread('./images/april17/edges_*.png');

% define median filtering window size, 
% canny edge filtering sigma value, and 
% the threshold for binary filling

labeled_rgb = {};
window = [2 2]; sigma = 2; pxthresh=200;
for i = 1:length(imgs)
    img = imgs{i};
    [denoised edges filled cleaned labels]=algorithm(img, window, sigma, pxthresh);
    disp(['showing image ', num2str(i)]);
    imshow(img); hold on 
    % get rgb values for each label and store in matrix
    s = regionprops(labels, 'Centroid'); 
    RGB = zeros(size(s,1), 4);  % red | green | blue | actual label 
    for label=1:numel(s)
        c = s(label).Centroid;      
        plot(c(1),c(2), 'r.', 'MarkerSize', 45);
        text(c(1), c(2), sprintf('%d', label), 'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', 'FontSize', 12, 'Color', 'white');
        coordinates = s(label).Centroid;
        c = round(coordinates);
        rgb = img(c(2),c(1),:);
        RGB(label,1:3) = reshape(rgb,1,3);
    end
    hold off;
    for row=1:length(s)
        prompt = ['Please enter the correct color for label ',num2str(row),':\n',...
        '0 = noise | 1 = blue | 2 = green | 3 = pink\n'];
        color = [];
        while ~isequal(length(color),1) || ~any([0,1,2,3] == color)
            color = input(prompt);
        end
        RGB(row,4) = color;    
    end
    labeled_rgb{i} = RGB;
end


% concatenate results
M = [];
for i = 1:length(labeled_rgb)
    start = size(M,1);
    m = labeled_rgb{i};
    for k = 1:size(m,1)
        M(start+k,:) =  m(k,:);
    end
end


save('april17-rgb-training.mat', 'M') % save the RGB 
%save('april17-labeled-rgb.mat', 'labeled_rgb') % save the RGB 
save('.april-17-rgb-training.mat', 'M') % save the RGB 
%save('.rgb-training.mat', 'M') % save the RGB 
% delete img 32
%save('labeled_rgb.mat', 'labeled_rgb') % save the RGB 
%save('labeled_rgb_round2.mat', 'labeled_rgb') % save the RGB 


