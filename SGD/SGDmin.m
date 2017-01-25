function [ theta, cost, exitflag, exitmsg ] = SGDmin( func, theta, x_stream, y_stream, options )
%MINGD Summary of this function goes here
%   Detailed explanation goes here

eta = getOpt(options, 'eta', 1);

minBatchSize = getOpt(options, 'minBatchSize', 100);
momentum= getOpt(options, 'momentum', 0.8);
%{
% this statement should be valid anonymous function with multiple output in
% R2013B but may not be valid in previous versions
streamReader = getOpt(options, 'streamReader', @(x,f,n) ( ...
                                                            ([x(:, (f + 1):(min(f + n,end))) x(:, 1:(f + n - end))]), ...
                                                            (mod(f + n, size(x, 2))) ...
                                                        ));
%}
streamReader = getOpt(options, 'streamReader', @SGDStreamRead);

maxIter = getOpt(options, 'maxIter', 800);
tolGrad = getOpt(options, 'tolGrad', 1e-5);
tolCost = getOpt(options, 'tolCost', 1e-9);
minCost = getOpt(options, 'minCost', 1e-9);
display = getOpt(options, 'display', 'iter'); % Level of display [ off | final | (iter) | full | excessive ]

if strcmp('off', display)
    display = 0;
elseif strcmp('final', display)
    display = 1;
elseif strcmp('iter', display)
    display = 2;
elseif strcmp('full', display)
    display = 3;
elseif strcmp('excessive', display)
    display = 4;
else % defualt 'iter'
    display = 2;
end

if display >= 2
    fprintf('%10s %15s %15s\n','Iteration','Cost','Cost Chagne');
end

x_flag = 0; % 0 for initial state of a stream
y_flag = 0;
delta_theta = 0;
cost = 0;
cost_old = cost;
exitflag = 0;
i_ep = 0;
while i_ep < maxIter
    % continue
    cost_old = cost;
    i_ep = i_ep + 1;
    
    % get batch data from stream
    [x, x_flag] = streamReader(x_stream, x_flag, minBatchSize);
    [y, y_flag] = streamReader(y_stream, y_flag, minBatchSize);
    
    % calculate
    [cost, grad] = func(theta, x, y);
    
    % update
    % maybe the wrong momentum
    %theta = theta - eta * ((1 - momentum) * grad + momentum * grad_old);
    %grad_old = grad;
    
    % momentum bp from Rumelhart, David E. and Hinton, Geoffrey E. and Williams, Ronald J., Learning Internal Representations by Error Propagation
    %delta_theta = eta * grad + momentum * delta_theta;
    %theta = theta - delta_theta;
    
    % momentum bp from Martin T. Hagan and Howard B. Demuth and Mark H. Beale, Neural Network Design
    delta_theta = ((1 - momentum) * (- eta) * grad + momentum * delta_theta);
    theta = theta + delta_theta;
    
    % display
    if display >= 2
        fprintf('%10d %15.5e %15.5e\n',i_ep, cost, cost-cost_old);
    end
    
    % end
    if sum(abs(grad)) <= tolGrad
        exitflag=1;
        exitmsg = ['Gradiant norm below tolGrad(' num2str(tolGrad) ')'];
        break;
    end
    
    if abs(cost-cost_old) <= tolCost
        exitflag=2;
        exitmsg = ['Cost change below tolCost(' num2str(tolCost) ')'];
        break;
    end
    
    if cost <= minCost
        exitflag=3;
        exitmsg = ['Cost below minCost(' num2str(tolCost) ')'];
        break;
    end
    
end

if ~exitflag
    exitmsg='Exceeded Maximum Number of Iterations';
end

if display >= 1
    fprintf('%10s %15s %15s\n','Iteration','Cost','Cost Chagne');
	fprintf('%10d %15.5e %15.5e\n',i_ep, cost, cost-cost_old);
    disp(exitmsg);
end
end

function [v] = getOpt(options,opt,default)
if isfield(options,opt) && ~isempty(options.(opt))
    v = options.(opt);
else
    v = default;
end
end
