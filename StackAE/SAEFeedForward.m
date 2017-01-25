function [y, dataStack] = SAEFeedForward(theta, x, network, c)

encoder = getFeadForwardNetwork( network );

[y, dataStack] = SBPFeedforward(theta, x, encoder, c);