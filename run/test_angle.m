addpath('./')
addpath('../')
addpath('../lib')
addpath('../lib/ebel')
addpath('../lib/ebel/matlab/')
addpath('../lib/ebel/Robot_embedded_controller/')

serial_stop()

serial_start()


% Left 45 degrees
speed_set(.25, -.25);
pause(.7);
speed_set(0,0);


