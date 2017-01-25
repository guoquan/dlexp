function f = getActivaionInterface
f.f = @activation;
f.d = @grad;
end

function y = activation(x,c)
y = 0;
end

function d = grad(x, y, c) 
d = 0;
end
