
clear all

global   G C b bac 

n = 7;
G = zeros(n,n);               
C = zeros(n,n);
b = zeros(n,1);  
bac = zeros(n,1); 

vol_ac(1,0,0.010)
res(1,2,50)% source resistor
cap(2,3,1e-6)% coup[ling capacitor 
res(3,4,20e3)
vol(4,0,12)
res(3,0,3.6e3  )
npnBJT('BJT1',5,3,6, 1e-13,0.025,0.99,0.1)
res(6,0,220)%emitter res
cap(6,0,100e-6)
res(5,4,1.2e3)% collector


cap(5,7,1e-6)

res(7,0,10e3)% load 
 

Xguess = zeros(size(G,1),1);


%[Xdc, dX] = dcsolve(Xguess,1e-3);
Xdc = dcsolvecont(20,1e-6)


fpoints = logspace(0,6,5000);
outNode =7;
r = nonlinear_fsolve(Xdc, fpoints ,outNode);


close all
semilogx(fpoints, abs(r),'b')
grid on 
xlabel('Frequency');
ylabel('Magnitude of voltage at node 7');
