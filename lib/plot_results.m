function plot_results(img, dilated, results, ixpath)
    subplot(1,2,1); imshow(img);
    subplot(1,2,2); imshow(dilated);hold on
    subplot(1,2,1); imshow(img);
    subplot(1,2,2); imshow(dilated);hold on
    plot(results.frontix(1), results.frontix(2),  'r.', 'MarkerSize', 20)
    plot(results.backix(1), results.backix(2),  'r.', 'MarkerSize', 20)
    plot(results.robotix(1), results.robotix(2),'g.','MarkerSize',20);
    plot(ixpath(:,2), ixpath(:,1), 'r.')
    plot(results.frontix(1), results.frontix(2),  'r.', 'MarkerSize', 20)
    plot(results.backix(1), results.backix(2),  'r.', 'MarkerSize', 20)
    plot(results.robotix(1), results.robotix(2),'g.','MarkerSize',20);
    plot(ixpath(:,2), ixpath(:,1), 'r.')
end
