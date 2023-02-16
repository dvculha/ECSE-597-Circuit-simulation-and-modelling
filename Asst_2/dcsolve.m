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


global G C b DIODE_LIST

node_i = DIODE_LIST.node1;
node_j = DIODE_LIST.node2;
Is = DIODE_LIST.Is;
Vt = DIODE_LIST.Vt;


sz = size (G, 1);

%Xdc is the vector of correction solution
Xdc = zeros(sz, 1); 

% dX is a vector containing the 2 norm of DeltaX used in the 
% newton Iteration. the size of dX should be the same as the number
% of Newton-Raphson iterations.
dX = zeros(sz, 1); 

% f_x vector
f = zeros(sz, 1);
 
% boolean to end the while loop
error_tolerable = false; 
iteration = 0;

while (~error_tolerable)
    iteration = iteration + 1;
    % f_x = Is*(exp(Vs/Vt) - 1) for each row
    % if both nodes not grounded
    if ((node_i ~= 0) && (node_j ~= 0))
        Vs = Xguess(node_i) - Xguess(node_j);
        f(node_i) = Is * (exp(Vs / Vt) - 1);
        f(node_j) = -Is * (exp(Vs / Vt) - 1);
       
    % node j grounded
    elseif ((node_i ~= 0) && (node_j ==0))
        Vs = Xguess(node_i);
        f(node_i) = Is * (exp(Vs / Vt) - 1);
       
    % node i grounded
    else
        Vs = -Xguess(node_j);
        f(node_j) = -Is * (exp(Vs / Vt) - 1);
    end

    J = nlJacobian(Xdc);
    
    % phi_x = G * x + f_x - Bdc
    phi = G * Xguess + f - b;
    
    % Jacobian vector phi'
    d_phi = J;
    
    %dX = - inv(phi') * phi;
    %delta_x = - d_phi \ phi;
    dX = [dX (- d_phi \ phi)];
    

    
    % X_new = X_old + dX
    Xguess = Xguess + dX(:, iteration + 1);
    %Xguess = Xguess + delta_x;
    

    
  
    % X_new = X_old + dX
    Xdc = Xdc + dX(:, iteration + 1);
    %Xdc = Xdc + delta_x;
    
   
        
    % update norms
    norms = zeros (iteration +1);
    for i=1: (iteration+1)
        norms(i) = norm(dX(:, i), 2);
    end

 
    err = norm(dX(:, iteration + 1), 2);
    % dX <= max error -> end loop.
    if abs(err) <= maxerr
        error_tolerable = true;   
    end 
    
    
end

dX = norms;

end

    
   
    
