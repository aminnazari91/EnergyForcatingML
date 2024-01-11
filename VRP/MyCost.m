
function [z, sol]=MyCost(q,model)

    sol=ParseSolution(q,model);
    
    eta=model.eta;
    
    c=model.c;
    uc=sol.UC;
    
    def=uc-c;
    idx=(find(def>0));
    sumoverUC=sum(def(idx));
    
    sst=sol.SST;
    et=model.et;
    
    def=sst-et;
    idx=(find(def>0));
    sumoverTW=sum(def(idx));
        
    numActiveV=length(find(sol.UC>0));
    z1=eta*sol.TotalD/numActiveV+(1-eta)*sol.MaxD+numActiveV;
    
    beta=100;

    z1=z1+beta*sumoverUC;

    z=z1+beta*sumoverTW;

%     if (~sol.flagCap || ~sol.flagTW )
%         z=inf;
%         
%     else
%         z=z1;
%     end
end