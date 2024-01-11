function [ newp ] = LocalSearch(p,model)
    
    %NumActiveJ=length(find(pop(1).Sol.UC)>0);
    I=model.I;
    J=model.J;
    newp=ones(size(p.Position))*I+J;
    
    
    L=p.Sol.L;
    
    len=length(L);
    
    for i=1:len
        Tour=L{i,1};
        if (length(Tour)>0) %#ok
            
            newTour=CreateNeighbor(Tour);
            L{i,1}=newTour;
            newp=[newp I+i newTour]; %#ok
        end
    end

end

