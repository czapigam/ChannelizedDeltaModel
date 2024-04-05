function [c,v,xs,Lt]=ArrangeInputs(c,v,Ns,Nd,Ne,N)
% This arranges the input values
%% Don't change  
c.NtoPrint = 1/c.PlotsPerYr;
c.dt = c.Dt*c.Tinyears;
%% DON'T CHANGE    
c.au     = 0.5;          %Upwind vs CentralDifference vs Downwind; 1=UW, 0.5= CD, 0=DW
Lt       = c.L0;
xs       = Lt;
c.D      = c.D/1000;
if ~isfield(c,'Dmud'); c.Dmud = c.Dfine; end
if ~isfield(c,'Dsusbed'); c.Dsusbed = c.Dwash; end
c.dx0   = Lt / (Ne-1); % initial dx length

c.Dmud  = c.Dmud/1e6;
c.Dsusbed = c.Dsusbed/1e6;
c.Dstar  = (c.R*c.g)^(1/3)*c.D/c.Nu^(2/3);
c.al_H   = 0.5; % Guess for intial depth at the shoreline

c.vs = ComputeVsDietrich(c,c.D);
c.vsMud = ComputeVsDietrich(c,c.Dmud);
c.vsSusbed = ComputeVsDietrich(c,c.Dsusbed);

v.gammaEnd = c.gamref;
c.aEH = c.EH_ff * 0.05;            %Engelund-Hansen Coefficient
c.Be = c.tstar_ff * 182;
c.m = 0.365;
c.n = -0.876;
c.n2 = 0;
end