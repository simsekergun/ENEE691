function y = diff_funct1(xp)
h = xp/100;
x = [xp-h xp+h];
% calculate y at these two points
yy = funct1(x);
% central differentiation
y = diff(yy)/2/h;
