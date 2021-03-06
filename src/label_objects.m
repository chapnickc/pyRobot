
% include '.m' files
addpath('./')
addpath('./lib')
ls

% Read sample images 
impaths = glob('../images/samples/img_*.png');
N = length(impaths);
disp(['Found  ', num2str(N), ' images'])
imgs = {};
for i = 1:length(N)
    imgs{i} = imread(impaths{i});
end


size(imgs)
imgs = readimgs(impaths);

size(imgs)
size(imgs{1})


img = imgs{8};
imshow(img)

[denoised edges filled cleaned labels]=algorithm(img, window, sigma, pxthresh);

imshow(denoised)
imshow(edges)
imshow(filled)


imgray = rgb2gray(img);
imagesc(imgray); colormap jet

figure(2)
imshow(filled)


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

save('labeled_rgb.mat', 'labeled_rgb')

%{imshow(img);            % plot the RGB image%}
%colors = {};
%for row =1:size(RGB,1)
    %colors{row} = classify_point(RGB(row,:));
    %disp([num2str(row), '  ' colors{row}])
%end




