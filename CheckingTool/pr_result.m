function [ accuracy, precision, recall, f1, confusion ] = pr_result( result, groundTruth )
%PR_RESULT Summary of this function goes here
%   Detailed explanation goes here
[~, predInd] = max(result);
[~, gtInd] = max(groundTruth);

m = size(result,1);
n = size(result,2);

% construct confusion matrix
confusion = zeros(m);
for i = 1:n
%  rows for ground truth
%  columns for prediction
    confusion(gtInd(i),predInd(i)) = confusion(gtInd(i),predInd(i)) + 1;
end

[ accuracy, precision, recall, f1 ] = c2pr_result( confusion );
end

