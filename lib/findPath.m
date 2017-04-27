function [optimal_path pixelpath]= findPath(dilated, robotloc)
    startpoint = [34,350]; endpoint = [510, 83];
    M = load('FloorXform.mat');
    M = M.M;

    
    y = dilated(:,:,1);
    %y(:,1:startpoint(1)) = 1;
    %y(startpoint(2):480,:) = 1;
    %y(:,endpoint(1):end) = 1;
    %y(1:endpoint(2),:) = 1;

    connecting_distance = 4; 
    GoalRegister = int8(zeros(size(y)));
    GoalRegister(endpoint(2), endpoint(1)) = 1;
    optimal_path = pathAStar(round(robotloc(1)), round(robotloc(2)), y, GoalRegister, connecting_distance);
    pixelpath = optimal_path;
    optimal_path = rc2xy(M, pixelpath')';

end
