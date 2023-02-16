function f = f_vector(X)
% Compute the nonlinear vector of the MNA equations as a function of x

global b DIODE_LIST npnBJT_LIST

N = size(b);
f = zeros(N); % Initialize the f vector (same size as b)

NbDiodes = size(DIODE_LIST,2);
NbBJTs = size(npnBJT_LIST,2);

%% Fill in the Fvector for Diodes
for I = 1:NbDiodes
    node_i = DIODE_LIST(I).node1
    node_j = DIODE_LIST(I).node2        
    Vt = DIODE_LIST(I).Vt; % Vt of diode (part of diode model)
    Is = DIODE_LIST(I).Is; % Is of Diode (part of diode model)
    
    if (node_i ~= 0) && (node_j ~= 0) 
        v1 = X(node_i); %nodal voltage at anode
        v2 = X(node_j); %nodal voltage at cathode
        diode_current = Is*(exp((v1-v2)/Vt)-1);
        f(node_i) = f(node_i) + diode_current;
        f(node_j) = f(node_j) - diode_current;
    elseif (node_i == 0)
        v2 = X(node_j); %nodal voltage at cathode
        diode_current = Is*(exp((-v2)/Vt)-1);
        f(node_j) = f(node_j) - diode_current;
    elseif (node_j == 0)
        v1 = X(node_i); %nodal voltage at anode
        diode_current = Is*(exp((v1)/Vt)-1);
        f(node_i) = f(node_i) + diode_current;
    end
end

%% Fill in the Fvector for BJTs
for I=1:NbBJTs
     
     %get Nodes Numbers
     cNode = npnBJT_LIST(I).collectorNode;
     bNode = npnBJT_LIST(I).baseNode;
     eNode = npnBJT_LIST(I).emitterNode;    
     
     % get other parameters
     Vt = npnBJT_LIST(I).Vt;
     Is = npnBJT_LIST(I).Is;
     alphaR = npnBJT_LIST(I).alphaR;
     alphaF = npnBJT_LIST(I).alphaF;
     
     
    % if both nodes not grounded
     
    if(cNode~=0)&&(bNode~=0)&&(eNode~=0) % all nodes present
         % get nodal voltages
         
         Vbe = X(bNode) -X(eNode);
         Vbc = X(bNode) -X(cNode);
         % diode currents 
         If = Is*(exp(Vbe/Vt)-1);
         Ir = Is*(exp(Vbc/Vt)-1);

         f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
         f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
         f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
      
      
     elseif (cNode~=0)&&(bNode==0)&&(eNode~=0) % Base is Grounded
         
         Vbe = -1*X(eNode);
         Vbc = -1*X(cNode);
         % diode currents 
         If = Is*(exp(Vbe/Vt)-1);
         Ir = Is*(exp(Vbc/Vt)-1);
                  
         f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
         %f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
         f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
    
     elseif (cNode~=0)&&(bNode~=0)&&(eNode==0) % Emitter is Grounded
          % fill this up  
              
          
          Vbe = X(bNode);
          Vbc = X(bNode) -X(cNode);
          % diode currents 
          If = Is*(exp(Vbe/Vt)-1);
          Ir = Is*(exp(Vbc/Vt)-1);
       
         f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
         f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
         %f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
         
    elseif (cNode==0)&&(bNode~=0)&&(eNode~=0) % Collector is Grounded
      % fill this up  
               
      % get nodal voltages
      
      Vbe = X(bNode) -X(eNode);
      Vbc = X(bNode);
      % diode currents 
         
      If = Is*(exp(Vbe/Vt)-1);
      Ir = Is*(exp(Vbc/Vt)-1);
         
         
      f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
      f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
      
      
     
    elseif(cNode~=0)&&(bNode==0)&&(eNode==0) % Base and  Emitter are grounded
        % get nodal voltages  
        Vbe = 0;
        Vbc = -X(cNode);
        % diode currents 
        If = Is*(exp(Vbe/Vt)-1);
        Ir = Is*(exp(Vbc/Vt)-1);

        f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
      
     end 
end %end Forloop for BJTs
