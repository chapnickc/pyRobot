
addpath('./')
addpath('./lib/')
load('trained-SVMModels.mat')
load('april-17-rgb-training.mat')


X = M(:,1:3);
labels = M(:,4);
classes={'noise','blue','green','pink'};


for i=1:length(models)
    % labels: -1's for outgroup, 1's for ingroup
    y = 2*(labels == (i-1))-1;
    SVMModel = models{i};
    [p,scores] = predict(SVMModel, X);
    p = predict(SVMModel,X);
    success = 1 - length(find(p ~= y)) / size(X,1);
    str = sprintf('\t%s: %3.2f%% correct labels', classes{i}, 100*success);
    disp(str)
end

