

function model=ReadData(filename,NumVehicles,NumCustomers)

    fid = fopen(filename,'rt');
    tmp = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    tmp=tmp{1,1};
    line=str2num(tmp{1,1}); %#ok
    
    if (nargin == 1)
        NumVehicles=line(2);
        NumCustomers=line(3);
    end
    
    line=str2num(tmp{2,1}); %#ok
    MaxCappacity=line(2);
    
    line=str2num(tmp{3,1}); %#ok
    x0=line(2); % depot x coordinate
    y0=line(3); % depot y coordinate
    
    Customers=zeros(NumCustomers,6);
    
    for i=1:NumCustomers
        
        line=str2num(tmp{i+3,1}); %#ok
        Customers(i,1)=line(2); %x coordinate
        Customers(i,2)=line(3); %y coordinate
        Customers(i,3)=line(4); %service duration
        Customers(i,4)=line(5); %demand
        Customers(i,5)=line(9); %beginning of time window
        Customers(i,6)=line(10); %end of time window
        
    end
    
    J=NumVehicles;
    I=NumCustomers;
    c=repmat(MaxCappacity,1,J);
    
    x=Customers(:,1)';
    y=Customers(:,2)';
    sd=Customers(:,3)';
    r=Customers(:,4)';
    st=Customers(:,5)';
    et=Customers(:,6)';
    
    d=zeros(I,I);
    d0=zeros(1,I);
    for i=1:I
        for i2=i+1:I
            d(i,i2)=sqrt((x(i)-x(i2))^2+(y(i)-y(i2))^2);
            d(i2,i)=d(i,i2);
        end
        
        d0(i)=sqrt((x(i)-x0)^2+(y(i)-y0)^2);
    end
    
    xmin=min([x,x0]);
    ymin=min([y,y0]);
    
    xmax=max([x,x0]);
    ymax=max([y,y0]);
    
    eta=0.1;
    
    model.I=I;
    model.J=J;
    model.r=r;
    model.c=c;
    model.xmin=xmin;
    model.xmax=xmax;
    model.ymin=ymin;
    model.ymax=ymax;
    model.x=x;
    model.y=y;
    model.x0=x0;
    model.y0=y0;
    model.d=d;
    model.d0=d0;
    model.eta=eta;
    model.st=st;
    model.et=et;
    model.sd=sd;
    
end