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

    [x, y, alpha, dilated, results] =  Robot_position(img);
    [optimal_path, pixelpath] = findPath(dilated, results.robotix);

    pixelpath
    plot(pixelpath(:,2), pixelpath(:, 1))



end


dy =  results.backix(2) - results.frontix(2)
dx =  results.frontix(1) - results.backix(1);
d = sqrt(dx^2 + dy^2);

asind(dy/d)

%atan2d(results.frontix(2),results.frontix(1))
atan2d(dy,dx)
%%

findAngle(results.frontix, results.backix)




%-----------------------------------------------------------
%           Test Code
%-----------------------------------------------------------

% Read sample images 
imgs = myimread('../images/edges_*.png');
img = imgs{7};
img = imgs{8};

neighborhood = [2 2]; 
sigma = 2; pxthresh=200; 
[denoised edges filled cleaned labeled] = algorithm(img, neighborhood, sigma, pxthresh);
imshow(img)


figure(1);
subplot(2,2,1); imagesc(img)
subplot(2,2,2); imagesc(cleaned)
subplot(2,2,3); imagesc(labeled)
subplot(2,2,4); imagesc(dilated); hold on;
plot(results.frontix(1), results.frontix(2),  'r.', 'MarkerSize', 20)
plot(results.backix(1), results.backix(2),  'r.', 'MarkerSize', 20)
plot(results.robotix(1), results.robotix(2),'g.','MarkerSize',20);
plot(ixpath(:,2), ixpath(:,1), 'r.')
plot(results.frontix(1), results.frontix(2),  'r.', 'MarkerSize', 20)
plot(results.backix(1), results.backix(2),  'r.', 'MarkerSize', 20)
plot(results.robotix(1), results.robotix(2),'g.','MarkerSize',20);
plot(ixpath(:,2), ixpath(:,1), 'r.')










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

imgs = myimread('../train/images/edges_*.png');
img = imgs{35}; imshow(img)

imgs = myimread('../train/images/april17/edges_*.png');
ix = [10, 3, 5, 11, 12, 14, 20, 22, 24, 27];

x = glob('../train/images/edges_*.png')
x(ix)

imshow(imgs{ix(1)})
findAngle([259, 235],[249, 256])

imshow(imgs{ix(2)})
findAngle([321, 140],[297, 149])

imshow(imgs{ix(3)})
findAngle([111, 279], [103, 303])

imshow(imgs{ix(4)})
findAngle([238, 84], [232, 96])

imshow(imgs{ix(5)})
findAngle([315, 80], [298, 85])

imshow(imgs{ix(6)})
findAngle([313, 169], [292, 183])

imshow(imgs{ix(7)})
findAngle([259, 58], [235, 54])

imshow(imgs{ix(8)})
findAngle([436, 258], [401, 270])

imshow(imgs{ix(9)})
findAngle([505, 192], [503, 209])

imshow(imgs{ix(10)})
findAngle([348, 149], [327 136])


for i = ix(1:end)
    img = imgs{i};
    imshow(img)
    pause(1)
    [x, y, alpha, dilated, robotloc] =  Robot_position(img);
    disp(alpha)
end



img = imgs{27}; imshow(img)

imshow(dilated); hold on 
