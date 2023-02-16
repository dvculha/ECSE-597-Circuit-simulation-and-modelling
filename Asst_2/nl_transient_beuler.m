function [tpoints,r] = nl_transient_beuler(t1,t2,h,out)
% [tpoints,r] = beuler(t1,t2,h,out)
% Perform transient analysis for NONLINEAR Circuits using Backward Euler
% Assume zero initial condition.
% Inputs:  t1 = starting time point (typically 0)
%          t2 = ending time point
%          h  = step size
%          out = output node
% Outputs  tpoints = are the time points at which the output
%                    was evaluated
%          r       = value of the response at above time points
% plot(tpoints,r) should produce a plot of the transient response
 
    global G C b
 
    tpoints = t1:h:t2;
    
    maxerr = 1e-6;
    r = [];
    
    % assume initials are 0
    sz = length (b);
    x_0 = zeros(sz);
    x_n = zeros(sz);
    
   
        
    iteration = 0;
for i = tpoints
    error_tolerable = false;
    
    iteration = iteration + 1;
    while(~error_tolerable)
        % f vector
        f = f_vector(x_n);
        % Jacobian
        J = nlJacobian(x_n);
        
        % Slides G00 33/45
        % 0 = fn+1 + (G + C / h) * xn+1 - bn+1 - (C / h) * xn
        % xn = x_0
        % xn+1 = x_n
        phi = f + (G + C / h) * x_n - BTime(i + h) - (C / h) * x_0 ;  
        % delta phi
        d_p = G + (C / h) + J;
        
        %delta x = - inv(delta phi) * phi
        d_x = - d_p \ phi;
        
        % new point
        x_n = x_n + d_x;
        
        % error
        err = norm(d_x);
        
        if (abs(err) <= maxerr)
            error_tolerable = true;
        end
        
    end
    
    %r = [r;x_n(out)]; 
    r(iteration) = x_n(out); 
    x_0 = x_n;
end

