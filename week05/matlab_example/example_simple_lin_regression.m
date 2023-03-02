clear;

load PIN_designs % ths dps1 dps2 Qs Ds Is Ps RFPs

x = Ps;
y = Ds;

X = [ones(length(x),1) x];
b = X\y;

y_calc = X*b;

Rsquare = 1 - sum((y - y_calc).^2)/sum((y - mean(y)).^2)
aline = [min(y) max(y)];

figure(1); clf;
plot(y,y_calc,'ro',aline,aline,'k--');
grid on;
axis equal;
axis square;
xlabel('Ground Truth');
ylabel('Prediction');
title(['{{\it{R}}^2: }' num2str(round(1000*Rsquare)/1000)])
