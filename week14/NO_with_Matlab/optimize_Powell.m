function [xo,Ot,nS]=powell(S,x0,ip,method,Lb,Ub,problem,tol,mxit)
%   Unconstrained optimization using Powell.
%
%   [xo,Ot,nS]=powell(S,x0,ip,method,Lb,Ub,problem,tol,mxit)
%
%   S: objective function
%   x0: initial point
%   ip: (0): no plot (default), (>0) plot figure ip with pause, (<0) plot figure ip
%   method: (0) Coggins (default), (1): Golden Section
%   Lb, Ub: lower and upper bound vectors to plot (default = x0*(1+/-2))
%   problem: (-1): minimum (default), (1): maximum
%   tol: tolerance (default = 1e-4)
%   mxit: maximum number of stages (default = 50*(1+4*~(ip>0)))
%   xo: optimal point
%   Ot: optimal value of S
%   nS: number of objective function evaluations
%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/07 21:10:15 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)
 if nargin < 2,
   error('powell requires two input arguments');
 end
 if nargin < 3 | isempty(ip),
   ip=0;
 end
  if nargin < 4 | isempty(method),
   method=0;
 end
 if nargin < 5 | isempty(Lb),
   Lb=-x0-~x0;
 end
 if nargin < 6 | isempty(Ub),
   Ub=2*x0+~x0;
 end
 if nargin < 7 | isempty(problem),
   problem=-1;
 end
 if nargin < 8 | isempty(tol),
   tol=1e-4;
 end
 if nargin < 9 | isempty(mxit),
   mxit=50*(1+4*~(ip>0));
 end
 x0=x0(:);
 y0=feval(S,x0)*problem;
 n=size(x0,1);
 D=eye(n);
 ips=ip;
  
 if ip & n == 2,
   figure(abs(ip));
   [X1,X2]=meshgrid(Lb(1):(Ub(1)-Lb(1))/20:Ub(1),Lb(2):(Ub(2)-Lb(2))/20:Ub(2));
   [n1,n2]=size(X1);
   f=zeros(n1,n2);
   for i=1:n1,
    for j=1:n2,
      f(i,j)=feval(S,[X1(i,j);X2(i,j)]);
    end
   end
   mxf=max(max(f));
   mnf=min(min(f));
   df=mnf+(mxf-mnf)*(2.^(([0:10]/10).^2)-1);
   [v,h]=contour(X1,X2,f,df); hold on;
%   clabel(v,h);
   h1=plot(x0(1),x0(2),'ro');
   legend(h1,'start point');
   if ip > 0,
     ips=ip+1;
     disp('Pause: hit any key to continue...'); pause;
   else
     ips=ip-1;
   end
 end
 
 xo=x0;
 yo=y0;
 it=0;
 nS=1;
 
 while it < mxit,
                     % exploration
  delta=0;
  for i=1:n,
     if method,           % to see the linesearch plot, remove the two 0* below
       [stepsize,x,Ot,nS1]=aurea(S,xo,D(:,i),0*ips,problem,tol,mxit);
       Ot=Ot*problem;
     else
       [stepsize,x,Ot,nS1]=coggins(S,xo,D(:,i),0*ips,problem,tol,mxit);
       Ot=Ot*problem;
     end
     
     nS=nS+nS1;
     di=Ot-yo;
     if di > delta,
       delta=di;
       k=i;
     end
     if ip & n == 2,
       plot([x(1) xo(1)],[x(2) xo(2)],'r');
       if ip > 0,
         disp('Pause: hit any key to continue...'); pause;
       end
     end
     yo=Ot;
     xo=x;
  end
                  % progression
  it=it+1;
  xo=2*x-x0;
  Ot=feval(S,xo)*problem;
  nS=nS+1;
  di=y0-Ot;
  j=0;
  if di >= 0 | 2*(y0-2*yo+Ot)*((y0-yo-delta)/di)^2 >= delta,
    if Ot >= yo,
      yo=Ot;
    else
      xo=x;
      j=1;
    end
  else
    if k < n,
      D(:,k:n-1)=D(:,k+1:n);
    end
    D(:,n)=(x-x0)/norm(x-x0);
    if method,           % to see the linesearch plot, remove the two 0* below
      [stepsize,xo,yo,nS1]=aurea(S,x,D(:,n),0*ips,problem,tol,mxit);
      yo=yo*problem;
    else
      [stepsize,xo,yo,nS1]=coggins(S,x,D(:,n),0*ips,problem,tol,mxit);
      yo=yo*problem;
    end
     
    nS=nS+nS1;
  end
  if ip & n == 2 & ~j,
    plot([x(1) xo(1)],[x(2) xo(2)],'r');
    if ip > 0,
      disp('Pause: hit any key to continue...'); pause;
    end
  end
  
  if norm(xo-x0) < tol*(0.1+norm(x0)) & abs(yo-y0) < tol*(0.1+abs(y0)),
    break;
  end
  y0=yo;
  x0=xo;
 end
 
 Ot=yo*problem;
 
 if it == mxit,
   disp('Warning Powell: reached maximum number of stages!');
 elseif ip & n == 2,
   h2=plot(xo(1),xo(2),'r*');
   legend([h1,h2],'start point','optimum');
 end




 function [stepsize,xo,Ot,nS]=coggins(S,x0,d,ip,problem,tol,mxit,stp)
%   Performs line search procedure for unconstrained optimization
%   using quadratic interpolation.
%
%   [stepsize,xo,Ot,nS]=coggins(S,x0,d,ip,problem,tol,mxit)
%
%   S: objective function
%   x0: initial point
%   d: search direction vector
%   ip: (0): no plot (default), (>0) plot figure ip with pause, (<0) plot figure ip
%   problem: (-1): minimum (default), (1): maximum
%   tol: tolerance (default = 1e-4)
%   mxit: maximum number of iterations (default = 50*(1+4*~(ip>0)))
%   stp: initial stepsize (default = 0.01*sqrt(d'*d))
%   stepsize: optimal stepsize
%   xo: optimal point in the search direction
%   Ot: optimal value of S in the search direction
%   nS: number of objective function evaluations
%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/04 21:20:15 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)
 
 if nargin < 3,
   error('coggins requires three input arguments');
 end
 if nargin < 4 | isempty(ip),
   ip=0;
 end
 if nargin < 5 | isempty(problem),
   problem=-1;
 end
 if nargin < 6 | isempty(tol),
   tol=1e-4;
 end
 if nargin < 7 | isempty(mxit),
   mxit=50*(1+4*~(ip>0));
 end
 d=d(:);
 nd=d'*d;
 if nargin < 8 | isempty(stp),
   stepsize=0.01*sqrt(nd);
 else
   stepsize=abs(stp);
 end
 x0=x0(:);
 [x1,x2,nS]=bracket(S,x0,d,problem,stepsize);
 z(1)=d'*(x1-x0)/nd;
 y(1)=feval(S,x1)*problem;
 z(3)=d'*(x2-x0)/nd;
 y(3)=feval(S,x2)*problem;
 z(2)=0.5*(z(3)+z(1));
 x=x0+z(2)*d;
 y(2)=feval(S,x)*problem;
 nS=nS+3;
 
 if ip,
   figure(abs(ip)); clf;
   B=sort([z(1),z(3)]);
   b1=0.05*(abs(B(1))+~B(1));
   b2=0.05*(abs(B(2))+~B(2));
   X1=(B(1)-b1):(B(2)-B(1)+b1+b2)/20:(B(2)+b2);
   n1=size(X1,2);
   for i=1:n1,
     f(i)=feval(S,x0+X1(i)*d);
   end   
   plot(X1,f,'b',X1(1),f(1),'g'); axis(axis); hold on;
   legend('S(x0+\alpha d)','P_2(x0+\alpha d)');
   xlabel('\alpha');
   plot([B(1),B(1)],[-1/eps 1/eps],'k');
   plot([B(2),B(2)],[-1/eps 1/eps],'k');
   plot(z,y*problem,'ro');
   if ip > 0,
     disp('Pause: hit any key to continue...'); pause;
   end
 end
 
 it=0;
 while it < mxit,
   a1=z(2)-z(3); a2=z(3)-z(1); a3=z(1)-z(2);
   if y(1)==y(2) & y(2)==y(3),
     zo=z(2);
     x=x0+zo*d;
     ym=y(2);
   else
     zo=.5*(a1*(z(2)+z(3))*y(1)+a2*(z(3)+z(1))*y(2)+a3*(z(1)+z(2))*y(3))/ ...
        (a1*y(1)+a2*y(2)+a3*y(3));
     x=x0+zo*d;
     ym=feval(S,x)*problem;
     nS=nS+1;
   end
   
   if ip,
     P2=-((X1-z(2)).*(X1-z(3))*y(1)/(a3*a2)+(X1-z(1)).*(X1-z(3))*y(2)/(a3*a1)+ ...
        (X1-z(1)).*(X1-z(2))*y(3)/(a2*a1))*problem;
     plot(X1,P2,'g');
     if ip > 0,
       disp('Pause: hit any key to continue...'); pause;
     end
     plot(zo,ym*problem,'ro');
   end
   for j=1:3,
    if abs(z(j)-zo) < tol*(0.1+abs(zo)),
      stepsize=zo;
      xo=x;
      Ot=ym*problem;
      
      if ip,
        plot(stepsize,Ot,'r*');
      end
      return;
    end
   end
   if (z(3)-zo)*(zo-z(2)) > 0,
     j=1;
   else
     j=3;
   end
    
   if ym > y(2),
     z(j)=z(2);
     y(j)=y(2);
     j=2;
   end
    
   y(4-j)=ym;
   z(4-j)=zo;
   it=it+1;
 end
 if it == mxit
  disp('Warning Coggins: reached maximum number of iterations!');
 end
 stepsize=zo;
 xo=x;
 Ot=ym*problem;

 function [x1,x2,nS]=bracket(S,x0,d,problem,stepsize)
%   Bracket the minimum (or maximum) of the objective function
%   in the search direction.
%
%   [x1,x2,nS]=bracket(S,x0,d,problem,stepsize)
%
%   S: objective function
%   x0: initial point
%   d: search direction vector
%   problem: (-1): minimum (default), (1): maximum
%   stepsize: initial stepsize (default = 0.01*norm(d))
%   [x1,x2]: unsorted lower and upper limits
%   nS: number of objective function evaluations
%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/04 21:45:10 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)
 if nargin < 3,
   error('bracket requires three input arguments');
 end
 if nargin < 4,
   problem=-1;
 end
 if nargin < 5,
   stepsize=0.01*norm(d);
 end
 d=d(:);
 x0=x0(:);
 j=0; nS=1;
 y0=feval(S,x0)*problem;
 
 while j < 2,
  x=x0+stepsize*d;
  y=feval(S,x)*problem;
  nS=nS+1;
  
  if y0 >= y,
    stepsize=-stepsize;
    j=j+1;
  else
    while y0 < y,
      stepsize=2*stepsize;
      y0=y;
      x=x+stepsize*d;
      y=feval(S,x)*problem;
      nS=nS+1;
    end  
    j=1;
    break;
  end
 end
 
 x2=x;
 x1=x0+stepsize*(j-1)*d;


 function [stepsize,xo,Ot,nS]=aurea(S,x0,d,ip,problem,tol,mxit,stp)
%   Performs line search procedure for unconstrained optimization
%   using golden section.
%
%   [stepsize,xo,Ot,nS]=aurea(S,x0,d,ip,problem,tol,mxit,stp)
%
%   S: objective function
%   x0: initial point
%   d: search direction vector
%   ip: (0): no plot (default), (>0) plot figure ip with pause, (<0) plot figure ip
%   problem: (-1): minimum (default), (1): maximum
%   tol: tolerance (default = 1e-4)
%   mxit: maximum number of iterations (default = 50*(1+4*~(ip>0)))
%   stp: initial stepsize (default = 0.01*sqrt(d'*d))
%   stepsize: optimal stepsize
%   xo: optimal point in the search direction
%   Ot: optimal value of S in the search direction
%   nS: number of objective function evaluations
%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/04 22:30:45 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)
 if nargin < 3,
   error('aurea requires three input arguments');
 end
 if nargin < 4 | isempty(ip),
   ip=0;
 end
 if nargin < 5 | isempty(problem),
   problem=-1;
 end
 if nargin < 6 | isempty(tol),
   tol=1e-4;
 end
 if nargin < 7 | isempty(mxit),
   mxit=50*(1+4*~(ip>0));
 end
 d=d(:);
 nd=d'*d;
 if nargin < 8 | isempty(stp),
   stepsize=0.01*sqrt(nd);
 else
   stepsize=abs(stp);
 end
 x0=x0(:);
 [x1,x2,nS]=bracket(S,x0,d,problem,stepsize);
 z(1)=d'*(x1-x0)/nd;
 z(2)=d'*(x2-x0)/nd;
 fi=.618033985;
 k=0;
 secao=fi*(z(2)-z(1));
 p(1)=z(1)+secao;
 x=x0+p(1)*d;
 y(1)=feval(S,x)*problem;
 p(2)=z(2)-secao;
 x=x0+p(2)*d;
 y(2)=feval(S,x)*problem;
 nS=nS+2;
 if ip,
   figure(abs(ip)); clf;
   c=['m','g'];
   B=sort([z(1),z(2)]);
   b1=0.05*(abs(B(1))+~B(1));
   b2=0.05*(abs(B(2))+~B(2));
   X1=(B(1)-b1):(B(2)-B(1)+b1+b2)/20:(B(2)+b2);
   n1=size(X1,2);
   for i=1:n1,
     f(i)=feval(S,x0+X1(i)*d);
   end   
   plot(X1,f,'b'); axis(axis); hold on;
   legend('S(x0+\alpha d)');
   xlabel('\alpha');
   plot([B(1),B(1)],[-1/eps 1/eps],'k');
   plot([B(2),B(2)],[-1/eps 1/eps],'k');
   plot(p,y*problem,'ro');
   if ip > 0,
     disp('Pause: hit any key to continue...'); pause;
   end
 end
 
 it=0;
 while abs(secao/fi) > tol & it < mxit,
   if y(2) < y(1),
     j=2; k=1;
   else
     j=1; k=2;
   end
   
   z(k)=p(j);
   p(j)=p(k);
   y(j)=y(k);
   secao=fi*(z(2)-z(1));
   p(k)=z(k)+(j-k)*secao;
   x=x0+p(k)*d;
   y(k)=feval(S,x)*problem;
   nS=nS+1;
   
   if ip,
     plot([z(k),z(k)],[-1/eps 1/eps],c(k));
     plot(p(k),y(k)*problem,'ro');
     if ip > 0,
       disp('Pause: hit any key to continue...'); pause;
     end
   end
   
   it=it+1;
 end
 stepsize=p(k);
 xo=x; 
 Ot=y(k)*problem;  
 if it == mxit
  disp('Warning Aurea: reached maximum number of iterations!');
 elseif ip,
   plot(stepsize,Ot,'r*');
 end