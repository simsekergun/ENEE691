clear;
%  TRUE ANSWER:  x = [1.9120, 1.2640];
x0 = [1, 1];        %  initial guess
lb = [0.1, 0.1];    % lower boundary
ub = [2, 2];        % lower boundary


% Surrogate Algorithm
x_surrogate = surrogateopt(@get_current_costx,lb,ub)


% % Bayesian Optimization
% var1 = optimizableVariable('x1',[0.1,2]);
% var2 = optimizableVariable('x2',[0.1,2]);
% vars = [var1,var2];
% results = bayesopt(@get_current_cost_bayesian,vars)


% % Covariance Matrix
% x_cma=cma(@get_current_costx,length(x0), 0.1, 2, 300)
% 
% % Powell's Method
% [x_powell,Ot,nS]=powell(@get_current_costx,x0,0,[],lb,ub,[],[],300);
% 
% 
% % Genetic Algorithm
% x_ga = ga(@get_current_costx,2,[],[],[],[],lb,ub,[],[])
% 
% % Particle Swarm
% options = optimoptions('particleswarm','SwarmSize',400,'HybridFcn',@fmincon);
% x_pso = particleswarm(@get_current_costx,2,lb,ub,options)
% 
% % Gradient Descent
% x_fmin = fmincon(@get_current_costx,x0,[],[],[],[],lb,ub,[])
% % [x_fmin,fval,exitflag,output,lambda,grad,hessian] = fmincon(@get_current_costx,x0,[],[],[],[],lb,ub,[])
% 
% % Nelder Mead
% x_NM = gbnm(@get_current_costx,lb.',ub.')
% 
% [minimum,fval] = anneal(@get_current_costx, x0)
% 
% % Print out the costs
% cost_ga = get_current_costx(x_ga)
% cost_pso = get_current_costx(x_pso)
% cost_fmin = get_current_costx(x_fmin)
% cost_NM = get_current_costx(x_NM)
% cost_annealing = fval;
% 
% % Tasks
% % 1. Change the ub and lb, compare the performances
% % 2. What happens when you change the initial guess?
% % 3. Change the number of swarms!