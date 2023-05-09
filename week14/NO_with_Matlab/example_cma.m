clear;
% This code uses cma.m to find x1 and x2 values that minimize 
% the cost function "get_current_costx"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % upper boundary


% % Covariance Matrix
x_cma=optimize_CMA(@get_current_cost,length(x0), 0.1, 2, 300)

Error = sqrt((x_cma.Position(1)-1.9120).^2+ (x_cma.Position(2)-1.2640).^2)