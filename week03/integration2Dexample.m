clear;
clc;

fun = @(x,y) 1./( sqrt(x + y) .* (1 + x + y).^2 );

% Integrate over the rectangular region bounded by 0≤x≤1 and 0≤y≤0.5
% note the singularity at (0, 0)
q = integral2(fun,0,1,0,0.5);
disp(['Matlab integration: ' num2str(q)])

% quadrature formula!
[xi, wxi]=lgwt(32,0,1);     % 10 points along x
[yi, wyi]=lgwt(16,0,0.5);    % 6 points along y (since y range is half of x range)
[x, y] = meshgrid(xi,yi);
[wx, wy] = meshgrid(wxi,wyi);

figure(1); clf;
surf(x,y,fun(x,y)); hold on;
plot3(x,y,fun(x,y),'yo')
shading interp

int_quad = sum(sum(fun(x,y).*wx.*wy));

disp(['Legendre-Gauss: ' num2str(int_quad)])


