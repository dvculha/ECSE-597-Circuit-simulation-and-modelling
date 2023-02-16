function Xdc = dcsolvealpha(Xguess,alpha,maxerr)
% Compute dc solution using newtwon iteration for the augmented system
% G*X + f(X) = alpha*b
% Inputs: 
% Xguess is the initial guess for Newton Iteration
% alpha is a paramter (see definition in augmented system above)
% maxerr defined the stopping criterion from newton iteration: Stop the
% iteration when norm(deltaX)<maxerr
% Oupputs:
% Xdc is a vector containing the solution of the augmented system

global G C b DIODE_LIST npnBJT_List


converged = false;

delta_x = 1234567890;

% slides B45/48
while (norm(delta_x) >= maxerr)
    
    f = f_vector(Xguess);
    
    disp ('f=');
    disp (f);
        
    phi = G * Xguess + f - alpha * b;


    J = nlJacobian(Xguess); 
        
    disp ('J=');
    disp(J);
    

    delta_x = -1 * J \ phi; 
    
    Xguess = Xguess + delta_x;   
    
        
    disp ('Xdc=');
    disp(Xguess);
    
  %  if (delta_x >= maxerr)
   %     converged = true;
    %end
    
end

Xdc = Xguess;
