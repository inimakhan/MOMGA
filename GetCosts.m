

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








function costs=GetCosts(pop)

    nobj=numel(pop(1).Cost);
    costs=reshape([pop.Cost],nobj,[]);

end