function [m, b] = bisect(decV)
    mid = (decV(1,:) + decV(2,:))/2;
    m_o = (decV(2,2) - decV(1,2))/(decV(2,1) - decV(1,1));
    m = -1/m_o;
    b = mid(2) - m*mid(1);
end
