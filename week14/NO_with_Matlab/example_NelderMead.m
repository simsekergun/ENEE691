clear;
% This code uses the Nelder Mead simplex algorithm (gbnm.m) to find x1
% and x2 values that minimize the cost function "get_current_costx"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % upper boundary

% Nelder Mead
% Note that boundaries need to be vectors..
x_NM = optimize_NelderMead(@get_current_cost,lb.',ub.')

Error = sqrt((x_NM(1)-1.9120).^2+ (x_NM(2)-1.2640).^2)
