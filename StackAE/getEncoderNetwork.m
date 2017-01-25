function [ sae ] = getEncoderNetwork( network )
%GETFEADFORWARDNETWORK Summary of this function goes here
%   Detailed explanation goes here

sae.layerSize = network.layerSize(1:end-1);
sae.hasBias = network.hasBias.f(1:end-1);
sae.f = network.f.f;
sae.minOptions = network.minOptions;

end

