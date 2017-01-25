function [ c ] = runHook( hook_id, in, network, c )
%RUNHOOK Summary of this function goes here
%   Detailed explanation goes here
if isfield(network, 'hooks')
    if isfield(network.hooks, hook_id)
        n = numel(network.hooks.(hook_id));
        for i = 1:n
            c = network.hooks.(hook_id){i}.f(in, network, network.hooks.(hook_id){i}.opt, c);
        end
    end
end

end

