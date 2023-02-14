a = 20;
b = 220;
n = round(logspace(1,4,41));
true_answer = -173.27109569427105304560860696691;

h = zeros(length(n),1);
errorr  = zeros(length(n),1);
for ii = 1:length(n)
    x = linspace(a,b,n(ii));
    y = funct1(x);
    h(ii) = (b-a)/(n(ii)-1);
    integ_trap = 0.5*h(ii)*(2*sum(y)-y(1)-y(end));
    errorr(ii) = abs((true_answer-integ_trap)/true_answer);
end

figure(2);
loglog(h, errorr,'-o'); 
grid on;
xlabel('h');
ylabel('Error');
print -dpng figure3_h_vs_error

slope = (log(errorr(end))-log(errorr(1)))/(log(h(end))-log(h(1)));
disp(['Slope = ' num2str(slope)])