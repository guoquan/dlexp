function [h, dataStack] = SBPFeedforward(theta, x, network, c)

if ~iscell(theta)
    theta = paramUnfold(theta, network);
end

c.paramStack = theta;

depth = numel(network.layerSize)-1;

c.dataStack = cell(numel(network.layerSize),1);
c.dataStack{1}.a = x;
for l = 1:depth
    c.dataStack{l + 1}.z = theta{l}.w * c.dataStack{l}.a;
    if network.hasBias(l)
        c.dataStack{l + 1}.z = bsxfun(@plus , c.dataStack{l + 1}.z, theta{l}.b);
    end
    c.dataStack{l + 1}.a = network.f{l}.f(c.dataStack{l + 1}.z, c);
end

h = c.dataStack{depth + 1}.a;
dataStack = c.dataStack;

end
