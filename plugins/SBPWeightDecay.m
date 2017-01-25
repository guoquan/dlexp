function [ hook_map ] = SBPWeightDecay( options )
hook_map = {'after_cost_cost', @SBPWeightDecay_after_cost, options;
            'after_feedback_grad_w', @SBPWeightDecay_after_grad_w, options};
end

function [ c ] = SBPWeightDecay_after_cost( ~, ~, options, c ) %cost, network, options, c
% options.decay = [ 0 0 0 1 ]; % specify for each layer
n = numel(c.paramStack);
for i = 1:n
    if options.decay(i) % && isfield(c.paramStack{i},'w') && ~isempty(c.paramStack{i}.w)
        c.cost = c.cost + options.lambda .* sum(c.paramStack{i}.w(:).^2) / 2;
    end
end

end

function [ c ] = SBPWeightDecay_after_grad_w( l, ~, options, c ) %cost, network, options, c
% options.decay = [ 0 0 0 1 ]; % specify for each layer

if options.decay(l)
    c.gradStack{l}.w = c.gradStack{l}.w + options.lambda .* c.paramStack{l}.w;
end

end