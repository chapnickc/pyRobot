%--------------------------------------------------------------------------
% Author: William J. Ebel
% Created: 2/3/2017
% Revision History: none
%
% Purpose: This function determines if the serial port is actually running
%   or not.  It does so by checking the time index to see if it is
%   changing.  The wireless link appears to update via matlab at a rate of
%   about 10Hz.  Therefore, this function reads the time now index value
%   and waits 0.2 seconds and checks it again.  It should change within
%   this time.  
%
%   WARNING!  This function will consume at least 0.2 seconds of time and
%   is not good to use inside a control loop.  
%   
% Variables:
%   runflg : 1 = serial port is running, 0 = not running
%
% function runflg = serial_isrunning()
%--------------------------------------------------------------------------
function runflg = serial_isrunning()

runflg = false;

%-----------------------
% Make sure the serial port is operating
[tnow0,~,~,~] = sensor_acquire();
pause(0.2)
[tnow1,~,~,~] = sensor_acquire();

if isnan(tnow0) || isnan(tnow1)
  return;
end
if tnow0 == tnow1
  return;
end

runflg = true;

end