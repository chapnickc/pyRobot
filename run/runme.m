addpath('./')
addpath('./lib')
addpath('./lib/ebel')
load FloorXform

RESAMPLE=false;
neighborhood = [2 2]; sigma = 2; pxthresh=200;
startpoint = [34,350]; endpoint = [510, 83];

% Initialize Webcam Interface
%camlist = webcamlist;
%cam = webcam(2); preview(cam)

% Main Loop
timer=60; tic
while abs(toc - x) < timer
    %img = cam.snapshot;
    [~,~,~,~, labeled] = algorithm(img, neighborhood, sigma, pxthresh);
    
    % classify the centroids of all found objects 
    centerStruct = regionprops(labeled, 'Centroid'); 
    [color_labels, centers] = classifyPoints(img, centerStruct);

    % find the coordinates and indicies of each color in the labels array
   
    [pink_coords, pinkix] = findColor(centerStruct, color_labels, 'pink');
    [green_coords, greenix] = findColor(centerStruct, color_labels,'green');
    [blue_coords, blueix] = findColor(centerStruct, color_labels,'blue');
    robotloc = (pink_coords + green_coords)/2;

    % make sure there's only 1-pink and 1-green
    if length(pinkix) < 1 || length(greenix) < 1
        resample=true; disp('resample!')
    end
    %imshow(img), imagesc(labeled)
    front = pink_coords(1:2);
    back = green_coords(1:2);
    angle = findAngle(front,back); 
    disp(['angle is: ', num2str(angle)])

    % path planning
    [dilated, mask] = dilateObjects(img,labeled, blueix);
end






%-----------------------------------------------------------
%           Test Code
%-----------------------------------------------------------

% Read sample images 
imgs = myimread('./images/edges_*.png');
img = imgs{10};



imshow(img)
img = imgs{32}; imshow(img)


[denoised edges filled cleaned labeled] = algorithm(img, neighborhood, sigma, pxthresh);
figure; 
subplot(2,2,1), imshow(edges); 
subplot(2,2,2), imshow(filled) 
subplot(2,2,3), imshow(cleaned) 
subplot(2,2,4), imagesc(labeled)


l = 1; label_vec = pinkix;
maxarea = sum(sum(labeled == label_vec(1)));
for i = 2:length(pinkix)
    total =  sum(sum(labeled == pinkix(i)));
    if total > maxarea
        maxarea = total;
        l = i; % update label
    end
end

Z = labeled == pinkix(l);
imshow(Z)





% Read sample images 
imgs = myimread('./images/edges_*.png');
img = imgs{10};

imshow(dilated); hold on 
