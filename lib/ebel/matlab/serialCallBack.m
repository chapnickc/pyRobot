%--------------------------------------------------------------------------
% Author: Kyle Mitchell
% Created: 1/13/2017
% Revision History: none
%
% Purpose: This function operates in the background and automatically
%   acquires data from the serial port.  The data acquired is packaged in a
%   way that is synchronized to the way the arduino code packages data that
%   it outputs to the serial port.  In this way, data is passed from the
%   arduino to matlab. 
%     The data that is received from the serial port is passed to the
%   matlab main environment through global variables. 
%
% Variables:
%   obj = Serial port object
%   event = 
%
% function serialCallBack(obj, event)
%--------------------------------------------------------------------------
function serialCallBack(obj, event)


global index
global mot1
global mot2
global sen1
global sen2
global sen3
global sen4
global sen5
global dist1

persistent data
persistent state
persistent Pindex
persistent Pmot1
persistent Pmot2
persistent Psen1
persistent Psen2
persistent Psen3
persistent Psen4
persistent Psen5
persistent Pdist1

if isempty(state)
    state = 0;
end

%obj.BytesAvailable

%    data = [data fgetl(obj)];
if obj.BytesAvailable > 10
    data = [data char(fread(obj, obj.BytesAvailable)')];
end
while(length(data) > 10)
    kk = 1; % if the data contains more than one packet the data will get reset at the bottom of the loop 

    if state == 0 %looking for cr '\r'
        while(kk <= length(data) && state == 0)
            if (data(kk) == char(13))
                state = 1;
                Pindex = '';
                Pmot1 = '';
                Pmot2 = '';
                Psen1 = '';
                Psen2 = '';
                Psen3 = '';
                Psen4 = '';
                Psen5 = '';
                Pdist1 = '';
            end
            kk = kk + 1;
        end
    end
    if state == 1 %looking for lf '\n'
        while kk <= length(data) && state == 1
            if data(kk) == char(10)
                state = 30;
            end
            kk = kk + 1;
        end
    end
    if state == 30 %reading index
        while kk <= length(data) && state == 30
            if data(kk) ~= ','
                Pindex = [Pindex data(kk)];
            else
                Pindex = Pindex;
                state = 3;
            end
            kk = kk + 1;
        end
    end
    if state == 2 %looking for ','
        while kk <= length(data) && state == 2 
            if data(kk) == ','
                state = 3;
            end
            kk = kk + 1;
        end
    end
    if state == 3 %reading MOT1 distance
        while kk <= length(data) && state == 3
            if data(kk) ~= ','
                Pmot1 = [Pmot1 data(kk)];
            else
                Pmot1 = Pmot1;
                state = 4;
            end
            kk = kk + 1;
        end
    end
    if state == 4 %reading MOT2 distance
        while kk <= length(data) && state == 4
            if data(kk) ~= ','
                Pmot2 = [Pmot2 data(kk)];
            else
                Pmot2 = Pmot2;
                state = 5;
            end
            kk = kk + 1;
        end
    end
    if state == 5 %reading Line SEN1
        while kk <= length(data) && state == 5
            if data(kk) ~= ','
                Psen1 = [Psen1 data(kk)];
            else
                Psen1 = Psen1;
                state = 6;
            end
            kk = kk + 1;
        end
    end
    if state == 6 %reading Line SEN2
        while kk <= length(data) && state == 6
            if data(kk) ~= ','
                Psen2 = [Psen2 data(kk)];
            else
                Psen2 = Psen2;
                state = 7;
            end
            kk = kk + 1;
        end
    end
    if state == 7 %reading Line SEN3
        while kk <= length(data) && state == 7
            if data(kk) ~= ','
                Psen3 = [Psen3 data(kk)];
            else
                Psen3 = Psen3;
                state = 8;
            end
            kk = kk + 1;
        end
    end
    if state == 8 %reading Line SEN3
        while kk <= length(data) && state == 8
            if data(kk) ~= ','
                Psen4 = [Psen4 data(kk)];
            else
                Psen4 = Psen4;
                state = 9;
            end
            kk = kk + 1;
        end
    end
    if state == 9 %reading Line SEN3
        while kk <= length(data) && state == 9
            if data(kk) ~= ','
                Psen5 = [Psen5 data(kk)];
            else
                Psen5 = Psen5;
                state = 10;
            end
            kk = kk + 1;
        end
    end
    if state == 10 % Reading IR distance sensor
        while kk <= length(data) && state == 10
            if data(kk) ~= char(13)
                Pdist1 = [Pdist1 data(kk)];
            else
                Pdist1 = Pdist1;
                state = 11;
            end
            kk = kk + 1;
        end
    end
    if state == 11
%        disp([index ' M1: ' mot1 ' M2: ' mot2 ' S1: ' sen1 ' S2: ' sen2 ' S3: ' sen3 ' D1: ' dist1]);
        mot1 = Pmot1;
        mot2 = Pmot2;
        sen1 = Psen1;
        sen2 = Psen2;
        sen3 = Psen3;
        sen4 = Psen4;
        sen5 = Psen5;
        dist1 = Pdist1;
        index = Pindex; % do this last to help with synchronization
        state = 0;
        kk = kk - 2; % put the 13 back into the data
    end
    if kk < 1
        kk = 1;
    end
    if kk <= length(data)
        data = data(kk:length(data));
    else
        data = [];
    end
    % this is probably not necessary
    % it would be necessary if we stopped after every update
    % and more than one update happened between reads
end

end %function
