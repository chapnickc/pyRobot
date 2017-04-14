addpath('./')
load 'rgb-training.mat'
whos

X = M(:,1:3);

i = 2;
rgb = M(i,1:3);
y = M(i,4);

color = classify_rgb(rgb);

M(50,:)
color = classify_rgb(M(50,1:3))
