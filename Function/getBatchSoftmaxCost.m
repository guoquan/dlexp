function [ s ] = getBatchSoftmaxCost
s.f = @softmaxcost;
s.d = @dsoftmaxcost;
end

function cost = softmaxcost(h, y, network, c)
%theta = paramFold(c.paramStack, network);
cost = -sum(sum(y.*log(h))) ./ size(y, 2);% + network.param.lambda * sum(c.paramStack{end-1}.w(:).^2) ./ 2;
end

function g = dsoftmaxcost(h, y, ~, network, c)
g = - (y - h) ./ size(y, 2);% + network.param.lambda * c.paramStack{end-1}.w;
end
