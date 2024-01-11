

function q=CreateRandomSolution(model)

    I=model.I;
    J=model.J;
    
    x=model.x;
    y=model.y;
    
    data=[x' y'];
    k=randi([ceil(J/2)+1 J]) ;
    [idx,~]=kmeans(data,k);

    qnew=[];
    for i=1:J
        index=find(idx==i);
        q=index';
        a=(I+i);
        q=[q a];        %#ok     
        qnew=[qnew q];  %#ok
    end
    
    qnew(end)=[];
    q=qnew;

    %q=randperm(I+J-1);
    
end