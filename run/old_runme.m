addpath('./')
addpath('../')
addpath('../lib')
addpath('../lib/ebel')
addpath('../lib/ebel/matlab/')
%load FloorXform

RESAMPLE=false; FINDROBOT=true;

% Initialize Webcam Interface
%camlist = webcamlist;
%cam = webcam(2); preview(cam)

% Main Loop
timer=60; tic
while abs(toc) < timer
    %img = cam.snapshot;

    [x, y, alpha, dilated, robotloc] =  Robot_position(img);
    [optimal_path, pixelpath] = findPath(dilated, robotloc);

    pixelpath
    plot(pixelpath(:,2), pixelpath(:, 1))

end




%-----------------------------------------------------------
%           Test Code
%-----------------------------------------------------------

% Read sample images 
imgs = myimread('../images/edges_*.png');
img = imgs{7};

[denoised edges filled cleaned labeled] = algorithm(img, neighborhood, sigma, pxthresh);
imshow(img)


figure(1);
subplot(2,2,1); imagesc(img)
subplot(2,2,2); imagesc(cleaned)
subplot(2,2,3); imagesc(labeled)
subplot(2,2,4); imagesc(dilated); hold on;
p = plot(robotloc(1), robotloc(2), 'g.', ...
         endpoint(1), endpoint(2), 'c.');
p(1).MarkerSize = 15; p(2).MarkerSize = 15;
plot(pixelpath(:,2), pixelpath(:,1), 'r.')
hold off



p = plot(startpoint(1), startpoint(2), 'g.', ...
         endpoint(1), endpoint(2), 'c.');
p(1).MarkerSize = 15; p(2).MarkerSize = 15;
plot(optimal_path(:,2), optimal_path(:,1), 'r.')
hold off




[denoised edges filled cleaned labeled] = algorithm(img, neighborhood, sigma, pxthresh);
figure; 
subplot(2,2,1), imshow(edges); 
subplot(2,2,2), imshow(filled) 
subplot(2,2,3), imshow(cleaned) 
subplot(2,2,4), imagesc(labeled)


l = 1; label_vec = pinkix;
maxarea = sum(sum(labeled == label_vec(1)));
for i = 2:length(pinkix)
    total =  sum(sum(labeled == pinkix(i)));
    if total > maxarea
        maxarea = total;
        l = i; % update label
    end
end

Z = labeled == pinkix(l);
imshow(Z)





% Read sample images 
imgs = myimread('./images/edges_*.png');
img = imgs{10};

imshow(dilated); hold on 
