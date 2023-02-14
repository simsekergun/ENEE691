% Solution of Question 2 
clear;
% Set the default values and formats
set(0,'defaultlinelinewidth',3);
set(0,'DefaultAxesFontSize',24);
set(0,'DefaultTextFontSize',24);

% PART A
disp('*********** PART A ************')
% disp('Root 1:')
a = 50;
b = 80;
tol = 1e-12;
x = my_bisection(@(x) funct1(x), a, b, tol);

% print
disp(['Target x = ' num2str(x)])
% check the output
disp(['f(x) = ' num2str(funct1(x))])

% disp('Root 2:')
a = 130;
b = 150;
tol = 1e-12;
x = my_bisection(@(x) funct1(x), a, b, tol);

% print
disp(['Target x = ' num2str(x)])
% check the output
disp(['f(x) = ' num2str(funct1(x))])

% PART B
disp('*********** PART B ************')
a = 90;
b = 110;
tol = 1e-12;
x = my_bisection(@(x) diff_funct1(x), a, b, tol);

% print
disp(['Target x = ' num2str(x)])
% check the output
disp(['f(x) = ' num2str(funct1(x))])