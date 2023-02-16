clear all
global   G C b
n=4;
G = zeros(n,n);               
C = zeros(n,n);
b = zeros(n,1);   

vol(1,0,10)% collector to Ground
res(1,2,4.7e3)

res(4,0,3.3e3)

npnBJT('BJT1',2,3,4, 1e-15,0.025,0.99,0.1)

Vb = 6;
vol(3,0,Vb)% Base to Ground %4V Active % 6V Saturation %0 Cut-off

Xguess = zeros(size(G,1),1);

%[Xdc, dX] = dcsolve(Xguess,1e-1)
 
 
% DC solve with continuation 
Xdc = dcsolvecont(50,1e-6)
