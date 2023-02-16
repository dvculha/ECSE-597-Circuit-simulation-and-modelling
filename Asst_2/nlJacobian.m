function J = nlJacobian(X)
% Compute the jacobian of the nonlinear vector of the MNA equations as a 
% function of X
% input: X is the current value of the unknown vector.
% output: J is the jacobian of the nonlinear vector f(X) in the MNA
% equations. The size of J should be the same as the size of G.

global G DIODE_LIST

    
node_i = DIODE_LIST.node1;   
node_j = DIODE_LIST.node2;
Is = DIODE_LIST.Is;
Vt = DIODE_LIST.Vt;    
    
Vi = X(node_i);
Vj = X(node_j);
    
% size of matrix
sz = size (G, 1);

% contribution to jacobian    
A = zeros(sz, sz);
   
% ii
A(node_i, node_i) = (Is / Vt) * exp((Vi - Vj) / Vt);
% ij
A(node_i, node_j) = -(Is / Vt) * exp((Vi - Vj) / Vt);
% ji
A(node_j, node_i) = -(Is / Vt) * exp((Vi - Vj) / Vt);
% jj
A(node_j, node_j) = (Is / Vt) * exp((Vi - Vj) / Vt);
        
J = G + A;

end
