function [labels, centers] = classifyPoints(img, coordStruct)

labels={};
centers = zeros(length(coordStruct),3);
for label=1:length(coordStruct)
    coordinates = round(coordStruct(label).Centroid);
    rgb = img(coordinates(2),coordinates(1),:);
    rgb = reshape(double(rgb),1,3);
    centers(label,:) = rgb;
    labels{label} = classify_rgb(rgb);
end
