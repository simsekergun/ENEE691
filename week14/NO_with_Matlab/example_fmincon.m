clear;
% This code uses Matlab's fmincon algorithm to find x1
% and x2 values that minimize the cost function "get_current_costx"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % upper boundary

% Gradient Descent
x_fmin = fmincon(@get_current_cost,x0,[],[],[],[],lb,ub,[])

Error = sqrt((x_fmin(1)-1.9120).^2+ (x_fmin(2)-1.2640).^2)