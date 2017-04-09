cd('C:\Users\Claire\Documents\JD_Images')
camlist = webcamlist;
cam = webcam(2);

preview(cam)
for i = 10:29
    filename = ['newmask_',num2str(i),'.png'];
    img = snapshot(cam);
    imwrite(img,filename)
    disp('press a key')
    pause
    disp('thanks')
end
size(img)

i = 3;
filename = ['justmask_',num2str(i),'.png'];
img = snapshot(cam);
imwrite(img,filename)



