function J = HB_nljacobian( Xbar_guess,H)

%  this function takes the vector containing Fourier Coefficients for nodal
%  voltages/currentsXs as input and returns  Jacobian J  also in "FREQUENCY" domain.

% Inputs: 1.  Xbar_guess is the Newton-Raphson guess vector. This vector is
%             in FREQUENCY DOMAIN as it contains the Fourier Coefficients for nodal
%             voltages/currents.
%        2.   H is the number of harmonics
         
% Output: J is the Jacobian in FREQUNECY DOMAIN.


global G DIODE_LIST 

H1 = H
n = size(G,1);
Nh = 2*H+1; % number of fourier coefficients.
J = zeros(n*Nh); % Initialize the f vector (same size as b)
SIZEJ = length(J)
NbDiodes = size(DIODE_LIST,2);
Gamma = makeGamma(H)
d_diode = zeros (Nh, Nh);


%% Fill in the Frequnecy Domain Jacobian for Diodes
for I = 1:NbDiodes

    node_i = DIODE_LIST(I).node1; 
    node_j = DIODE_LIST(I).node2;
    Vt = DIODE_LIST(I).Vt; % Vt of diode (part of diode model)
    Is = DIODE_LIST(I).Is; % Is of Diode (part of diode model)
    
    if (node_i ~= 0) && (node_j ~= 0) 
        v1_f = Xbar_guess((node_i-1) * Nh + 1 : node_i * Nh); %nodal voltage at anode
        v2_f = Xbar_guess((node_j-1) * Nh + 1 : node_j * Nh); %nodal voltage at cathode
        v1_t = Gamma * v1_f;
        v2_t = Gamma * v2_f;
        g = (Is / Vt) * exp ((v1_t - v2_t) / Vt);
        
        g = diag(g);

        g= Gamma \ g * Gamma;
        disp(g)

        %J = J+[g -g; -g g]
        %d_diode = d_diode + [g -g; g -g]
        J (((node_i-1) * Nh + 1 : node_i * Nh),((node_i-1) * Nh + 1 : node_i * Nh)) =  + g;
        J (((node_i-1) * Nh + 1 : node_i * Nh),((node_j-1) * Nh + 1 : node_j * Nh))  = - g;
        J (((node_j-1) * Nh + 1 : node_j * Nh),((node_i-1) * Nh + 1 : node_i * Nh)) =- g;
        J (((node_j-1) * Nh + 1 : node_j * Nh),((node_j-1) * Nh + 1 : node_j * Nh))=  + g;
        
        
        
        %f(node_i) = f(node_i) + diode_current;
        %f(node_j) = f(node_j) - diode_current;
    end
             
    %elseif (DIODE_LIST(I).node1== 0) && (DIODE_LIST(I).node2 ~= 0) 
        % You can omit this part, as this is not needed for this assignment
        
         
    %elseif (DIODE_LIST(I).node1~= 0) && (DIODE_LIST(I).node2 == 0)
         % You can omit this part, as this is not needed for this assignment
    
end
%Gbar = makeHB_Gmat(H)  % make Gbar 
%Cbar = makeHB_Cmat(H)  % make Cbar 

%J = Gbar + Cbar + J;

