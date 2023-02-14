function m = my_bisection(f, a, b, tol)
% approximates a root, R, of f bounded
% by a and b to within tolerance
% | f(m) | < tol with m the midpoint
% between a and b Recursive implementation

% check if a and b bound a root
if (sign(f(a)) == sign(f(b)))
    disp('Error: Sings must be opposite!!')
else
    % get midpoint
    m = (a + b)/2;
    if abs(f(m)) < tol
        % stopping condition, report m as root
        return        
    elseif sign(f(a)) == sign(f(m))
        % case where m is an improvement on a.
        % Make recursive call with a = m
        m = my_bisection(@(x) f(x), m, b, tol);
    elseif sign(f(b)) == sign(f(m))
        % case where m is an improvement on b.
        % Make recursive call with b = m
        m = my_bisection(@(x) f(x), a, m, tol);
    end    
end