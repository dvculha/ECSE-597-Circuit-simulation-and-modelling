function ind(n1,n2,val)
          % ind(n1,n2,val)
          % Add stamp for inductor to the global circuit representation
          % Inductor connected between n1 and n2
          % The indjuctance is val in Henry
          % global G
          % global C
          % global b
          % Date:

     % defind global variables
     global G
     global b
     global C
     
     
     d = size(G,1);       %current size of the MNA
     xr = d+1;            %new row

     b(xr)=0;             %add new row
                                % Matlab automatically increases the size of a matrix if you use an index
                                % that is bigger than the current size.
     G(xr,xr)=0;        %add new row/column
     C(xr,xr)=0;        %add new row/column



     if (n1~=0)
        G(n1,xr)=1;
        G(xr,n1)=1;
     end

     if (n2~=0)
        G(n2,xr)=-1;
        G(xr,n2)=-1;
     end
     
     C(xr,xr)= -val;
     
end


     