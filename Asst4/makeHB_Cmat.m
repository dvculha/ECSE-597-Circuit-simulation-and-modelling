function Chat = makeHB_Cmat(H)
global C G
nh = 2*H+1;
Chat = zeros(nh*size(G,1));
for I = 1:size(C,1)
    for J = 1:size(C,1)
      
        cmul=1;
        cval = C(I,J);
        for k = 1:nh
                        
            if rem(k,2) == 0
                Chat(nh*J-(nh-k)+1,nh*I-(nh-k))= (Chat(nh*J-(nh-k)+1,nh*I-(nh-k)) + (-1*cval*(cmul)));
                Chat(nh*J-(nh-k),nh*I-(nh-k)+1)= (Chat(nh*J-(nh-k),nh*I-(nh-k)+1) + (cval*(cmul)));
                cmul = cmul +1;
            end
        end
    end
end
end 