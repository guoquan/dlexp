function [theta, feature, stack]= SAEPreTrain(network, x, y)

if 2 == nargin
    y = x;
end

depth = numel(network.layerSize)-2;

stack = cell(depth + 1,1);
stack{1}.data = x;
stack{1}.target = y;
theta = [];

for l = 1:depth
    % train a local bp
    ae = getAutoEncoder( network, l );
    if isfield(network,'pretrainHooks')
        for i = 1:numel(network.pretrainHooks)
            hook = network.pretrainHooks{i};
            ae = addHook( hook.f(hook.opt), ae );
        end
    end

    thetaInit = SBPInitParam(ae);
    [stack{l}.thetaAE, ~] = SBPTrain(thetaInit, ae, stack{l}.data, stack{l}.target);
    
    % extract encoder parameter
    encoder.layerSize = ae.layerSize(1:2);
    encoder.hasBias = ae.hasBias(1);
    encoder.f = ae.f(1);
    paramStack = paramUnfold(stack{l}.thetaAE, encoder);
    stack{l}.theta = paramFold(paramStack(1), encoder);
    theta = cat(1, theta, stack{l}.theta);
    
    % generate data for next level
    if isfield(network.minOptions, 'streamReader')
        stack{l}.data = network.minOptions.streamReader(stack{l}.data, 0, []);
    end
    stack{l+1}.data = SBPFeedforward(stack{l}.theta, stack{l}.data, encoder, []);
    if isfield(network.minOptions, 'streamReader')
        stack{l+1}.data = network.minOptions.streamReader(stack{l+1}.data, 1, []);
    end

    stack{l+1}.target = stack{l+1}.data;
end

feature = stack{depth+1}.data;