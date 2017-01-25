function [cost, grad, c] = SBPCost(theta, network, x, y)

% ---- begin memory patch
if isfield(network,'stage') && network.stage == 1
    count = size(x,2);
    rp = randperm(count);
    x = x(:, rp(1:(count * 1)));
    y = y(:, rp(1:(count * 1)));
end
% ---- end memory patch

% context
c = struct();
c.network = network;

% extract parameters
c.paramStack = paramUnfold(theta, network);

% ff
[c.h, c.dataStack] = SBPFeedforward(c.paramStack, x, network, c);

% cost
c.cost = network.cost.f(c.h, y, network, c);
c = runHook('after_cost_cost', [], network, c );

% BP
c.gradStack = SBPFeedback(c.paramStack, c.dataStack, c.h, y, c.cost, network, c);

% gather
c.grad = paramFold(c.gradStack, network);

% result
cost = c.cost;
grad = c.grad;
end
