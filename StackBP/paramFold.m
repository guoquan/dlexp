function [ theta ] = paramFold( stack, network )

depth = numel(network.layerSize)-1;

theta = [];
for l = 1:depth
    theta = cat(1, theta, stack{l}.w(:));
    if network.hasBias(l)
        theta = cat(1, theta, stack{l}.b(:));
    end
end
end

