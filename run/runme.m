run add_paths

camlist = webcamlist;
cam = webcam(2); 
preview(cam)

serial_start()

timer=60; tic
while abs(toc) < timer
    %img = cam.snapshot;
    %imgs = myimread('../images/edges_*.png');
    %imgs = myimread('../train/images/edges_*.png');
    %img = imgs{11}; imshow(img)

    [x, y, alpha, dilated, results] =  Robot_position(img);
    [optimal_path, ixpath] = findPath(dilated, results.robotix);

    target_alpha=[];
    for i=1:5:length(optimal_path)-5
        x = optimal_path(i+5,:) - optimal_path(i,:);
        theta = rad2deg(atan(x(2)/x(1)));
        target_alpha=[target_alpha; theta];
    end


    diff = alpha - target_alpha(1);
    step=int16(33);
    iters = idivide(diff,step)
    for i = 1:iters
        if diff > 0
            turnRobot(diff, 'right')
        elseif diff < 0
            turnRobot(diff, 'left')
        end
    end



    subplot(1,2,1); imagesc(img);
    subplot(1,2,2); imagesc(dilated);hold on
    subplot(1,2,1); imagesc(img);
    subplot(1,2,2); imagesc(dilated);hold on
    plot(results.frontix(1), results.frontix(2),  'r.', 'MarkerSize', 20)
    plot(results.backix(1), results.backix(2),  'r.', 'MarkerSize', 20)
    plot(results.robotix(1), results.robotix(2),'g.','MarkerSize',20);
    plot(ixpath(:,2), ixpath(:,1), 'r.')
    plot(results.frontix(1), results.frontix(2),  'r.', 'MarkerSize', 20)
    plot(results.backix(1), results.backix(2),  'r.', 'MarkerSize', 20)
    plot(results.robotix(1), results.robotix(2),'g.','MarkerSize',20);
    plot(ixpath(:,2), ixpath(:,1), 'r.')
end


   wt = 0.25;
   % Left 10 degrees
    speed_set(.25, -.25);
    pause(wt);
    speed_set(0,0);


   % right 10 degrees
    speed_set(-.31, .25);
    pause(0.25);
    speed_set(0,0);



    wt = 90*(0.625/45)

    speed_set(0,0);

    speed_set(0.25, 0.289);


