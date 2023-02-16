function r = nonlinear_fsolve(Xdc, fpoints ,out)
%  nonlinear_fsolve(fpoints ,out)
%  Obtain frequency domain response
% global variables G C b bac
% Inputs: fpoints is a vector containing the fequency points at which
%         to compute the response in Hz
%         out is the output node
% Outputs: r is a vector containing the value of
%            of the response at the points fpoint

global  G C b bac 

% book page 148
sz = size(fpoints, 2);
r = zeros(1, sz);
    
for i = 1:sz
    % (G + jwC) * X = b
    %Xdc = (G + 1j * 2 * pi * fpoints(i) * C) \ (b + bac);
    
    %Xs*(G+Jdc) + CXs = bs
        
    J = nlJacobian(Xdc);   
    Xac = (G + J + 1j * 2 * pi * fpoints(i) * C) \ (bac);
    
    r(1, i) = Xac(out);
end

end

