% correspoding label: 0 = noise | 1 = blue | 2 = green | 3 = pink
colors = {'noise','blue','green','pink'};

M0 = load('rgb-training.mat');
M1 = load('./april-17-rgb-training.mat');

X = [M0.M(:,1:3);  M1.M(:,1:3)];         % rgb values without labels
size(X)     
labels = [M0.M(:,4); M1.M(:,4)];         % color labels
classes = unique(labels);


% build SVM models and get prediction results
models = {};
for i=1:length(colors)
    % y: -1's for outgroup, 1's for ingroup
    y = 2 * (labels == classes(i)) - 1;
    SVMModel = fitcsvm(X,y);
    models{i} = SVMModel;
    [p, scores] = predict(SVMModel, X);
    p = predict(SVMModel,X);
    success = 1 - length(find(p ~= y)) / size(X, 1);
    str = sprintf('\t%s prediction: %3.2f%% correct', colors{i}, 100*success);
    disp(str)
end

%save('./lib/trained-SVMModels.mat','models')
%save('./trained-SVMModels.mat','models')



%{

    noise prediction: 89.06% correct
    blue prediction: 89.06% correct
    green prediction: 100.00% correct
    pink prediction: 100.00% correct


** 10-Fold Cross Validation: **
    11.56% misclassified noise
    11.09% misclassified blue
    0.00% misclassified green 
    0.00% misclassified pink


%}



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




%... save 'trained-SVMModels.mat', 'models'
%save('trained-SVMModels.mat', 'models')
%save('./lib/trained-SVMModels.mat', 'models')

% run function described above
svm_3d_matlab_vis(models{1},X,y)

%------------------------------------------------
hold on;
groundTruth = y;
pos = find(groundTruth==1);
scatter(d(pos,1), d(pos,2), 'r')
pos = find(groundTruth==-1);
scatter(d(pos,1), d(pos,2), 'b')

% now plot support vectors
hold on;
sv = full(model.SVs);
plot(sv(:,1),sv(:,2),'ko');

% now plot decision area
[xi,yi] = meshgrid([min(d(:,1)):0.01:max(d(:,1))],[min(d(:,2)):0.01:max(d(:,2))]);
dd = [xi(:),yi(:)];
tic;[predicted_label, accuracy, decision_values] = svmpredict(zeros(size(dd,1),1), dd, model);toc
pos = find(predicted_label==1);
hold on;
redcolor = [1 0.8 0.8];
bluecolor = [0.8 0.8 1];
h1 = plot(dd(pos,1),dd(pos,2),'s','color',redcolor,'MarkerSize',10,'MarkerEdgeColor',redcolor,'MarkerFaceColor',redcolor);
pos = find(predicted_label==-1);
hold on;
h2 = plot(dd(pos,1),dd(pos,2),'s','color',bluecolor,'MarkerSize',10,'MarkerEdgeColor',bluecolor,'MarkerFaceColor',bluecolor);
uistack(h1, 'bottom');
uistack(h2, 'bottom');





%------------------------------------------------





% Plots
figure;
h(1:2) = gscatter(X(:,1),X(:,2),y); hold on
h(3) = plot(X(model.IsSupportVector,1), X(model.IsSupportVector,2),...
        'ko','MarkerSize',10);
title('Scatter Diagram with the Decision Boundary')
legend({'-1','1','Support Vectors'},'Location','Best');
hold off



