function [thetaOpt, cost] = SAESoftmax(network, feature, y)

depth = numel(network.layerSize)-2;

%% train softmax
softmax.layerSize = [network.layerSize(depth + 1) network.layerSize(depth + 2)];
softmax.hasBias = network.hasBias.f(depth+1);
softmax.f = {getBatchSoftmax};
softmax.cost = getBatchSoftmaxCost;
softmax.minOptions = network.minOptions;

thetaInit = SBPInitParam(softmax);
[thetaOpt, cost] = SBPTrain(thetaInit, softmax, feature, y);