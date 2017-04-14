% calculate robot angle in degrees
function angle = findAngle(front,back)
    dx = front(1) - back(1);
    dy = front(2) - back(2);
    d = sqrt(sum(dx^2 + dy^2));
    angle = rad2deg(acos(dx/d));
end


