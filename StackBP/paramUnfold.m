function [ stack ] = paramUnfold( theta, network )

offset = 0;
depth = numel(network.layerSize)-1;
stack = cell(depth,1);
for l = 1:depth
    theta_size = network.layerSize(l + 1) * network.layerSize(l);
    stack{l}.w = reshape(theta(offset + (1:theta_size)), network.layerSize(l+1), network.layerSize(l));
    offset = offset + theta_size;
    if network.hasBias(l)
        stack{l}.b = reshape(theta(offset + (1:network.layerSize(l+1))), network.layerSize(l+1), 1);
        offset = offset + network.layerSize(l+1);
    end
end

end

