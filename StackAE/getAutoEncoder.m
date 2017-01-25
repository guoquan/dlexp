function [ sae ] = getAutoEncoder( network, l, cost )
%GETFEADFORWARDNETWORK Summary of this function goes here
%   Detailed explanation goes here

if 2 == nargin
    cost = getBatchBPCost;
end

sae.layerSize = [network.layerSize(l) network.layerSize(l+1) network.layerSize(l)];
sae.hasBias = [network.hasBias.f(l) network.hasBias.b(l)];
sae.f = {network.f.f{l}, network.f.b{l}};
sae.cost = cost;
sae.minOptions = network.minOptions;

end

