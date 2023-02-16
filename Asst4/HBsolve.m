function [Xout] = HBsolve(Xguess,H)
% This function takes a initial guess vector, Xguess as input and Number of
% Harmonics, H, as the input and then solves the Harmonic Balance system of
% equations using Newton-Raphson's method.

%Inputs: 1. Xguess: Is the Intial Guess for the harmonic balance.
%        2.  H :    Is the numberof Harmonics.

%Output: Xout: Is the solution vector (it is a vector of Fourier
%coefficients of nodal voltages/currents)

global G  C Bbar HBsources_LIST  DIODE_LIST 

Nh = 2*H+1; % number of fourier coefficients
n = size(G,1); % size of the MNA matrices.

maxerr = 1;
% The  variables that you may need are here.
frequency  = HBsources_LIST(1).freq;  % frequency.
Gbar = makeHB_Gmat(H);  % make Gbar 
Cbar = makeHB_Cmat(H);  % make Cbar 
% The variable Babr is made for you below.
Bbar = zeros(Nh*n,1);
%% make Bbar  
for I = 1:size(HBsources_LIST,1)
    Bbar(Nh*(HBsources_LIST(I).CurrentIdx-1)+3) =  HBsources_LIST(I).val;
end 

%% write your code here.

% Slides I00 20/41
%Gbar*Xbar + Cbar*Xbar + F(Xbar) = Bbar



sz = length(G);
dX = [];

error_tolerable = false;

iteration = 0;


% slides B00
while (~error_tolerable)
    iteration = iteration +1;
    
    F = HB_f_vector(Xguess, H);
    
    
    phi = Gbar * Xguess + 2 * pi * frequency * Cbar * Xguess + F - Bbar;

    J = HB_nljacobian(Xguess, H);   
    
    %disp(f);

    delta_x = (Gbar + 2 * pi * frequency * Cbar + J) \  phi; 
    
    Xguess = Xguess - delta_x;    
    
    if ((norm(delta_x) <= maxerr) && (norm(phi) <=maxerr))
        error_tolerable = true;
    end
    
    dX(iteration) = norm(delta_x);
     
end

Xout = Xguess;