function gridresult(result_bp,testLabels)
step = 5e-3;
gridmap = nan(numel(1e-5:step:1));
for i = 1:numel(1e-5:step:1)
    d = 1e-5:step:1;
    up = d(i);
    for j = 1:numel(1e-5:step:up)
        d = 1e-5:step:up;
        down = d(j);
        result_label_bp = zeros(size(result_bp));
        result_label_bp(result_bp>up) = 1;
        result_label_bp(result_bp<down) = -1;
        result_label_bp = result_label_bp + 2;
        result_mat_bp = full(sparse(result_label_bp, 1:numel(result_label_bp), 1));
        test_map = full(sparse(testLabels, 1:numel(testLabels), 1));
        
        try
            gridmap(i,j) = pr_result( result_mat_bp, test_map );
        catch err
        end
    end
end
mesh(gridmap);
d = 1e-5:step:1;
t = 1:15:length(d);

tit = sprintf('max: %f',max(gridmap(:)));
title(tit);

xlabel('down');
ylabel('up');


set(gca,'XTick',t);
set(gca,'XTickLabel',d(t));

set(gca,'YTick',t);
set(gca,'YTickLabel',d(t));