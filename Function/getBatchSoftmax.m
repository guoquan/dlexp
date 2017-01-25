function [ s ] = getBatchSoftmax
s.f = @softmax;
s.d = @softmaxd;
end

function h = softmax(z, ~)
z = bsxfun(@minus, z, max(z,[],1));
ez = exp(z);
h = bsxfun(@rdivide, ez, sum(ez));
end

function g = softmaxd(~, ~, ~)
% theta = paramFold(c.paramStack, c.network);
%g = - (y - h) * c.dataStack{end-1}.a' / size(y, 2) + c.network.param.lambda * c.paramStack{end-1}.w;
g = 1;
end
