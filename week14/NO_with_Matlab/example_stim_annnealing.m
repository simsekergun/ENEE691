clear;
% This code uses Matlab's fmincon algorithm to find x1
% and x2 values that minimize the cost function "get_current_costx"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % upper boundary

[minimum,fval] = optimize_Stim_Anneal(@get_current_cost, x0)

Error = sqrt((minimum(1)-1.9120).^2+ (minimum(2)-1.2640).^2)