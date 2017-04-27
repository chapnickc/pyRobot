function [dilated, mask] = dilateObjects(img, labels, colorix)
    mask = zeros(size(img));
    for i=1:length(colorix)
        mask= mask + (labels == colorix(i));
    end

    len = 30; width=30;
    se = [strel('line',len,90), strel('line',width,0)];
    dilated = imdilate(mask,se);
end
