

addpath('./')
addpath('./lib')
addpath('./lib/ebel')

% Read sample images 
impaths = glob('./images/edges_*.png');
imgs = {};
for i = 1:length(impaths)
    disp(['Reading image ', num2str(i)])
    imgs{i} = imread(impaths{i});
end


% ----------------------------
camlist = webcamlist;
cam = webcam(2);
preview(cam)

neighborhood = [2 2]; sigma = 2; pxthresh=200;


tic
while (1) % main loop
    %img = snapshot(cam);
    img = imgs{32};
    imshow(img)

    
    [denoised edges filled cleaned labels] = algorithm(img, neighborhood, sigma, pxthresh);
    [~,~,~,~, labeled] = algorithm(img, neighborhood, sigma, pxthresh);
    
    % classify the centroids of all found objects 
    centerStruct = regionprops(labeled, 'Centroid'); 
    [color_labels,centers] = classifyPoints(img, centerStruct);

    % find the coordinates and indicies of each color in the labels array
    [pink_coords, pinkix] = findColor(centerStruct, color_labels, 'pink');
    [green_coords, greenix] = findColor(centerStruct, color_labels,'green');
    [blue_coords, blueix] = findColor(centerStruct, color_labels,'blue');

    % make sure there's only 1-pink and 1-green
    if length(pinkix) ~= 1 || length(greenix) ~= 1
        RESAMPLE=true; disp('Resample!')
    end

    angle = findAngle(pink_coords, green_coords);

    % Path Planning
    [dilated, mask] = dilateObjects(img,labeled, blueix);



end




