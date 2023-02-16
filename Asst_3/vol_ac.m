function vol_ac(n1,n2,val)
          % vol_ac(n1,n2,val)
          % Add stamp for adding AC sources to the global circuit representation
          % global G
          % global b bdc
          % n1 is the positive terminal
          % n2 is the negative terminal
          % Author: Karan
          % Date: Sept. 2021

     % define global variables
     global G
     global bac b
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