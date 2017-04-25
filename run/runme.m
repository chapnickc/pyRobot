addpath('./')
addpath('../')
addpath('../lib')
addpath('../lib/ebel')
addpath('../lib/ebel/matlab/')
addpath('../lib/ebel/matlab/')

RESAMPLE=false; FINDROBOT=true;

serial_start()

% Initialize Webcam Interface
%camlist = webcamlist;
%cam = webcam(2); preview(cam)

% Main Loop
timer=60; tic
while abs(toc) < timer
    %img = cam.snapshot;

    [x, y, alpha, dilated, robotloc] =  Robot_position(img);
    [optimal_path, pixelpath] = findPath(dilated, robotloc);


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


end
