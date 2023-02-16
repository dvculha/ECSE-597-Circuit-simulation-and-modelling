function r = fsolve(fpoints, out)
%  fsolve(fpoints, out)
%  Obtain frequency domain response
% global variables G C b
% Inputs: fpoints is a vector containing the frequency points at which
%         to compute the response in Hz
%         out is the output node
% Outputs: r is a vector containing the value of
%            of the response at the points fpoint


% define global variables
global G C b

sz = size(fpoints, 2);
r = zeros(1, sz);
    
for i = 1:sz 
    % (G + jwC) * X = b
    X = (G + 1j * 2 * pi * fpoints(i) * C) \ b;
    r(1, i) = X(out);
end

end