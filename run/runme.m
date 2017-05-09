%cd('C:\Users\chapnickc\Desktop\juniorDesign\run')
run add_paths

camlist = webcamlist;
cam = webcam(2); 
preview(cam)

serial_start()

timer = 180; tic
while abs(toc) < timer
    img = cam.snapshot;
    
    disp('Finding the Robot...')
    [x, y, alpha, dilated, results] =  Robot_position(img);

    disp('Calculating Path...'); tic
    [optimal_path, ixpath] = findPath(dilated, results.robotix);
    toc

    plot_results(img, dilated, results, ixpath)

    [diff, target] = getAngleCorrection(alpha, ixpath);
    s=sprintf('\tRobot Angle: %f\tTarget: %f\n\tDiffernce: %f', alpha,target,diff);
    disp(s);
    disp(sprintf('', diff));

    correction = abs(diff)
    if diff > 0
        disp('Turning Right')
        turnRobot(correction, 'right')
    elseif diff < 0
        disp('Turning Left')
        turnRobot(correction, 'left')
    end
    moveStraight(1.0)

end

xy1 = [258, 236];
xy2 = [248, 256];
findAngle(xy1, xy2)

