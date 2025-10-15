%adaptation

%function[E_,V_,Enum,Vnum,edgenum,U,Fx,Fy] = adaptation(E_,V_,Enum,Vnum,U,edgenum,Fx,Fy)
%edgenum - stores number of edges 
%Enum - stores number of elements
%Vnum - holds number of nodes
%looping over all edges (globaledgenum) and finding the mach jump errors
 
% for i=1:edgenum
%     
%     node1 = globaledgenum(i,1);
%     node2 = globaledgenum(i,2);
%     L = edgevselement(i,1); %element on left
%     R = edgevselement(i,2); %element on right
%     h = sqrt(((V_(node2,1)-V_(node1,1))^2)+((V_(node2,2)-V_(node1,2))^2));
%     Ur = sqrt((U(R,2)^2)+(U(R,3)^2))/U(R,1); %magnitude of velocity on the right element
%     Ul = sqrt((U(L,2)^2)+(U(L,3)^2))/U(L,1); %magnitude of velocity on the left element
%     pL = (gamma-1)*(U(L,4)-0.5*(((U(L,2)^2)+(U(L,3)^2))/U(L,1)));  
%     cL = sqrt((1.3*pL)/U(L,1)); %speed of sound in the left element
%     pR = (gamma-1)*(U(R,4)-0.5*(((U(R,2)^2)+(U(R,3)^2))/U(R,1)));
%     cR = sqrt((1.3*pR)/U(R,1)); %speed of sound in the right element
%     Mr = Ur/cR ; %Mach number on right element
%     Ml = Ul/cL ; %Mach number on left element
%     
%     Error(i,1) = abs((Mr-Ml))*h; %jump error for each element 
%     
% end
% 
% threshold = round(0.03*edgenum); %number of elements to be flagged
% B = sort(Error,2,'descend');
% thresholderror = B(threshold,1); %holds threshold value of error above which element must be flagged
% 
% %initial flagging
% flag = zeros(edgenum,1); %holds flag of each element
% for i = 1:edgenum
% 
%     if(Error(i,1)<= thresholderror)
%         flag(i,1)=1;
%     end
% end

%smoothing of refinement pattern

for i=1:Enum
    
    node1=E_(i,1);
    node2=E_(i,2);
    node3=E_(i,3);

    edge1 = findedge(node1,node2,globaledgenum); %global number of each edge
    edge2 = findedge(node2,node3,globaledgenum);
    edge3 = findedge(node3,node1,globaledgenum);
    
    if(flag(edge1,1)==1||flag(edge2,1)==1||flag(edge3,1)==1)
        flag(edge1,1)=1;
        flag(edge2,1)=1;
        flag(edge3,1)=1;
    end
end

%looping over elements and appending E_ and V_ matrices

for i=1:Enum
    
    node1=E_(i,1);
    node2=E_(i,2);
    node3=E_(i,3);

    edge1 = findedge(node1,node2,globaledgenum); %global number of each edge
    edge2 = findedge(node2,node3,globaledgenum);
    edge3 = findedge(node3,node1,globaledgenum);
    
    numflag = flag(edge1,1)+flag(edge2,1)+flag(edge3,1); %checks how many edges are flagged
    %when 3 edges are flagged
    if(numflag==3)
        
        midpoint1(1,1)= (V_(node1,1) + V_(node2,1))/2 ; %x-cordinate of midpoint of edge1
        midpoint1(1,2)= (V_(node1,2) + V_(node2,2))/2 ; %y-cordinate of midpoint of edge1
        midpoint2(1,1)= (V_(node2,1) + V_(node3,1))/2 ; %x-cordinate of midpoint of edge2
        midpoint2(1,2)= (V_(node2,2) + V_(node3,2))/2 ; %y-cordinate of midpoint of edge2
        midpoint3(1,1)= (V_(node1,1) + V_(node3,1))/2 ; %x-cordinate of midpoint of edge3
        midpoint3(1,2)= (V_(node1,2) + V_(node3,2))/2 ; %y-cordinate of midpoint of edge3
        %appending V_ matrix
        Vnum = Vnum+1;
        V_(Vnum,1:2) = midpoint1(1,1:2); %Vnum-2
        Vnum = Vnum+1;
        V_(Vnum,1:2) = midpoint2(1,1:2); %Vnum-1
        Vnum = Vnum+1;
        V_(Vnum,1:2) = midpoint3(1,1:2); %Vnum
        
        %appending E_ matrix , U , Fx and Fy
        E_(i,2) = Vnum-2;
        E_(i,3) = Vnum;
        
        Enum = Enum+1;
        E_(Enum,1) = Vnum-2;
        E_(Enum,2) = node2;
        E_(Enum,3) = Vnum-1;
        U(Enum,1:4) = U(i,1:4);
        Fx(Enum,1:4) = Fx(i,1:4);
        Fy(Enum,1:4) = Fy(i,1:4);
        
        Enum = Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = node3;
        E_(Enum,3) = Vnum;
        U(Enum,1:4) = U(i,1:4);
        Fx(Enum,1:4) = Fx(i,1:4);
        Fy(Enum,1:4) = Fy(i,1:4);
        
        Enum = Enum+1;
        E_(Enum,1) = Vnum-2;
        E_(Enum,2) = Vnum-1;
        E_(Enum,3) = Vnum;
        U(Enum,1:4) = U(i,1:4);
        Fx(Enum,1:4) = Fx(i,1:4);
        Fy(Enum,1:4) = Fy(i,1:4);
        
    end
    %when two edges are flagged
    if(numflag==2)
        
        %appending V_ and E_ based on which 2 edges are flagged
        if(flag(edge1,1)==0)
        midpoint2(1,1)= (V_(node2,1) + V_(node3,1))/2 ; %x-cordinate of midpoint of edge2
        midpoint2(1,2)= (V_(node2,2) + V_(node3,2))/2 ; %y-cordinate of midpoint of edge2
        midpoint3(1,1)= (V_(node1,1) + V_(node3,1))/2 ; %x-cordinate of midpoint of edge3
        midpoint3(1,2)= (V_(node1,2) + V_(node3,2))/2 ; %y-cordinate of midpoint of edge3
        edge2length = sqrt(((V_(node3,1)-V_(node2,1))^2)+((V_(node3,2)-V_(node3,2))^2));
        edge3length = sqrt(((V_(node3,1)-V_(node1,1))^2)+((V_(node3,2)-V_(node1,2))^2));
        
        Vnum = Vnum+1; %Vnum-1
        V_(Vnum,1:2) = midpoint2(1,1:2);
        Vnum = Vnum+1; %Vnum
        V_(Vnum,1:2) = midpoint3(1,1:2);
        
        if(edge2length>edge3length)
        E_(i,3) = Vnum-1;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = node2;
        E_(Enum,3) = Vnum;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = Vnum;
        E_(Enum,3) = node3;
        
        end
        
        if(edge3length>edge2length)
        E_(i,3) = Vnum;
        
        Enum=Enum+1;
        E_(Enum,1) = node2;
        E_(Enum,2) = Vnum-1;
        E_(Enum,3) = Vnum;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum;
        E_(Enum,2) = Vnum-1;
        E_(Enum,3) = node3;
        end
        end
        
        if(flag(edge2,1)==0)
        midpoint1(1,1)= (V_(node1,1) + V_(node2,1))/2 ; %x-cordinate of midpoint of edge1
        midpoint1(1,2)= (V_(node1,2) + V_(node2,2))/2 ; %y-cordinate of midpoint of edge1
        midpoint3(1,1)= (V_(node1,1) + V_(node3,1))/2 ; %x-cordinate of midpoint of edge3
        midpoint3(1,2)= (V_(node1,2) + V_(node3,2))/2 ; %y-cordinate of midpoint of edge3
        edge1length = sqrt(((V_(node1,1)-V_(node2,1))^2)+((V_(node1,2)-V_(node2,2))^2));
        edge3length = sqrt(((V_(node3,1)-V_(node1,1))^2)+((V_(node3,2)-V_(node1,2))^2));
        
        Vnum = Vnum+1; %Vnum-1
        V_(Vnum,1:2) = midpoint1(1,1:2);
        Vnum = Vnum+1; %Vnum
        V_(Vnum,1:2) = midpoint3(1,1:2);
        
        if(edge1length>edge3length)
        E_(i,1) = Vnum-1;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = node3;
        E_(Enum,3) = Vnum;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = Vnum;
        E_(Enum,3) = node1;
        
        end
        
        if(edge3length>edge1length)
        E_(i,1) = Vnum;
        
        Enum=Enum+1;
        E_(Enum,1) = node2;
        E_(Enum,2) = Vnum;
        E_(Enum,3) = Vnum-1;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = Vnum;
        E_(Enum,3) = node1;
        end
        end
        
        if(flag(edge3,1)==0)
        midpoint1(1,1)= (V_(node1,1) + V_(node2,1))/2 ; %x-cordinate of midpoint of edge1
        midpoint1(1,2)= (V_(node1,2) + V_(node2,2))/2 ; %y-cordinate of midpoint of edge1
        midpoint2(1,1)= (V_(node2,1) + V_(node3,1))/2 ; %x-cordinate of midpoint of edge2
        midpoint2(1,2)= (V_(node2,2) + V_(node3,2))/2 ; %y-cordinate of midpoint of edge2
        edge1length = sqrt(((V_(node1,1)-V_(node2,1))^2)+((V_(node1,2)-V_(node2,2))^2));
        edge2length = sqrt(((V_(node2,1)-V_(node3,1))^2)+((V_(node2,2)-V_(node3,2))^2));
        
        Vnum = Vnum+1; %Vnum-1
        V_(Vnum,1:2) = midpoint1(1,1:2);
        Vnum = Vnum+1; %Vnum
        V_(Vnum,1:2) = midpoint2(1,1:2);
        
        if(edge1length>edge2length)
        E_(i,2) = Vnum-1;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = Vnum;
        E_(Enum,3) = node3;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = node2;
        E_(Enum,3) = Vnum;
        
        end
        
        if(edge2length>edge1length)
        E_(i,2) = Vnum;
        
        Enum=Enum+1;
        E_(Enum,1) = node1;
        E_(Enum,2) = Vnum-1;
        E_(Enum,3) = Vnum;
        
        Enum=Enum+1;
        E_(Enum,1) = Vnum-1;
        E_(Enum,2) = node2;
        E_(Enum,3) = Vnum;
        end
        end
        
        %Appending U , Fx and Fy
        U(Enum,1:4) = U(i,1:4);
        Fx(Enum,1:4) = Fx(i,1:4);
        Fy(Enum,1:4) = Fy(i,1:4);
        
        U(Enum-1,1:4) = U(i,1:4);
        Fx(Enum-1,1:4) = Fx(i,1:4);
        Fy(Enum-1,1:4) = Fy(i,1:4);
        
    end
    
    %when 1 edge is flagged 
    
    if(numflag==1)
        
        if(flag(edge1,1)==1)
            midpoint1(1,1)= (V_(node1,1) + V_(node2,1))/2 ; %x-cordinate of midpoint of edge1
            midpoint1(1,2)= (V_(node1,2) + V_(node2,2))/2 ; %y-cordinate of midpoint of edge1
            
            %appending V_ matrix
            Vnum=Vnum+1;
            V_(Vnum,1:2) = midpoint1(1,1:2);
            
            %appending E_ matrix
            E_(i,2) = Vnum ;
            
            E=Enum+1;
            E_(Enum,1) = Vnum ;
            E_(Enum,2) = node2;
            E_(Enum,3) = node3;
            
        end
        
        if(flag(edge2,1)==1)
            midpoint2(1,1)= (V_(node2,1) + V_(node3,1))/2 ; %x-cordinate of midpoint of edge2
            midpoint2(1,2)= (V_(node2,2) + V_(node3,2))/2 ; %y-cordinate of midpoint of edge2
            
            %appending V_ matrix
            Vnum=Vnum+1;
            V_(Vnum,1:2) = midpoint2(1,1:2);
            
            %appending E_ matrix
            E_(i,3) = Vnum ;
            
            E=Enum+1;
            E_(Enum,1) = Vnum;
            E_(Enum,2) = node3;
            E_(Enum,3) = node1;
            
        end
        
        if(flag(edge3,1)==1)
            midpoint3(1,1)= (V_(node3,1) + V_(node1,1))/2 ; %x-cordinate of midpoint of edge2
            midpoint3(1,2)= (V_(node3,2) + V_(node1,2))/2 ; %y-cordinate of midpoint of edge2
            
            %appending V_ matrix
            Vnum=Vnum+1;
            V_(Vnum,1:2) = midpoint3(1,1:2);
            
            %appending E_ matrix
            E_(i,1) = Vnum ;
            
            E=Enum+1;
            E_(Enum,1) = node1;
            E_(Enum,2) = node2;
            E_(Enum,3) = Vnum;
            
        end
        
        %Appending U , Fx ,Fy
        U(Enum,1:4) = U(i,1:4);
        Fx(Enum,1:4) = Fx(i,1:4);
        Fy(Enum,1:4) = Fy(i,1:4);
    end
end

function[edge] = findedge(node1,node2,globaledgenum)

for i=1:1558
    if(node1==globaledgenum(i,1))
        if(node2==globaledgenum(i,2))
            edge = i;
        end
    end
    if(node1==globaledgenum(i,2))
        if(node2==globaledgenum(i,1))
            edge = i;
        end
    end
end
end
%end
        