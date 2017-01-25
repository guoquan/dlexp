function [thetaOpt] = SAEFeatureFinetune(thetaForward, thetaBack, network, x)
%% construct theta for the whole big network
sae.layerSize = [network.layerSize(1:(end-1)) network.layerSize((end-1):-1:1)];
sae.hasBias = [network.hasBias.f(1:(end-1)) network.hasBias.b((end):-1:1)] ;
sae.f = [network.f.f network.f.b((end):-1:1)];
sae.cost = getBatchBPCost;
sae.minOptions = network.minOptions;

thetaInit = [thetaForward; thetaBack];

%% finetune
[thetaOpt, ~] = SBPTrain(thetaInit, sae, x, x);
