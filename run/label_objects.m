% include '.m' files
addpath('./')
addpath('./lib')

% Read sample images 
imgs = {};
impaths = glob('../images/newmask/justmask_*.png');
for i = 1:length(impaths)
    disp(['Reading image ', num2str(i)])
    imgs{i} = imread(impaths{i});
end


% define median filtering window size, 
% canny edge filtering sigma value, and 
% the threshold for binary filling
window = [4 4]; sigma = 1.5; pxthresh=300;
labeled_rgb = {}
for i = 1:length(imgs)

    img = imgs{i};

    [denoised edges filled cleaned labels]=algorithm(imgs{i}, window, sigma, pxthresh);

    disp(['showing image ', num2str(i)]);
    imshow(imgs{i}); hold on 

    % get rgb values for each label and store in matrix
    s = regionprops(labels, 'Centroid'); 
    RGB = zeros(size(s,1), 4);  % red | green | blue | actual label 
    for label=1:numel(s)
        c = s(label).Centroid;      
        plot(c(1),c(2), 'r.', 'MarkerSize', 45)
        text(c(1), c(2), sprintf('%d', label), 'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'middle', 'FontSize', 12, 'Color', 'white');
        coordinates = s(label).Centroid;
        c = round(coordinates);
        rgb = img(c(2),c(1),:);
        RGB(label,1:3) = reshape(rgb,1,3);
    end
    hold off;

    for label=1:numel(s)
        prompt = ['Please enter the correct color for label ',num2str(label),':\n',...
        '0 = noise | 1 = blue | 2 = green | 3 = pink\n'];
        color = input(prompt);
        RGB(label,4) = color;
    end
    labeled_rgb{i} = RGB;
end


save('labeled_rgb.mat', 'labeled_rgb') % save the RGB 

