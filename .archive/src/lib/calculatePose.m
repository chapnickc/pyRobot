function [ pose ] = calculatePose( front, back )
    roboX =  (front(1) + back(1))/2;
    roboY = (front(2) + back(2))/2;
    theta = atan((front(2) - back(2))/(front(1) - back(1))) * (180/pi);
    pose = [roboX, roboY, theta]; 
end


