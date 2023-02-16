function [Xdc dX] = dcsolve(Xguess,maxerr)
% Compute dc solution using newtwon iteration
% input: Xguess is the initial guess for the unknown vector. 
%        It should be the correct size of the unknown vector.
%        maxerr is the maximum allowed error. Set your code to exit the
%        newton iteration once the norm of DeltaX is less than maxerr
% Output: Xdc is the correction solution
%         dX is a vector containing the 2 norm of DeltaX used in the 
%         newton Iteration. the size of dX should be the same as the number
%         of Newton-Raphson iterations. See the help on the function 'norm'
%         in matlab. 
global G C b DIODE_LIST  npnBJT_LIST

sz = length(G);
dX = [];

error_tolerable = false;

iteration = 0;

% slides B00
while (~error_tolerable)
    iteration = iteration +1;
    
    f = f_vector(Xguess);
    
    phi = G * Xguess + f - b;

    J = nlJacobian(Xguess);   
    
    disp(f);

    delta_x = -1 * J \  phi; 
    
    Xguess = Xguess + delta_x;    
    
    if (norm(delta_x) <= maxerr)
        error_tolerable = true;
    end
    
    dX(iteration) = norm(delta_x);
     
end

Xdc = Xguess;
