% -------------------------------------------------------------------------
% !!!!!!!                Base input File with IC           !!!!!!!!!!!!!!!!
% -------------------------------------------------------------------------
%% NUMERICAL PARAMETERS % 0.001 and 20 works pretty good
c.Dt = 0.001; % Timestep (year)
c.N = 20;         % Number of nodes
c.T = .1;
c.T0 = 0;       % year
c.N1 = 0;         % For the upstream reach
c.N2 = c.N-c.N1;  % For the delta
c.Nmax = 2000;
c.Juv =73;
c.Gif = 1;      % 0 = Don't make Gif, 1 = Make Gif
c.PlotON =1;

%% PLOTTING PARAMETERS
c.PlotsPerYr =20;
c.gifSpacing = 0.1;
Plotall = 0;            %0 for increment, 1 for all timesteps

%% ICS
c.savevars = {'H','Hf','etac','etabar','etabase','Bc','Bv','gam','r','xhat','xi','Qwc','Qt'};

%% IC VALUES;%Wax Lake Parameters
c.Lch = 0;           % [m]; length of guide channel; untested
c.Lde = 41.8e3;       % [m]; Initial delta length
c.L0 = c.Lch+c.Lde; % [m]; Total Length of Domain
c.xi_d = 0.0;     % [m]; Water surface elevation at the basin; in MLLW reference frame
c.etabar0 = -4;    % intial elevation at the shoreline
c.Bv0 = 1*260;       % [m]; Domain Width of upstream floodplain (uses arc length if larger)
c.mBv = 0;           % slope term for trend in Bv
c.BvG = 2*260;
c.D = 0.3;          % [mm]
c.Qwt = 2270;       % [m3/s]; Water inflow discharge 
c.QtMt = 24;        % [Mt/yr]; mean-annual sediment load 
c.If = 0.3;         % [-]; Flood Intermittency Factor
c.EH_ff =1;
c.tstar_ff =2.1;
c.Cz =20;           % [-]; Dimensionless Chezy coefficient
c.FpCzRatio = 0.5;
c.Czf = c.FpCzRatio*c.Cz; % [-]; Dimensionless Chezy co
c.fsandIn = 1;      % [-]; Fraction of sand in the feed rate
c.WL = 2;           % [-]; Proportional Washload Deposited per unit sand
c.etab0 = -60;
c.S0 = 2.4e-4;        % [m/m]; Initial Delta Channel slope
c.Sb = 8.5e-4;
c.Sa = 3.6e-3;       % [m/m]; Slope of the foreset

%% Constant Parameters
% Parameters for all models
c.RatioAvgBank = 0.5;   % Fixed relative location of r_avg = the average flood inundation of the delta divided by ss.
c.gamMax = 0.99;
c.gamref = 0.8;
c.kTau = -log(c.gamref/c.gamMax); 
c.ssref = 0;
c.alMature = 1;
c.gamExp = 1;
c.Dmud = 15;          % microns
c.Dsusbed = 63;       % microns

% Computed Node Parameters
N = c.N;        % Added because Ns = 2; Ns = 2 allows use of ru
Ns = 1;         % Starting node Because Node 1 is at r=0 (not in domain that is changing) 
Ne = N+1;       % Ending Node
Nd = Ns;        % Ns + c.N1+4;  % Start of Delta region
Nb = Ns;        % Nd + c.N2a+1; % End of Width transition region (Between channel and delta; in the delta) 

%% BASIC  CONSTANTS 
c.Tinyears = 31557600;  % seconds in years;
c.g = 9.81;             % Gravity (Nms-1)
c.R = 1.65;             % Submerged Specific Gravity
c.rho = 1000;           % km/m3; water density
c.lamp = 0.6;           % lambda; porosity
c.Nu = 1e-6;            % Viscosity of Water

% Computed Feed Parameters
c.Qtf = c.QtMt*10^6/(c.R+1)*c.fsandIn/c.Tinyears/c.If; %[m3/s]; mean-annual sediment flux
c.Qmudf = (c.Qtf/c.fsandIn)*(1-c.fsandIn); % [m3/s]; mean-annual mud flux