function cost = get_current_cost(x)
[mx, nx] = size(x);
if nx == 1
    L = x(1);
    D = x(2);
else
    L = x(:,1);
    D = x(:,2);
end
Q = log10(1+abs(L))+sqrt(L)+2*exp(-(D.*L-1).^2/2/4);
BW = exp(-(D-1).^2/2/4)+L.^0.25;
PN = BW./Q.^0.5+log(D+Q/3);
cost = (40*exp(-abs(L-1.4)).*exp(-abs(D-1.6))+30*exp(-abs(L-1.912)).*exp(-abs(D-1.264)).*(PN./Q.*BW-2+10*exp(-(D.*L-1).^2/2/4)+10*exp(-((D-2.4).*(L-3)).^2/2/4)).*cos(L/2/pi).*cos(D/2/pi));

cost = 510-abs(cost)-62.4443;
