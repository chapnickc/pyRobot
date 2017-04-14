
load 'rgb-training.mat'
whos

% 0 = noise | 1 = blue | 2 = green | 3 = pink
labels = M(:,4);
classes = unique(labels);


% rgb values without labels
X = M(:,1:3);

models = {};
for i=1:length(classes)
    % labels: -1's for outgroup, 1's for ingroup
    y = 2*(labels == classes(i))-1;
    SVMModel = fitcsvm(X,y);
    models{i} = SVMModel;
    [p,scores] = predict(SVMModel,M(:,1:3));
    p = predict(SVMModel,M(:,1:3));

    success = 1 - length(find(p ~= y))/size(M,1);
    disp(['Success rate: ', num2str(100*success),' %'])
end

model = models{1};
CVmodel = crossval(model);
misclass = kfoldLoss(CVmodel);
misclass


figure;
h(1:2) = gscatter(X(:,1),X(:,2),y); hold on
h(3) = plot(X(model.IsSupportVector,1), X(model.IsSupportVector,2),...
        'ko','MarkerSize',10);
title('Scatter Diagram with the Decision Boundary')
legend({'-1','1','Support Vectors'},'Location','Best');
hold off



contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend({'-1','1','Support Vectors'},'Location','Best');
hold off


figure
pair = [2,3];
mes
gscatter(X(:,pair(1)),X(:,pair(2)),y); hold on
plot(X(model.IsSupportVector,pair(1)), X(model.IsSupportVector,pair(2)),'ko','MarkerSize',10)
hold off





