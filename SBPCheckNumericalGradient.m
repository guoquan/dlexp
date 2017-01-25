clear
include
% This code can be used to check your numerical gradient implementation 
% in computeNumericalGradient.m
% It analytically evaluates the gradient of a very simple function called
% simpleQuadraticFunction (see below) and compares the result with your numerical
% solution. Your numerical gradient implementation is incorrect if
% your numerical solution deviates too much from the analytical solution.

% Evaluate the function and gradient
m = 10;
intvl = [-2 2];

x = intvl(1):((intvl(2)-intvl(1))/(m-1)):intvl(2);
y = 0 + sin(pi * x);

% network config
network.layerSize = [1 20 1];
network.hasBias = [1 1 1];
network.f = {getSigmoid, getSigmoid};
network.cost = getBatchBPCost;

% lambda = 3e-3;         % weight decay parameter
wd_opt.decay = [1 0];
wd_opt.lambda = 3e-3;
network = addHook( SBPWeightDecay(wd_opt), network );

% sparsityParam = 0.035; % desired average activation of the hidden units.
% beta = 5;              % weight of sparsity penalty term     
sparse_opt.sparse = [0 1 0];
sparse_opt.rho = 0.035;
sparse_opt.beta = 5;
network = addHook( SBPKLSparse(sparse_opt), network );

theta = SBPInitParam(network);

[value, grad] = SBPCost(theta, network, x, x);
value

% Use your code to numerically compute the gradient of simpleQuadraticFunction at x.
% (The notation "@simpleQuadraticFunction" denotes a pointer to a function.)
%numgrad = computeNumericalGradient(@simpleQuadraticFunction, x);
numgrad = computeNumericalGradient(@(t)SBPCost(t, network, x, x), theta);

% Visually examine the two gradient computations.  The two columns
% you get should be very similar. 
disp([numgrad grad numgrad-grad]);
fprintf('The above two columns you get should be very similar.\n(Left-Your Numerical Gradient, Right-Analytical Gradient)\n\n');

% Evaluate the norm of the difference between two solutions.  
% If you have a correct implementation, and assuming you used EPSILON = 0.0001 
% in computeNumericalGradient.m, then diff below should be 2.1452e-12 
diff = norm(numgrad-grad)/norm(numgrad+grad);
disp(diff); 
fprintf('Norm of the difference between numerical and analytical gradient (should be < 1e-9)\n\n');