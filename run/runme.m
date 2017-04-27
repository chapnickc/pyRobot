cd C:\Users\chapnickc\Desktop\juniorDesign\run
run add_paths

%%
camlist = webcamlist;
cam = webcam(2); 
preview(cam)
%%

serial_start()

%% 
timer = 180; tic
while abs(toc) < timer
    img = cam.snapshot;
    [x, y, alpha, dilated, results] =  Robot_position(img);
    disp('Calculating Path...')
    [optimal_path, ixpath] = findPath(dilated, results.robotix);

    plot_results(img, dilated, results, ixpath)

    target_alpha=[];
    for i=1:5:length(ixpath)-5
        dy = -(ixpath(i+5,2)- ixpath(i,2));
        dx = ixpath(i+5,1)- ixpath(i,1);
        alpha_i = atan2d(dx, dy);
        target_alpha = [target_alpha; alpha_i];
    end

    diff = alpha - target_alpha(1);
    disp(['Robot Angle: ',num2str(alpha)]);
    disp(['Diff = ', num2str(diff)])

    if diff > 0
        turnRobot(abs(diff), 'right')
    elseif diff < 0
        turnRobot(abs(diff), 'left')
    end
    
    moveStraight(1.0)
  
end

