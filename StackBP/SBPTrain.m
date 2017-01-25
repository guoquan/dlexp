function [optTheta, cost] = SBPTrain(theta, network, x, y)

%--- default
options.Method = 'lbfgs';
options.maxIter = 100;
options.display = 'iter'; % Level of display [ off | final | (iter) | full | excessive ]

%--- fill with configured option
if isfield(network, 'minOptions')
    f_list = fieldnames(network.minOptions);
    for i=1:length(f_list)
        f = f_list{i};
        options.(f) = network.minOptions.(f);
    end
end

%--- case
if strcmp('sgd', options.Method)
	[optTheta, cost] = SGDmin( @(p, xi, yi) SBPCost(p, network, xi, yi), ...
                                theta, x, y, options);
else
    [optTheta, cost] = minFunc( @(p) SBPCost(p, network, x, y), ...
                                theta, options);
end

%{
maxep = 100;
eta = 0.1;
i_ep = 1;
while i_ep <= maxep
    cost_sum = 0;
    for i_sample = 1:m
        [cost, grad] = SBPCost(theta,layer_size,{@sigmoid, @(x) x },{@dsigmoid, @(~) 1},x(i_sample),y(i_sample));
        theta = theta - eta * grad;
        cost_sum = cost_sum + cost;
    end
    if cost_sum / m < 1e-3
        break;
    end
    fprintf('%8d%16e\n',i_ep,cost_sum / m);
    i_ep = i_ep + 1;
end
%}