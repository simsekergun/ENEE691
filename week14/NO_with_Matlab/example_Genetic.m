clear;
% This code uses Matlab's own Genetic Optimization algorithm to find x1
% and x2 values that minimize the cost function "get_current_costx"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % upper boundary


% Genetic Algorithm
x_ga = ga(@get_current_cost,2,[],[],[],[],lb,ub,[],[])

Error = sqrt((x_ga(1)-1.9120).^2+ (x_ga(2)-1.2640).^2)