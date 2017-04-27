addpath('.')
fname = '../images/samples/img_0.png';
im = imread(fname);
imshow(im)

imgray = rgb2gray(im);
denoised = medfilt2(imgray,[4 4],'symmetric');imshow(denoised)
edges = edge(denoised,'Canny',[],1); imshow(edges)
filled = imfill(edges,'holes'); imshow(filled)
imshow(filled) 

cleaned = bwareaopen(filled, 300);
imshow(cleaned)

labels = bwlabel(cleaned);
imagesc(labels); colorbar

% --------------------------------------------
%   Plot objects and labels
% --------------------------------------------
figure(1)
s = regionprops(labels, 'Centroid'); 
imshow(cleaned)
hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    plot(c(1),c(2), 'r.', 'MarkerSize', 50)
    text(c(1), c(2), sprintf('%d', k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off




% --------------------------------------------
% Classify objects using SVM approach
% -------------------------------------------

% loop through all coordinates (associated with labels)
% and store RGB values
RGB = zeros(size(s,1), 3);
s = regionprops(labels, 'Centroid'); 
for label=1:numel(s)
    coordinates = s(label).Centroid;
    c = round(coordinates);
    rgb = im(c(2),c(1),:);
    RGB(label,:) = reshape(rgb,1,3);
end

% Red vs Green and labels for each point
figure(2); 
plot(RGB(:,1), RGB(:,2), 'r.'); hold on
title('Red vs Green')
s = regionprops(labels, 'Centroid'); 
for label=1:numel(s)
    coordinates = s(label).Centroid;
    disp(coordinates)
    c = round(coordinates);
    rgb = reshape(im(c(2),c(1),:), 1, 3);
    text(double(rgb(1)), double(rgb(2)), sprintf('%d', label), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off


% Red vs Blue and labels for each point
figure(3); 
plot(RGB(:,1), RGB(:,3), 'r.'); hold on
title('Red vs Blue')
s = regionprops(labels, 'Centroid'); 
for label=1:numel(s)
    coordinates = s(label).Centroid;
    disp(coordinates)
    c = round(coordinates);
    rgb = reshape(im(c(2),c(1),:), 1, 3);
    text(double(rgb(1)), double(rgb(3)), sprintf('%d', label), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off

% ---------------------------------------------------------
%  Tuning decision points
% ---------------------------------------------------------


% Green vs Blue and labels for each point
fig = figure(4); 
plot(RGB(:,2), RGB(:,3), 'r.','MarkerSize',20); hold on
title('Green vs Blue')
s = regionprops(labels, 'Centroid'); 
for label=1:numel(s)
    coordinates = s(label).Centroid;
    c = round(coordinates);
    rgb = reshape(im(c(2),c(1),:), 1, 3);
    text(double(rgb(2)), double(rgb(3)), sprintf('%d', label), ...
        'HorizontalAlignment', 'right', ...
        'VerticalAlignment', 'bottom',...
        'FontSize',14);
end
p1_gb = [127.66,160.17]; p2_gb= [132.66,161.61]; % green vs blue decision
decV = [p1_gb; p2_gb];
[m, b] = bisect(decV);
x = linspace(80,200,1e3);
plot(x, m*x + b, 'k', 'Linewidth',2); hold on
%plot(p1_gb,p2_gb,'k.', 'MarkerSize',10)
hold off


label = 9;
coordinates = s(label).Centroid;
c = round(coordinates);
rgb = reshape(im(c(2),c(1),:), 1, 3);
nearest_neighbor(double(rgb(1,[2,3])), decV)

[x, y] = getpts(fig)


% ----------------------------------------------

% Red vs Blue and labels for each point
fig = figure(3); 
plot(RGB(:,1), RGB(:,3), 'r.', 'MarkerSize', 20); hold on
title('Red vs Blue')
s = regionprops(labels, 'Centroid'); 
for label=1:numel(s)
    coordinates = s(label).Centroid;
    disp(coordinates)
    c = round(coordinates);
    rgb = reshape(im(c(2),c(1),:), 1, 3);
    text(double(rgb(1)), double(rgb(3)), sprintf('%d', label), ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'bottom',...
        'FontSize',14);
end
p1_rb = [107.88,221.91]; p2_rb= [142.56, 149.73]; % green vs blue decision
decV = [p1_rb; p2_rb];
[m, b] = bisect(decV);
x = linspace(60,275,1e3);
plot(x, m*x + b); hold on
%plot(p1_rb,p2_rb,'k.', 'MarkerSize',10)
hold off


label = 8;
coordinates = s(label).Centroid;
c = round(coordinates);
rgb = reshape(im(c(2),c(1),:), 1, 3);
nearest_neighbor(double(rgb(1,[1,3])), decV)

[x, y] = getpts(fig)



% ----------------------------------------------

% Red vs Green and labels for each point
fig = figure(2); 
plot(RGB(:,1), RGB(:,2), 'r.','MarkerSize',20); hold on
title('Red vs Green')
s = regionprops(labels, 'Centroid'); 
for label=1:numel(s)
    coordinates = s(label).Centroid;
    disp(coordinates)
    c = round(coordinates);
    rgb = reshape(im(c(2),c(1),:), 1, 3);
    text(double(rgb(1)), double(rgb(2)), sprintf('%d', label), ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'bottom',...
        'FontSize',14);
end
p1_rg = [126.83, 174.22]; p2_rg= [230.87, 129.84]; % green vs blue decision
decV = [p1_rg; p2_rg];
[m, b] = bisect(decV);
x = linspace(60,300,1e3);
plot(x, m*x + b); hold on
%plot(p1_rb,p2_rb,'k.', 'MarkerSize',10)
hold off
fig = figure(2); 
plot(RGB(:,1), RGB(:,2), 'r.','MarkerSize',20); hold on
title('Red vs Green')
s = regionprops(labels, 'Centroid'); 
for label=1:numel(s)
    coordinates = s(label).Centroid;
    disp(coordinates)
    c = round(coordinates);
    rgb = reshape(im(c(2),c(1),:), 1, 3);
    text(double(rgb(1)), double(rgb(2)), sprintf('%d', label), ...
        'HorizontalAlignment', 'left', ...
        'VerticalAlignment', 'bottom',...
        'FontSize',14);
end
p1_rg = [126.83, 174.22]; p2_rg= [230.87, 129.84]; % green vs blue decision
decV = [p1_rg; p2_rg];
[m, b] = bisect(decV);
x = linspace(60,300,1e3);
plot(x, m*x + b); hold on
%plot(p1_rb,p2_rb,'k.', 'MarkerSize',10)
hold off


label = 10;
coordinates = s(label).Centroid;
c = round(coordinates);
rgb = reshape(im(c(2),c(1),:), 1, 3);
classify_point(rgb)


[x, y] = getpts(fig)




% ----------------------------------------------
%p1_gb = [99.6, 219]; p2_gb= [123.8, 227.38]; % green vs blue decision
