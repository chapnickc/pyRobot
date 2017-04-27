function turnRobot(angle, dir)
    iters = idivide(angle, int8(30));
    if dir == 'left'
        for i = 1:iters 
            % Left 30 degrees
            speed_set(.25, -.25);
            pause(wt);
            speed_set(0,0);
        end
    elseif dir == 'right'
        for i = 1:iters 
           % right 30 degrees
            speed_set(-.31, .25);
            pause(0.25);
            speed_set(0,0);
        end
    end

end
