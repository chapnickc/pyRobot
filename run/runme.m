addpath('./')
addpath('./lib')
addpath('./lib/ebel')
load FloorXform

RESAMPLE=false;
FINDROBOT=true;
neighborhood = [2 2]; sigma = 2; pxthresh=200;
startpoint = [34,350]; endpoint = [510, 83];

% Initialize Webcam Interface
%camlist = webcamlist;
%cam = webcam(2); preview(cam)

% Main Loop
timer=60; tic
while abs(toc) < timer
    %img = cam.snapshot;
    [~,~,~,~, labeled] = algorithm(img, neighborhood, sigma, pxthresh);
    
    % classify the centroids of all found objects 
    centerStruct = regionprops(labeled, 'Centroid'); 
    [color_labels, centers] = classifyPoints(img, centerStruct);

    % find the coordinates and indicies of each color in the labels array
    [pink_coords, pinkix] = findColor(centerStruct, color_labels, 'pink');
    [green_coords, greenix] = findColor(centerStruct, color_labels,'green');
    [blue_coords, blueix] = findColor(centerStruct, color_labels,'blue');

    if length(pinkix) >= 1 || length(greenix) >= 1
        robotloc = (pink_coords + green_coords)/2;
%{        % make sure there's only 1-pink and 1-green%}
        %if length(pinkix) < 1 || length(greenix) < 1
            %RESAMPLE=true; disp('resample!')
        %end%}
        FINDROBOT=false;
        front = pink_coords(1:2);
        back = green_coords(1:2);
        angle = findAngle(front,back); 
        disp(['angle is: ', num2str(angle)])
    else
        FINDROBOT=true;
    end


    % path planning
    [dilated, mask] = dilateObjects(img,labeled, blueix);

    connecting_distance=8; 
    GoalRegister=int8(zeros(size(dilated)));
    GoalRegister(endpoint(2), endpoint(1))=1;
    tic
    optimal_path = pathAStar(round(robotloc(1)), round(robotloc(2)), dilated, GoalRegister, connecting_distance);
    toc


end




%-----------------------------------------------------------
%           Test Code
%-----------------------------------------------------------

% Read sample images 
imgs = myimread('./images/edges_*.png');
img = imgs{7};

[denoised edges filled cleaned labeled] = algorithm(img, neighborhood, sigma, pxthresh);
imshow(img)


figure(1);
subplot(2,2,1); imagesc(img)
subplot(2,2,2); imagesc(cleaned)
subplot(2,2,3); imagesc(labeled)
subplot(2,2,4); imagesc(dilated); hold on;
p = plot(robotloc(1), robotloc(2), 'g.', ...
         endpoint(1), endpoint(2), 'c.');
p(1).MarkerSize = 15; p(2).MarkerSize = 15;
plot(optimal_path(:,2), optimal_path(:,1), 'r.')
hold off



p = plot(startpoint(1), startpoint(2), 'g.', ...
         endpoint(1), endpoint(2), 'c.');
p(1).MarkerSize = 15; p(2).MarkerSize = 15;
plot(optimal_path(:,2), optimal_path(:,1), 'r.')
hold off




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
