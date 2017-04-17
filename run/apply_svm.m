
load 'rgb-training.mat'
whos

% 0 = noise | 1 = blue | 2 = green | 3 = pink
labels = M(:,4);
classes = unique(labels);

classnames = {'noise','blue','green','pink'};

% rgb values without labels
X = M(:,1:3);

% build SVM models and get prediction results
models = {};
for i=1:length(classes)
    % labels: -1's for outgroup, 1's for ingroup
    y = 2*(labels == classes(i))-1;
    SVMModel = fitcsvm(X,y);
    models{i} = SVMModel;
    [p,scores] = predict(SVMModel, X);
    p = predict(SVMModel,X);
    success = 1 - length(find(p ~= y)) / size(X,1);
    str = sprintf('\t%s: %3.2f%% correct labels', classnames{i}, 100*success);
    disp(str)
end


for i=1:length(classes)
    % labels: -1's for outgroup, 1's for ingroup
    y = 2*(labels == classes(i))-1;
    SVMModel = models{i}
    [p,scores] = predict(SVMModel, X);
    p = predict(SVMModel,X);
    success = 1 - length(find(p ~= y)) / size(X,1);
    str = sprintf('\t%s: %3.2f%% correct labels', classnames{i}, 100*success);
    disp(str)
end




load('trained-SVMModels.mat')
classes={'noise','blue','green','pink'};

% recursively traverse the decision tree 
if predict(models{ix}, rgb) == 1
    predicted = classes{ix}; 
elseif ix < length(classes)
    ix = ix + 1;
    predicted=classify_rgb(rgb,ix);
end





%... save 'trained-SVMModels.mat', 'models'

% perform 10-fold cross validation 
i = 1
for i=1:length(models)
    model = models{i};
    CVmodel = crossval(model);
    % classicication loss for observations not used for training.
    misclass = kfoldLoss(CVmodel);
    str = sprintf('%3.2f%% misclassified', 100*misclass);
    disp(str)
end


% Plots
figure;
h(1:2) = gscatter(X(:,1),X(:,2),y); hold on
h(3) = plot(X(model.IsSupportVector,1), X(model.IsSupportVector,2),...
        'ko','MarkerSize',10);
title('Scatter Diagram with the Decision Boundary')
legend({'-1','1','Support Vectors'},'Location','Best');
hold off



