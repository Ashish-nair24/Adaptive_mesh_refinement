%findedge - takes two node numbers and finds the global edge number

function[edge] = findedge(node1,node2)

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