%--------------------------------------------------------------------------
% Author: William J. Ebel & Kyle Mitchell
% Created: 1/13/2017
% Revision History: none
%
% Purpose: This function converts motor speed parameters, both left and
%   right, and converts them in format and then sends them down the serial
%   port to the arduino processor.  The arduino processor monitors the
%   serial port and expects data to be passed to it in a way that is
%   synchronized to this function.  
%
% Variables:
%   SL  = LEFT motor speed, range [-1,1]
%   SR  = RIGHT motor speed, range [-1,1]
%
% function speed_set(SL, SR)
%--------------------------------------------------------------------------
function speed_set(SL, SR)

global obj

if (SL > 1) || (SL < -1)
  SL = sign(SL); 
  disp('*** WARNING in speed_set.  The LEFT motor speed is out of bounds');
  disp('   ... clipping and continuing');
end
if (SR > 1) || (SR < -1)
  SR = sign(SR); 
  disp('*** WARNING in speed_set.  The RIGHT motor speed is out of bounds');
  disp('   ... clipping and continuing');
end

% Convert from a fraction to integer scale
SL = round(SL*127);
SR = round(SR*127);

SL = -SL;  % need to reverse the numbers (or turn around motor driver plug)
SR = -SR;  % need to reverse the numbers (or turn around motor driver plug)

% Clip the speed
if SL >  127;  SL =  127;  end
if SR >  127;  SR =  127;  end
if SL < -127;  SL = -127;  end
if SR < -127;  SR = -127;  end

if SL <    0;  SL = 256+SL;  end
if SR <    0;  SR = 256+SR;  end

% Create the serial port command string and send it across the serial port
command = [char(hex2dec('55')), char(SR), char(SL), char(hex2dec('AA'))];
fwrite(obj, command);

end
