function [ network ] = addHook( hook_map, network )
%ADDHOOK Summary of this function goes here
%   Detailed explanation goes here

if ~isfield(network, 'hooks')
    network.hooks = struct();
end

for i = 1:size(hook_map,1)
    key = hook_map{i,1};
    hook.f = hook_map{i,2};
    hook.opt = hook_map{i,3};
    if ~isfield(network.hooks, key)
        network.hooks.(key) = {};
    end
    network.hooks.(key) = [network.hooks.(key) hook];
end
end
