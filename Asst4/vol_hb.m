function vol_hb(n1,n2,val,freq)

          % Add stamp for SINGLE TONE Harmonic Balance sources to the global circuit representation
          % global G
          % global b bdc 
          % n1 is the positive terminal
          % n2 is the negative terminal
          % val is the amplitude of the tone
          % freq is the frequency of the tone.
          % Author: Karan
          % Date: Oct. 2021

     % define global variables
     global G
     global bac b Bhb  HBsources_LIST
     global C

     d = size(G,1);       %current size of the MNA
     xr = d+1;            %new row

     bac(xr,1)=0;             %add new row
                                % Matlab automatically increases the size of a matrix if you use an index
                                % that is bigger than the current size.
     G(xr,xr)=0;        %add new row/colomn
     C(xr,xr)=0;        %add new row/colomn



     if (n1~=0)
        G(n1,xr)=1;
        G(xr,n1)=1;
     end

     if (n2~=0)
        G(n2,xr)=-1;
        G(xr,n2)=-1;
     end

     bac(xr)=val;
     
     % if other voltage sources are present update their sizes
     b(xr) = 0;
     
%%
nbHBsources = size(HBsources_LIST,2);

N = nbHBsources + 1;  %index of next diode
HBsources_LIST(N).node1 = n1;
HBsources_LIST(N).node2 = n2;
HBsources_LIST(N).CurrentIdx = xr;
HBsources_LIST(N).val = val;
HBsources_LIST(N).freq = freq;