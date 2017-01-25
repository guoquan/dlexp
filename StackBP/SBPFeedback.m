function [gradStack] = SBPFeedback(param, dataStack, h, y, cost, network, c)

if ~iscell(param)
    param = paramUnfold(param, network);
end

% prepare input
c.paramStack = param;
c.dataStack = dataStack;

depth = numel(network.layerSize) - 1;

c.gradStack = cell(size(c.paramStack));

% depth + 1
c.dataStack{depth + 1}.df = network.f{depth}.d(c.dataStack{depth+1}.z, c.dataStack{depth+1}.a, c);
c.dataStack{depth + 1}.delta = network.cost.d(h, y, cost, network, c) .* c.dataStack{depth + 1}.df;
c = runHook('after_feedback_grad_delta', depth + 1, network, c );
% depth -> 2
for l = depth:-1:2
    c.gradStack{l}.w = c.dataStack{l + 1}.delta * c.dataStack{l}.a';
    c = runHook('after_feedback_grad_w', l, network, c );
    if network.hasBias(l)
        c.gradStack{l}.b = sum(c.dataStack{l + 1}.delta, 2);
    end
    c.dataStack{l}.df = network.f{l-1}.d(c.dataStack{l}.z, c.dataStack{l}.a, c);
    c.dataStack{l}.delta = (c.paramStack{l}.w' * c.dataStack{l+1}.delta) .* c.dataStack{l}.df;
    c = runHook('after_feedback_grad_delta', l, network, c );
end
% 1
c.gradStack{1}.w = c.dataStack{2}.delta * c.dataStack{1}.a';
c = runHook('after_feedback_grad_w', 1, network, c );
if network.hasBias(1)
    c.gradStack{1}.b = sum(c.dataStack{2}.delta, 2);
end

% prepare output
gradStack = c.gradStack;

end
