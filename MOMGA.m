

%__________________________________________________________________ %
%                          Multi-Objective                          %
%                Material Generation Algorithm (MOMGA)              %
%                                                                   %
%                                                                   %
%                  Developed in MATLAB R2022a (MacOs)               %
%                                                                   %
%                     Author and programmer                         %
%                ---------------------------------                  %
%                      Nima Khodadadi (ʘ‿ʘ)                         %
%                             e-Mail                                %
%                ---------------------------------                  %
%                         nkhod002@fiu.edu                          %
%                                                                   %
%                            Homepage                               %
%                ---------------------------------                  %
%                    https://nimakhodadadi.com                      %
%                                                                   %
%                                                                   %
%                                                                   %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% ----------------------------------------------------------------------- %




function [Archive_costs]=MOMGA(Max_iteration,Archive_size,NCompan,Var_Number,method,m)
%% Problem Definition

if method==3

    TestProblem=sprintf('P%d',m);

    ObjFuncName = Ptest(TestProblem);

    xrange  = xboundaryP(TestProblem);
    Var_Number=max(size(xrange));
    % Lower bound and upper bound
    VarMin=xrange(:,1)';
    VarMax=xrange(:,2)';

end
%
% display('MFO is optimizing your problem');
VarSize=[1 Var_Number];


%% Updating the Size of ProblemParams (If Necessary)
if length(VarMin)==1
    VarMin=repmat(VarMin,1,Var_Number);
end
if length(VarMin)==1
    VarMin=repmat(VarMin,1,Var_Number);
end

% Repository Size

alpha=0.1;  % Grid Inflation Parameter
nGrid=10;   % Number of Grids per each Dimension
beta=4; %=4;    % Leader Selection Pressure Parameter
gamma=2;


Compan=CreateEmptyParticle(NCompan);


for i=1:NCompan
    Compan(i).Velocity=0;
    Compan(i).Position=zeros(1,Var_Number);

    for j=1:Var_Number
        Compan(i).Position(1,j)=unifrnd(VarMin(j),VarMax(j),1);
        CompanIndex(i,j)=Compan(i).Position(1,j);
    end
    Compan(i).Cost=ObjFuncName(Compan(i).Position');
  
    Compan(i).Best.Position=Compan(i).Position;
    Compan(i).Best.Cost=Compan(i).Cost;
end

Compan=DetermineDominations(Compan);

Archive=GetNonDominatedParticles(Compan);

Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alpha);

for i=1:numel(Archive)
    [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end


%% Main Loop of MSS
for Iter=1:Max_iteration
    Leader=SelectLeader(Archive,beta);



    %New Companent 1
    for ind=0:NCompan
        Index1=NCompan.*(0:Var_Number-1)+randperm(NCompan,Var_Number);
        Compan(2*ind+1).Position=0.1*rand.*Leader.Position+unifrnd(-1,0).*randn(1,Var_Number);
        %New Companent 2
        Index=randperm(NCompan,1);
        Index2= randperm(NCompan,Index);
        CMs=randn(Index,1);
        CMs=CMs/sum(CMs);
        Compan(2*ind+2).Position=rand*CompanIndex(Index1)+sum(CMs.* CompanIndex(Index2,:));




        for i2=1:2
           
            Compan(2*ind+i2,:).Position=min(max(Compan(2*ind+i2).Position,VarMin),VarMax);
          
            Compan(2*ind+i2,:).Cost=ObjFuncName(Compan(2*ind+i2,:).Position');
            %
        end




    end
   

    Compan=DetermineDominations(Compan);
    non_dominated_Compan=GetNonDominatedParticles(Compan);

    Archive=[Archive
        non_dominated_Compan];

    Archive=DetermineDominations(Archive);
    Archive=GetNonDominatedParticles(Archive);


    for i=1:numel(Archive)
        [Archive(i).GridIndex Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
    end

    if numel(Archive)>Archive_size
        EXTRA=numel(Archive)-Archive_size;
        Archive=DeleteFromRep(Archive,EXTRA,gamma);

        Archive_costs=GetCosts(Archive);
        G=CreateHypercubes(Archive_costs,nGrid,alpha);

    end

    disp(['In iteration ' num2str(Iter) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    save results

    costs=GetCosts(Compan);
    Archive_costs=GetCosts(Archive);


end

end