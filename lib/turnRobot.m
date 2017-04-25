function turnRobot(angle)
    if ~any(angle == [-90, -45, 45, 90]
        return
    end

   % Left 45 degrees
    speed_set(.25, -.25);
    pause(.7);
    speed_set(0,0);


    % Left 90 degrees
    speed_set(.25,-.25);
    pause(1.3);
    speed_set(0,0);


    % Right 45 degrees
    speed_set(-.25,.25);
    pause(.7);
    speed_set(0,0);


    % Right 90 degrees
    speed_set(-.25,.25);
    pause(1.31);
    speed_set(0,0);

    
end
