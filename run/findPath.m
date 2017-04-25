function [optimal_path pixelpath]= findPath(dilated, robotloc)
    startpoint = [34,350]; endpoint = [510, 83];
    M = load('FloorXform.mat');
    M = M.M;

    connecting_distance = 8; 
    GoalRegister = int8(zeros(size(dilated)));
    GoalRegister(endpoint(2), endpoint(1)) = 1;
    optimal_path = pathAStar(round(robotloc(1)), round(robotloc(2)), dilated, GoalRegister, connecting_distance);
    pixelpath = optimal_path;
    optimal_path = rc2xy(M, pixelpath')';
end
