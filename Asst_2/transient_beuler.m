

function [tpoints,r] = transient_beuler(t1,t2,h,out)
% [tpoints,r] = beuler(t1,t2,h,out)
% Perform transient analysis for LINEAR Circuits using Backward Euler
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

% tpoints is a vector containing all the timepoints from t1 to t2 with step
% size h
tpoints = t1:h:t2;

%r = [];
%r = zeros (size(sz)
sz = length(tpoints);
r = zeros (size(sz));

% assume initials are 0
x_n = zeros(length(G));


% from 1 till n-1
for i = 1:(sz-1)
    % slide E00 24/54
    % xn+1 = inv (G+C/h) * (bn+1 + (C/h) * xn)
    x_n = (G + C / h) \ (BTime(tpoints(i)) + (C / h) * x_n);

    r(i+1) = x_n(out);
end

end
