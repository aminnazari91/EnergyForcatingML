function y=Movement(x,LocalBest,GlobalBest)
    
    Nvar=length(x);
    C1=2;
    C2=2;
   
    %% movement
    Vel = C1*rand*(LocalBest - x) + C2*rand*(GlobalBest - x);
    
    SigV = 1./(1+exp(-Vel));
        
    mSigV=mean(SigV);
    
    r1=rand;
    r2=rand;
    
    if r1>r2
        gr=r1;
        lr=r2;
    else
        gr=r2;
        lr=r1;
    end
    
    if (mSigV<lr)
        y=LocalBest;
    elseif(mSigV>=lr && mSigV<=gr)
        y=randperm(Nvar);
    else
        y=GlobalBest;
    end
    
end