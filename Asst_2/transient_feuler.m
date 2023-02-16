

function [tpoints,r] = transient_feuler(t1,t2,h,out)
% [tpoints,r] = Transient_feuler(t1,t2,h,out)
% Perform Transient analysis for LINEAR circuit using Forward Euler
% This function assumes the C matrix is invertible and will not work 
% for circuits where C is not invertible.
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

r = [];

eigenvalue = eig (-C \ G)

tpoints = t1:h:t2;

sz = length(tpoints);
%for speed
r = zeros (size(sz));
% assume initials are 0
x_n = zeros(length(G));
    
% from 1 till n-1
for i = 1:(sz - 1)
    % slide E00 24/54
    % xn+1 = inv (C/h) * (bn - (G-C/h) * xn)
    x_n = (C / h) \ (BTime(tpoints(i)) - (G - C / h) * x_n);

    %xn+1
    r(i+1) = x_n(out);
end

end

