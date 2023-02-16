function Fb = HB_f_vector(Xbar_guess,H)

%  this function takes the FREQUENCY domain vector Xb as input and returns
%  Fb  as output in FREQUNECY DOMAIN.

% Inputs: 1.Xbar_guess is the Newton-Raphson guess vector. This vector is
%             in FREQUENCY DOMAIN as it contains the Fourier Coefficients for nodal
%             voltages/currents.
%        2. H is the number of harmonics
         
% Output: Fb is the nonlinear vector in "frequnecy" domain ( it will
% contain the fourier coefficients for nonlinearity.)


global G DIODE_LIST 

n = size(G,1);
Nh = 2*H+1; % number of fourier coefficients.
Fb = zeros(n*Nh,1); % Initialize the Fb vector 
f = zeros(n*Nh,1);
Gamma = makeGamma(H);
NbDiodes = size(DIODE_LIST,2);
%Xbar_guess = Gamma .* Xbar_guess;

%% Fill in the fs for Diodes
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
        diode_current_f = Is*(exp((v1_t-v2_t)/Vt)-1);
        diode_current_t = Gamma \ diode_current_f;
        
        Fb ((node_i-1) * Nh + 1 : node_i * Nh) = Fb ((node_i-1) * Nh + 1 : node_i * Nh)+diode_current_t;
        Fb ((node_j-1) * Nh + 1 : node_j * Nh) = Fb ((node_j-1) * Nh + 1 : node_j * Nh)-diode_current_t;
        %f(node_i) = f(node_i) + diode_current;
        %f(node_j) = f(node_j) - diode_current;
    end
end
%
%Fb = Gamma\f
%Fb = Gamma \ f;
%Fb((Z-1)*Nh +1 : Z*Nh)
       
       
% Hint: To fill up the Fb with the Fourier Coeffeicnts for node Z 
% you can access the the suitable indices using, 
% Fb((Z-1)*Nh +1 : Z*Nh)

        
        
    %elseif (DIODE_LIST(I).node1== 0) && (DIODE_LIST(I).node2 ~= 0) 
         % You can omit this part, as this is not needed for this assignment
    %elseif (DIODE_LIST(I).node1~= 0) && (DIODE_LIST(I).node2 == 0)
        % You can omit this part, as this is not needed for this assignment
    %end 
end 
       
        
        
        






