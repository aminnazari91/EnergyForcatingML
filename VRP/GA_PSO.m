clc;
clear;
close all;

%% Problem Definition

filename='C101.txt';
path='Data';
addpath(path);
NCust=70;
NVei=10;
model=ReadData(filename,NVei,NCust); 
meanvelocity=40;
model.v=meanvelocity;

CostFunction=@(q) MyCost(q,model);      % Cost Function

%% GA & PSO Parameters

MaxIt=1000;       % Maximum Number of Iterations

nPop=100;          % Population Size

pc=0.1;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number fo Parents (Offsprings)

pm=0.2;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

pmo=0.2;                % Movement Percentage
nmove=round(pmo*nPop);   % Number of Movement

psa=0.5;
nsa=round(psa*nPop);
%% Initialization

% Create Empty Structure
empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Sol=[];

empty_individual.BestPosition=[];
empty_individual.BestCost=[];
empty_individual.BestSol=[];

% Create Structre Array to Save Population Data
pop=repmat(empty_individual,nPop,1);

% Initilize Population
for i=1:nPop
    % Create Random Solution (Position)
    % Create Initial Solution
    Position=CreateRandomSolution(model);
    [Cost, Sol]=CostFunction(Position);
    
    pop(i).Position=Position;
    pop(i).Cost=Cost;
    pop(i).Sol=Sol;
    
    pop(i).BestPosition=Position;
    pop(i).BestCost=Cost;
    pop(i).BestSol=Sol;
    
end

for i=1:nPop
    
    p1=pop(i);
    newp = LocalSearch(p1,model);
    [Cost, Sol]=CostFunction(newp);
    
    if (p1.Cost>Cost)
        
        pop(i).Position=newp;
        pop(i).Cost=Cost;
        pop(i).Sol=Sol;
    
        pop(i).BestPosition=newp;
        pop(i).BestCost=Cost;
        pop(i).BestSol=Sol;
    
    end
    
end
% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution Ever Found
BestSol=pop(1);

% Create Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

for it=1:MaxIt
    
    for i=1:nPop
        if (pop(i).Cost<=pop(i).BestCost)
            pop(i).BestPosition=pop(i).Position;
            pop(i).BestCost=pop(i).Cost;
            pop(i).BestSol=pop(i).Sol;
        end
    end
    % Perform Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select First Parent
        i1=randi([1 nPop]);
        p1=pop(i1);
        
        % Select Second Parent
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        % Perform Crossover
        [popc(k,1).Position, popc(k,2).Position]=...
            Crossover(p1.Position,p2.Position);
        % Evaluate Offsprings
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        
        popc(k,1).Sol=ParseSolution(popc(k,1).Position,model);
        
        popc(k,1).BestCost=popc(k,1).Cost;
        popc(k,1).BestPosition=popc(k,1).Position;
        popc(k,1).BestSol=popc(k,1).Sol;

        
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
        popc(k,2).Sol=ParseSolution(popc(k,2).Position,model);
        
        popc(k,2).BestCost=popc(k,2).Cost;
        popc(k,2).BestPosition=popc(k,2).Position;
        popc(k,2).BestSol=popc(k,2).Sol;
        
    end
    popc=popc(:);
    
    % Perform Mutation
    popm=repmat(empty_individual,nm,1);
    for l=1:nm
        
        % Select Parent
        i1=randi([1 nPop]);
        p=pop(i1);
        
        % Perform Mutation
        popm(l).Position=Mutate(p.Position);
        
        popm(l).Cost=CostFunction(popm(l).Position);
      
        popm(l).Sol=ParseSolution(popm(l).Position,model);
        
        popm(l).BestCost=popm(l).Cost;
        popm(l).BestPosition=popm(l).Position;
        popm(l).BestSol=popm(l).Sol;

    end
    % Perform Movement
    popmovement=repmat(empty_individual,nmove,1);
    for l=1:nmove
        
        % Select Parent
        i1=randi([1 nPop]);
        p=pop(i1);
        
        % Perform Mutation
        popmovement(l).Position=Movement(p.Position,p.BestPosition,BestSol.Position);
        
        popmovement(l).Cost=CostFunction(popmovement(l).Position);
        
        popmovement(l).Sol=ParseSolution(popmovement(l).Position,model);
        
        popmovement(l).BestCost=popmovement(l).Cost;
        popmovement(l).BestPosition=popmovement(l).Position;
        popmovement(l).BestSol=popmovement(l).Sol;

    end
    
    popsa=repmat(empty_individual,nsa,1);
    for l=1:nsa
        
        % Select Parent
        i1=randi([1 nPop]);
        p=pop(i1);
        
        % Perform Mutation
        popsa(l).Position=CreateNeighbor(p.Position);
        
        popsa(l).Cost=CostFunction(popsa(l).Position);
      
        popsa(l).Sol=ParseSolution(popsa(l).Position,model);
        
        popsa(l).BestCost=popsa(l).Cost;
        popsa(l).BestPosition=popsa(l).Position;
        popsa(l).BestSol=popsa(l).Sol;

    end
        
    localpop=repmat(empty_individual,nsa,1);
    
    for l=1:0.2*nPop
        p1=pop(l);
        newp = LocalSearch(p1,model);
        [Cost, Sol]=CostFunction(newp);

        localpop(l).Position=newp;
        localpop(l).Cost=Cost;
        localpop(l).Sol=Sol;

        localpop(l).BestPosition=newp;
        localpop(l).BestCost=Cost;
        localpop(l).BestSol=Sol;
   
    end 
        
    % Merge Pops
    pop=[pop
         popc
         popm
         popmovement
         popsa
         localpop];
     
    
        
        
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Truncate Extra Individuals
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    PreBestCost=BestSol.Cost;
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    if BestSol.Cost-PreBestCost~=0
            convergence=it;
    end
    % Store Best Cost
    BestCost(it)=BestSol.Cost;
        
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ...
          ': Best Cost = ' num2str(BestCost(it))]);
      
      % Display Iteration Information
    if BestSol.Sol.flagCap
        FLAGC=' C+';
    else
        FLAGC=' C-';
    end
    if BestSol.Sol.flagTW
        FLAGT=' T+';
    else
        FLAGT=' T-';
    end
    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it)) FLAGC FLAGT]);
    % Plot Solution
    figure(1);
    PlotSolution(BestSol.Sol,model);
    %pause(0.01);
    
    
end

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;