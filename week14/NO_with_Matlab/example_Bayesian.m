clear;
% This code uses Matlab's own Bayesian Optimization algorithm to find x1
% and x2 values that minimize the cost function "get_current_cost_bayesian"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];

var1 = optimizableVariable('x1',[0.1,2]);  % name of the variable and range
var2 = optimizableVariable('x2',[0.1,2]);  % name of the variable and range
vars = [var1,var2];                                   % variables

results = bayesopt(@get_current_cost_bayesian,vars)


Error = sqrt((results.XAtMinObjective.x1-1.9120).^2+ (results.XAtMinObjective.x2-1.2640).^2)