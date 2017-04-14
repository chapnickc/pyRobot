% Read sample images 
function imgs = myimread(path)
    imgs = {};
    impaths = glob(path);
    for i = 1:length(impaths); 
        imgs{i} = imread(impaths{i}); 
    end
end
