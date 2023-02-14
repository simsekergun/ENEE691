clear;
% Set the default values and formats
set(0,'defaultlinelinewidth',3);
set(0,'DefaultAxesFontSize',24);
set(0,'DefaultTextFontSize',24);


load dataset1; % loads the "dataset1" 
               % where the columns are x and f(x) 
x = dataset1(:,1);
y = dataset1(:,2);

initial_guess = [20 60 80 2 5];
approx_alphas = fsolve(@(coeffs)funct3(x,coeffs)-y,initial_guess)

y_estimate = funct3(x,approx_alphas);

figure(2); clf;
plot(x,y,x,y_estimate,'ro'); grid on;
xlabel('x');
ylabel('f(x)');
legend('True Values','Approximated Values','Location','SouthWest')
print -dpng figure2_true_vs_estimate

options = optimoptions('fsolve',...
    'Display','iter',...
    'PlotFcn',@optimplotfirstorderopt);
approx_alphas = fsolve(@(coeffs)funct3(x,coeffs)-y,initial_guess,options)

options2 = optimoptions('fsolve','FiniteDifferenceType','central',...
    'FunctionTolerance',1e-9,...
    'Display','iter',...
    'PlotFcn',@optimplotfirstorderopt);
approx_alphas = fsolve(@(coeffs)funct3(x,coeffs)-y,initial_guess,options2)
