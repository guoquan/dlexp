function theta = SBPInitParam( network )

theta = [];
%s = RandStream('mt19937ar','Seed',0);

depth = numel(network.layerSize)-1;
for l = 1:depth
    r  = sqrt(6) / sqrt(network.layerSize(l+1) + network.layerSize(l) + 1);
    %w = rand(s,network.layerSize(l+1), network.layerSize(l)) * 2 * r - r;
    w = rand(network.layerSize(l+1), network.layerSize(l)) * 2 * r - r;
    theta = cat(1, theta, w(:));
    if network.hasBias(l)
        b = zeros(network.layerSize(l+1),1);
        theta = cat(1, theta, b(:));
    end
end

end

