% calculate robot angle in degrees
function alpha = findAngle(front, back)
    dx = front(1) -  back(1);
    dy =  back(2) - front(2); % y axis flipped in image
    d = sqrt(sum(dx^2 + dy^2));
    alpha = atan2d(dy,dx);
end
