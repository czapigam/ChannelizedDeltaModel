function [v,N,Ne,ss,sb,Lt,xi_d,ssdotbar] = EndOfTimestepUpdates(c,v,Ns,Ne,N,ss,sb,ssdot,sbdot,xi_d,t)
% All of the updates to make at the end of a time step
    gammaEnd = NaN;
    gamold = v.gam;
    %moving avg of ssdot value
    [ssdotbar,v.xsdotmat] = Avg_ssdot(ssdot,v.xsdotmat);

    v.gammaEnd  = ComputeGammaBasin(c,v,xi_d,t);
    v.gam       = ComputeMaturation(c,v,Ns,Ne,N,ss,0*ssdot,v.gammaEnd); %0 * ssdot because its fixed grid now, fix it properly later

%% Update dimensions 
    
    ss      = ss + ssdot * c.dt; %new foreset length with progradation
    sb      = sb + sbdot * c.dt; %new bottomset length with progradation
    Lt      = ss;
    v.xi    = [v.etac(Ns:Ne) + v.H(Ns:Ne)];

% move the last node
    v.r(Ne) = v.r(Ne)+ssdot*c.dt;
    v.dx2 = diff(v.r);
    dxt = c.dx0;

    % add another node
    if v.dx2(end) > dxt %dx is too big, make a new node spaced at dx to the left and dxt-dx to the right
        Ne = Ne +1; N=N+1;
        dx0 = v.dx2(end);
        dx1 = dxt;
        nam = {'r','gam','etabar','LamMud','etac','Qw'};
        for ii = 1:length(nam)
            v.(nam{ii})(Ne) = v.(nam{ii})(Ne-1);
            v.(nam{ii})(Ne-1) = interp1([0,dx0],[v.(nam{ii})(Ne-2),v.(nam{ii})(Ne)],dx1);
        end
        v.gam(Ne) = v.gammaEnd; %update for new channel
            
    end
    v.etabase(1:Ne) = c.etabx0 - (v.r - c.Lch).*c.Sb;

% Update position vectors
    v.xhat      = [v.r./(Lt)];
    v.dx        = diff(v.xhat);
    v.dx2       = diff(v.r); %dimensioned
    v.Bv = horzcat(linspace(c.BvG,c.Bv0,c.N1+1),c.Bv0 + c.mBv .* [v.r(c.N1+2:Ne)- c.Lch]);
    v.etabase(Ne+1) = c.etabx0 - (sb - c.Lch)*c.Sb;%location of the toe of slope
    ssdotbar=ssdotbar*c.Tinyears;

    N=Ne-1;

end