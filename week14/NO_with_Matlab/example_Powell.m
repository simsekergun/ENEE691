clear;
% This code uses optimize_Powell.m to find x1 and x2 values that minimize 
% the cost function "get_current_costx"
% 
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % upper boundary

% Powell's Method
[x_powell,Ot,nS]=optimize_Powell(@get_current_cost,x0,0,[],lb,ub,[],[],300);

Error = sqrt((x_powell(1)-1.9120).^2+ (x_powell(2)-1.2640).^2)