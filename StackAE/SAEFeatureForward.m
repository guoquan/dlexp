function [y, dataStack] = SAEFeatureForward(theta, x, network, c)

depth = numel(network.layerSize)-2;

encoder.layerSize = network.layerSize(1:(depth+1));
encoder.hasBias = network.hasBias.f;
encoder.f = network.f.f;

[y, dataStack] = SBPFeedforward(theta, x, encoder, c);