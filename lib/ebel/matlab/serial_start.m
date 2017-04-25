%--------------------------------------------------------------------------
% Author: William J. Ebel & Kyle Mitchell
% Created: 1/13/2017
% Revision History: none
%
% Purpose: This script creates an object that is connected to the serial
%   port for the purpose of sending commands to, and receiving commands
%   from, the arduino.  The commands to send data to the arduino set the
%   motor speeds only.  The commands to receive data from the arduino
%   capture sensor data.
%
%   The primary interface for the variables that carry the important
%   information are shared with other functions using global variables.  In
%   this way, they are passed in background and do not need to be
%   explicitly passed through the argument list of a function.  
%
%--------------------------------------------------------------------------
%close all
%clear all
%clear all
instrreset

global index
global mot1
global mot2
global sen1
global sen2
global sen3
global sen4
global sen5
global dist1
global obj

serialInfo = instrhwinfo('serial');

port = [];
%port = 'COM6';   % Once you know the correct COM port, hardcode it here
if isempty(port)
  if length(serialInfo.AvailableSerialPorts) > 1
    disp('You have more than one Serial Port.');
    disp('Avaliable Ports are:');
    for kk = 1:length(serialInfo.AvailableSerialPorts)
        disp(serialInfo.AvailableSerialPorts{kk});
    end
    port = serialInfo.AvailableSerialPorts{end};
    disp(['The last one, ' port ', is selected by default.']);
  else
    port = serialInfo.AvailableSerialPorts{1};
  end
end

obj = serial(port, 'BaudRate', 115200);
obj.BytesAvailableFcnCount = 2;
obj.BytesAvailableFcnMode = 'byte';
obj.BytesAvailableFcn = {@serialCallBack};

%fopen to the USB cord will cause the Arduino to reboot
fopen(obj);



