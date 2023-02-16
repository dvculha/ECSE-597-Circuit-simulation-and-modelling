function J = nlJacobian(X)
% Compute the jacobian of the nonlinear vector of the MNA equations as a 
% function of X
% input: X is the current value of the unknown vector.
% output: J is the jacobian of the nonlinear vector f(X) in the MNA
% equations. The size of J should be the same as the size of G.

global G DIODE_LIST npnBJT_LIST
N = size(G);
J = zeros(N);
d_diode = zeros(N);
d_BJT = zeros(N); 

%% Add the Jacobian for diode -- 
%copy paste the one you implemented in your previous assignment 
  

NbDiodes = size(DIODE_LIST,2);

if (NbDiodes ~= 0)
    
for I = 1:NbDiodes  
    node_i = DIODE_LIST(I).node1;
    node_j = DIODE_LIST(I).node2;
    v1 = X(node_i); %nodal voltage at anode
    v2 = X(node_j); %nodal voltage at cathode  
    Vt = DIODE_LIST(I).Vt; % Vt of diode
    Is = DIODE_LIST(I).Is; % Is of Diode
  
    if (node_i ~= 0) && (node_j ~= 0)    

        %diode_current = Is*(exp((v1-v2)/Vt)-1);
        % derivative of diode current wrt v1
        d_I_v1 = (Is/Vt)*exp((v1-v2)/Vt);
        % derivative of diode current wrt v2
        d_I_v2 = -(Is/Vt)*exp((v1-v2)/Vt);
        
        % f(node_i) = f(node_i) + diode_current;
        % differentiate f(node_i) wrt v1
        d_diode(node_i, node_i) = d_diode(node_i, node_i) + d_I_v1;
        % f(node_i) = f(node_i) + diode_current;
        % differentiate f(node_i) wrt v2
        d_diode(node_i, node_j) = d_diode(node_i, node_j) + d_I_v2;
        %f(node_j) = f(node_j) - diode_current;
        % differentiate f(node_j) wrt v1
        d_diode(node_j, node_i) = d_diode(node_j, node_i) - d_I_v1;
        %f(node_j) = f(node_j) - diode_current;
        % differentiate f(node_j) wrt v2
        d_diode(node_j, node_j) = d_diode(node_j, node_j) - d_I_v2;

    elseif (node_i == 0)
        % diode_current = Is*(exp((v1-v2)/Vt)-1);
        % derivative of diode current wrt v2
        d_I_v2 = -(Is/Vt)*exp((v1-v2)/Vt);
        %f(node_j) = f(node_j) - diode_current;
        % differentiate f(node_j) wrt v2
        d_diode(node_j, node_j) = d_diode(node_j, node_j) - d_I_v2;
        
    elseif (node_j == 0)
        % diode_current = Is*(exp((v1-v2)/Vt)-1);
        % derivative of diode current wrt v1
        d_I_v1 = (Is/Vt)*exp((v1-v2)/Vt);
        % f(node_i) = f(node_i) + diode_current;
        % differentiate f(node_i) wrt v1
        d_diode(node_i, node_i) = d_diode(node_i, node_i) + d_I_v1;

    end
end

end


%% Add the Jacobian for BJT

NbBJTs = size(npnBJT_LIST,2);

if (NbBJTs ~= 0)
    
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
    
     if(cNode~=0)&&(bNode~=0)&&(eNode~=0) % all nodes present
        
         % get nodal voltages
         Vbe = X(bNode) -X(eNode);
         Vbc = X(bNode) -X(cNode);
         
         % diode currents 
         % If = Is*(exp(Vbe/Vt)-1);
         % derivative of If wrt Vc
         delta_If_c = 0;
         % derivative of If wrt Vb
         delta_If_b = Is/Vt*exp(Vbe/Vt); 
         % derivative of If wrt Ve
         delta_If_e = -Is/Vt*exp(Vbe/Vt);
         
         % Ir = Is*(exp(Vbc/Vt)-1);
         % derivative of Ir wrt Vc
         delta_Ir_c = -Is/Vt*exp(Vbc/Vt);
         % derivative of Ir wrt Vb
         delta_Ir_b = Is/Vt*exp(Vbc/Vt);
         % derivative of Ir wrt Ve
         delta_Ir_e = 0;

         %f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
         % derivative f(cNode) wrt Vc
         d_BJT(cNode, cNode) = d_BJT(cNode, cNode) - delta_Ir_c + alphaF * delta_If_c;  
         % derivative f(cNode) wrt Vb
         d_BJT(cNode, bNode) = d_BJT(cNode, bNode) - delta_Ir_b + alphaF * delta_If_b;
         % derivative f(cNode) wrt Ve
         d_BJT(cNode, eNode) = d_BJT(cNode, eNode) - delta_Ir_e + alphaF * delta_If_e;
         
         %f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
         d_BJT(bNode,cNode) = d_BJT(bNode, cNode) + delta_Ir_c *(1-alphaR) +    delta_If_c*(1-alphaF); 
         d_BJT(bNode,bNode) = d_BJT(bNode, bNode) + delta_Ir_b *(1-alphaR) +    delta_If_b*(1-alphaF);     
         d_BJT(bNode,eNode) = d_BJT(bNode, eNode) + delta_Ir_e *(1-alphaR) +    delta_If_e*(1-alphaF);
      
         %f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
         d_BJT(eNode,cNode) = d_BJT(eNode, cNode) + delta_Ir_c *(alphaR) -    delta_If_c;    
         d_BJT(eNode,bNode) = d_BJT(eNode, bNode) + delta_Ir_b *(alphaR) -    delta_If_b;         
         d_BJT(eNode,eNode) = d_BJT(eNode, eNode) + delta_Ir_e *(alphaR) -    delta_If_e;
      
     elseif (cNode~=0)&&(bNode==0)&&(eNode~=0) % Base is Grounded
         
         Vbe = -1*X(eNode);
         Vbc = -1*X(cNode);

          
         delta_If_c = 0;
         %delta_If_b = Is/Vt*exp(Vbe/Vt); 
         delta_If_e = -Is/Vt*exp(Vbe/Vt);
         
         delta_Ir_c = -Is/Vt*exp(Vbc/Vt);
         %delta_Ir_b = Is/Vt*exp(Vbc/Vt);
         delta_Ir_e = 0;

                  
         d_BJT(cNode, cNode) = d_BJT(cNode, cNode) - delta_Ir_c + alphaF * delta_If_c;  
         d_BJT(cNode, eNode) = d_BJT(cNode, eNode) - delta_Ir_e + alphaF * delta_If_e;
         
         d_BJT(eNode,cNode) = d_BJT(eNode, cNode) + delta_Ir_c *(alphaR) -    delta_If_c;    
         d_BJT(eNode,eNode) = d_BJT(eNode, eNode) + delta_Ir_e *(alphaR) -    delta_If_e;
      
     elseif (cNode~=0)&&(bNode~=0)&&(eNode==0) % Emitter is Grounded
          
         % fill this up  

         Vbe = X(bNode);
         Vbc = X(bNode) -X(cNode);
         
                  
         delta_If_c = 0;
         delta_If_b = Is/Vt*exp(Vbe/Vt); 
         %delta_If_e = -Is/Vt*exp(Vbe/Vt);
         
         delta_Ir_c = -Is/Vt*exp(Vbc/Vt);
         delta_Ir_b = Is/Vt*exp(Vbc/Vt);
         %delta_Ir_e = 0;
         
                        
         d_BJT(cNode, cNode) = d_BJT(cNode, cNode) - delta_Ir_c + alphaF * delta_If_c;  
         d_BJT(cNode, bNode) = d_BJT(cNode, bNode) - delta_Ir_b + alphaF * delta_If_b;
         
         d_BJT(bNode,cNode) = d_BJT(bNode, cNode) + delta_Ir_c *(1-alphaR) +    delta_If_c*(1-alphaF); 
         d_BJT(bNode,bNode) = d_BJT(bNode, bNode) + delta_Ir_b *(1-alphaR) +    delta_If_b*(1-alphaF);     
         
         
    elseif (cNode==0)&&(bNode~=0)&&(eNode~=0) % Collector is Grounded
      
        Vbe = X(bNode) -X(eNode);
        Vbc = X(bNode);
      
        % diode currents 
      
        %delta_If_c = 0;  
        delta_If_b = Is/Vt*exp(Vbe/Vt); 
        delta_If_e = -Is/Vt*exp(Vbe/Vt);
         
        %delta_Ir_c = -Is/Vt*exp(Vbc/Vt);
        delta_Ir_b = Is/Vt*exp(Vbc/Vt);
        delta_Ir_e = 0;

        d_BJT(bNode,bNode) = d_BJT(bNode, bNode) + delta_Ir_b *(1-alphaR) +    delta_If_b*(1-alphaF);     
        d_BJT(bNode,eNode) = d_BJT(bNode, eNode) + delta_Ir_e *(1-alphaR) +    delta_If_e*(1-alphaF);
                 
        d_BJT(eNode,bNode) = d_BJT(eNode, bNode) + delta_Ir_b *(alphaR) -    delta_If_b;         
        d_BJT(eNode,eNode) = d_BJT(eNode, eNode) + delta_Ir_e *(alphaR) -    delta_If_e;
              
         

     elseif(cNode~=0)&&(bNode==0)&&(eNode==0) % Base and  Emitter are grounded

         %Vbe = 0;
         Vbc = -X(cNode);
         % diode currents 
               
         delta_If_c = 0
         delta_Ir_c = -1*Is/Vt*exp(Vbc/Vt)
      
         d_BJT(cNode, cNode) =  d_BJT(cNode, cNode)  -    delta_Ir_c        +    alphaF*delta_If_c ;
      
     end 
end %end Forloop for BJTs

end
J = G + d_BJT + d_diode;
end

