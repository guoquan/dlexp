function [ sae ] = getFeadForwardNetwork( network )
%GETFEADFORWARDNETWORK Summary of this function goes here
%   Detailed explanation goes here

sae.layerSize = network.layerSize;
sae.hasBias = network.hasBias.f;
sae.f = [network.f.f network.out.f];
sae.cost = network.out.cost;
sae.minOptions = network.minOptions;

end

