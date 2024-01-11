function [pc1,pc2]=Crossover(p1,p2)

point1=ceil(length(p1)/3);
point2=floor(length(p1)*2/3);

temp=p2(point1:point2);
p2(point1:point2)=p1(point1:point2);
p1(point1:point2)=temp;

for i=1:point1-1
    % child 1
    gen=p1(i);
    if ~isempty( find(p1(point1:point2)==gen, 1))
        p1(i)=0;
    end
    % child 2
    gen=p2(i);
    if ~isempty( find(p2(point1:point2)==gen, 1))
        p2(i)=0;
    end
    
end
for i=point2+1:length(p1)
    % child 1
    gen=p1(i);
    if ~isempty( find(p1(point1:point2)==gen, 1))
        p1(i)=0;
    end
    % child 2
    gen=p2(i);
    if ~isempty( find(p2(point1:point2)==gen, 1))
        p2(i)=0;
    end  
    
end
pc1=p1;
pc2=p2;


for i=1:length(pc1)
    if  isempty( find(pc1==i, 1))
       
        idx=find(pc1==0,1,'first');
        pc1(idx)=i;
    end   
end

for i=1:length(p2)
    if  isempty( find(pc2==i, 1))
        idx=find(pc2==0,1,'first');
        pc2(idx)=i;
    end   
end