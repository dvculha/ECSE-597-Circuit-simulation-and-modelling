function Gamma =  makeGamma(H)
%This function takes number of harmonics H as the input and returns 
%the Direct Fourier Transform (DFT) matrix, Gamma, as the output.
%gamma is the direct fourier transform matrix

%Input: H is the number of harmonics
% Output: Gamma is the DFT matrix
Nh = 2*H+1;                      % number of fourier coefficients


%% Write your code here.
% Slides I00 33/44

for n = 0: (Nh-1)
    %for k = 0 : H
    for j = 1 : (Nh)
        i = n + 1;
        
        % starts at 0
        k = fix (j / 2);
        theta = k * n * 2 * pi / Nh;
            
        if ((rem (j,2))==1)   
            Gamma(i, j) = sin(theta); 
        end
            
       
        if ((rem (j,2))==0)  
            Gamma(i, j) = cos(theta);
        end
       if (j == 1)
           Gamma(i,j) = 1;
       end
    end 
end




