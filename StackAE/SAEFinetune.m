function [thetaOpt, cost] = SAEFinetune(thetaPre, network, x, y)
%% construct theta for the whole big network
sae = getFeadForwardNetwork(network);
if isfield(network,'finetuneHooks')
    for i = 1:numel(network.finetuneHooks)
        hook = network.finetuneHooks{i};
        sae = addHook( hook.f(hook.opt), sae );
    end
end

%% init parameter for softmax
depth = numel(network.layerSize)-2;
softmax.layerSize = [network.layerSize(depth + 1) network.layerSize(depth + 2)];
softmax.hasBias = network.hasBias.f(depth+1);
thetaSoftmax = SBPInitParam(softmax);
thetaPre = cat(1, thetaPre, thetaSoftmax);

%% finetune
[thetaOpt, cost] = SBPTrain(thetaPre, sae, x, y);
