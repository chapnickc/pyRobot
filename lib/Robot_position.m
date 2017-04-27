function [x y alpha dilated results] = Robot_position(img);
%%
    x = []; y= []; alpha = []; dilated= [];
    results = struct();

    neighborhood = [2 2]; 
    sigma = 2; pxthresh=200; 
    startpoint = [34,350]; endpoint = [510, 83];
    M = load('FloorXform.mat');
    M = M.M;
    [~,~,~,~, labeled] = algorithm(img, neighborhood, sigma, pxthresh);
    
    % classify the centroids of all found objects 
    centerStruct = regionprops(labeled, 'Centroid'); 
    [color_labels, centers] = classifyPoints(img, centerStruct);

    % find the coordinates and indicies of each color in the labels array
    [pink_coords, pinkix] = findColor(centerStruct, color_labels, 'pink');
    [green_coords, greenix] = findColor(centerStruct, color_labels,'green');
    [blue_coords, blueix] = findColor(centerStruct, color_labels,'blue');

    if length(pinkix) >= 1 && length(greenix) >= 1
        front = green_coords(1:2);
        back = pink_coords(1:2);
        robotix = (front + back)/2;
        front_xy = rc2xy(M, front')';
        back_xy = rc2xy(M, back')';
        x = (front_xy(1) + back_xy(1))/2;
        y = (front_xy(2) + back_xy(2))/2;
        alpha = findAngle(front, back);
    else
        turnRobot(45,'right');
    end
    % path planning
    [dilated, mask] = dilateObjects(img,labeled, blueix);
%%
    results.img = img;
    results.x = x;
    results.y = y;
    results.frontix = front;
    results.backix = back;
    results.front_xy = front_xy;
    results.back_xy = back_xy;
    results.robotix = robotix;
end


