function Xdc = dcsolvecont(n_steps,maxerr)
% Compute dc solution using newtwon iteration and continuation method
% (power ramping approach)
% inputs:
% n_steps is the number of continuation steps between zero and one that are
% to be taken. For the purposes of this assigments the steps should be 
% linearly spaced (the matlab function "linspace" may be useful).
% maxerr is the stopping criterion for newton iteration (stop iteration
% when norm(deltaX)<maxerr


global G C b DIODE_LIST npnBJT_List

% Slides C00 10/15
sz = length(G);
Xdc = zeros(sz, 1);  
%y = linspace(x1,x2,n) generates n points. The spacing between the points is (x2-x1)/(n-1).
steps = linspace(0,1,n_steps);

for i = 1 : n_steps
    Xdc = dcsolvealpha(Xdc, steps(i), maxerr);
end
