function [ hook_map ] = SBPKLSparse( options )
hook_map = {'after_cost_cost', @SBPKLSparse_after_cost, options;
            'after_feedback_grad_delta', @SBPKLSparse_after_grad_delta, options;
            };
end

function [ c ] = SBPKLSparse_after_cost( ~, ~, options, c ) %cost, network, options, c
% options.sparse = [ 0 0 0 1 ]; % specify for each layer

n = numel(options.sparse);
for i = 1:n
    if options.sparse(i)
        % rho_h = mean(a2,2);
        rho_h = mean(c.dataStack{i}.a,2);
        
        % KL = sum(sparsityParam .* log(sparsityParam./rho_h) ...
        %     + (1 - sparsityParam) .* log((1-sparsityParam)./(1-rho_h)));
        KL = sum(options.rho .* log(options.rho ./ rho_h) ...
            + (1 - options.rho) .* log((1 - options.rho) ./ (1 - rho_h)));
        
        c.cost = c.cost + options.beta .* KL;
    end
end

end

function [ c ] = SBPKLSparse_after_grad_delta( l, ~, options, c ) %cost, network, options, c
% options.sparse = [ 0 0 0 1 ]; % specify for each layer

if options.sparse(l)
    rho_h = mean(c.dataStack{l}.a,2);
    sparse_trick = (-options.rho ./ rho_h + (1-options.rho) ./ (1 - rho_h));
    sparse_trick = sparse_trick ./ size(c.h,2);
    % replace delta!
    % delta2 = (W2' * delta3 + repmat(beta * spars_trick, 1, m)) .* df2;
    c.dataStack{l}.delta = (bsxfun(@plus, c.paramStack{l}.w' * c.dataStack{l+1}.delta , options.beta .* sparse_trick)) .* c.dataStack{l}.df;
end

end