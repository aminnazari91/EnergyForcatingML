

function sol=ParseSolution(q,model)

    I=model.I;
    J=model.J;
    d=model.d;
    d0=model.d0;
    r=model.r;
    c=model.c;
    st=model.st;
    et=model.et;
    v=model.v;
    sd=model.sd;
    
    DelPos=find(q>I);
    
    From=[0 DelPos]+1;
    To=[DelPos I+J]-1;
    
    L=cell(J,1);
    D=zeros(1,J);
    UC=zeros(1,J);
    
    CJ=true(1,J);
    
    for j=1:J
        flagc=true;
        
        L{j}=q(From(j):To(j));
        
        if ~isempty(L{j})
            
            D(j)=d0(L{j}(1));
            
            for k=1:numel(L{j})-1
                D(j)=D(j)+d(L{j}(k),L{j}(k+1));
            end
            
            D(j)=D(j)+d0(L{j}(end));
                        
            UC(j)=sum(r(L{j}));
            
            if (UC(j)>c(j))
                flagc=false;
            end
               
        end  
        
        CJ(j)=flagc;
        
    end
    
    SST=zeros(1,I);     %Start Service Time for i'th Customer
    SM=zeros(1,J);      %Start Moviement j'th Vehicle
    WT=zeros(1,J);      %Sum waiting time for j'th Vehicle
    
    TWJ=true(1,J);
    for j=1:J
        
        flagtw=true;
        ETime=0;            %elapsed time for j'th Vehicle
        if ~isempty(L{j})
            
            SM(j)=st(L{j}(1)); %waiting in depot
            
            SST(L{j}(1))=SM(j)+d0(L{j}(1))/v; %arrival time to i'th Customer
            
            if( SST(L{j}(1)) > et(L{j}(1)) )
                
                flagtw=false;
 
            end
            
            ETime=SST(L{j}(1))+sd(L{j}(1));
            
            for k=2:numel(L{j})
                
                ETime=ETime+d(L{j}(k-1),L{j}(k))/v;
                if( ETime<st(L{j}(k)) )
                    
                    Waiting=st(L{j}(k))-ETime; %waiting for service presentation
                    WT(j)=WT(j)+Waiting;
                    ETime=ETime+Waiting;
                    
                end
                    
                SST(L{j}(k))=ETime;
                if( SST(L{j}(k)) > et(L{j}(k)) )
                     flagtw=false;
                end
                
                ETime=SST(L{j}(1))+sd(L{j}(k));
                
            end
          
        end
        TWJ(j)=flagtw;
        
    end
    
    sol.L=L;
    sol.D=D;
    sol.MaxD=max(D);
    sol.TotalD=sum(D);
    sol.UC=UC;
    sol.flagCap=all(CJ);
    sol.flagTW=all(TWJ);
    sol.WT=WT;
    sol.SST=SST;
    sol.TWJ=TWJ;
    sol.CJ=CJ;
    
end