clear;

n = 200;
L = linspace(0.1, 3, n);
D = linspace(0.1, 3, n);
[Ls, Ds] = meshgrid(L,D);

cost = reshape(get_current_cost([Ls(:) Ds(:)]),n,n);

figure(1); clf;
pcolor(D,L,cost); shading interp; colorbar;
xlabel('x_1');
ylabel('x_2');
colorbar;
