%{
    Feedback system for the robot's orientation
%}
function [diff, target] = getAngleCorrection(alpha, ixpath)

    target_alpha=[];

    for i=1:5:length(ixpath)-5
        dy = -(ixpath(i+5,2)- ixpath(i,2));
        dx = ixpath(i+5,1)- ixpath(i,1);
        alpha_i = atan2d(dx, dy);
        target_alpha = [target_alpha; alpha_i];
    end

    target = target_alpha(1);
    diff = alpha - target;
end

