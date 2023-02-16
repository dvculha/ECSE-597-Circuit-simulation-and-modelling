

function [tpoints,r] = transient_trapez(t1,t2,h,out)
% [tpoints,r] = Transient_trapez(t1,t2,h,out)
% Perform Transient Analysis using the Trapezoidal Rule for LINEAR
% circuits.
% assume zero initial condition.
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

r = [];

sz = length (tpoints);
%for speed
r = zeros (size(sz));
    
x_n = zeros(length(G), sz);
  

% from 1 till n-1
for i = 1:(sz - 1)
    % slide E00 28/54
    % xn+1 = inv ((G + 2 * C / h)) * (bn + bn+1 + (2C/h -G) * xn)
    x_n = (G + 2 * C / h) \ (BTime(tpoints(i)) + BTime(tpoints(i+1)) + (2 * (C / h) - G) * x_n);

    
    r(i+1) = x_n(out);
end
    
end

