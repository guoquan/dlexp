function f = getCostInterface
f.f = @cost;
f.d = @grad;
end

function cost = cost(h, y, network, c)
cost = 0;
end

function g = grad(h, y, cost, network, c)
g = 0;
end
