clear;
% This code uses Matlab's own Surrogate Optimization algorithm to find x1
% and x2 values that minimize the cost function "get_current_costx"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % lower boundary


% Surrogate Algorithm
x_surrogate = surrogateopt(@get_current_cost,lb,ub)

Error = sqrt((x_surrogate(1)-1.9120).^2+ (x_surrogate(2)-1.2640).^2)