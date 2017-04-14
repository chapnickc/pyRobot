camlist = webcamlist;
cam = webcam(2);
preview(cam)

neighborhood = [2 2]; sigma = 2; pxthresh=200;

tic
while (1)
   
    img = snapshot(cam);

    [denoised edges filled cleaned labels] = algorithm(img, neighborhood, sigma, pxthresh);
    centers = regionprops(labels, 'Centroid'); 

    predicted = struct() 
    for label=1:numel(centers)
        coordinates = round(centers(label).Centroid);
        rgb = double(img(coordinates(2),coordinates(1),:));
        rgb = reshape(rgb,1,3);
        predicted.labels{label} = classify_rgb(rgb);
    end

    front = centers(find(contains(predicted.labels, 'pink'))).Centroid;
    back = centers(find(contains(predicted.labels, 'green'))).Centroid;
    imshow(img)




end




