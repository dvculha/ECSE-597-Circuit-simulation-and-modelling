clear all
%% NETLIST
global   G C b
n=2; %  number of nodes.
G = zeros(n,n);               
C = zeros(n,n);
b = zeros(n,1);   

vol_hb(1,0,1,60)
diode('D1',1,2,1e-14,0.025)
res(2,0,50)

sizeMNA = size(G,1);

%% Harmonic Balance Simulation
% CHOOSE THE SUITABLE number of harmonics
          
H =  3;                                            % H is the number of harmonics
Nh = 2*H+1;                                        % Nh is the number of fourier coefficients.
Xguess = zeros(sizeMNA*Nh ,1);                     % Make Xguess.


J = HB_nljacobian(Xguess, H)  
[Xout] = HBsolve(Xguess,H)                         % Solve the Harmonic Balance system.



%% plot the input and output node results
Gamma = makeGamma(H);
outNode =2;                                                  % output node
XoutNode = Xout( (outNode-1)*Nh +1: outNode*Nh);             % get the fourier coefficients at output node

XoutNode = Gamma*XoutNode;                                   % Convert the fourier coefficeints to time domain .

InputNode = 1;                                              % input node
XinNode = Xout( (InputNode-1)*Nh +1: InputNode*Nh);         % get the fourier coefficients at input node
XinNode = Gamma*XinNode;                                    % Convert the fourier coefficeints to time domain .

time = 0:1/(60*Nh):1/60;
time = time(1:end-1);
% plot here
close all
hold on 
plot(time,XinNode,'b-s')
plot(time,XoutNode,'r-*')
grid on 
ylabel('Voltage [V]')
xlabel('Time [s]')
title( 'Voltage at input and output of Half-wave rectifier')
legend('Voltage  at Node 1','Voltage  at Node 2' )