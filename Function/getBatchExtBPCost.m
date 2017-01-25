function [ bp ] = getBatchExtBPCost
bp.f = @batchcost;
bp.d = @dbatchcost;
end

function cost = batchcost(h, y, network, c)
h(network.ext.mask) = y(network.ext.mask);
cost = sum(sum((y-h).^2))./(2*size(y,2));
end

function g = dbatchcost(h, y, ~, network, c)
h(network.ext.mask) = y(network.ext.mask);
g = - (y - h) ./ size(y,2);
end
