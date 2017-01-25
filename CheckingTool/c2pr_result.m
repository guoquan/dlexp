function [ accuracy, precision, recall, f1 ] = c2pr_result( c )
%PR_RESULT Summary of this function goes here
%   Detailed explanation goes here
accuracy = sum(diag(c))/sum(c(:));
precision = diag(c)./sum(c, 1)';
recall = diag(c)./sum(c, 2);

precision(isnan(precision)) = 0;
recall(isnan(recall)) = 0;

f1 = 2 .* (precision .* recall) ./ ( precision + recall );
end

