function [c,v] = CallICs(c,v,Ns,Ne,Nd,Nb,N)
    % Computing Valley Width
    v.Bv(Ns:Ne)   = c.Bv0.*ones(1,N+1);
    v.Bv = horzcat(linspace(c.BvG,c.Bv0,c.N1+1),c.Bv0 + c.mBv .* [v.xhat(c.N1+2:N+1).*c.L0 - c.Lch]);
 
    v.etabase(Ns:Ne) = fliplr(c.etab0+c.Sb.*v.r);
    c.etabxs0 = v.etabase(N+1);
    c.etabx0 = v.etabase(N+1) + c.Sb*(c.L0-c.Lch); 
    v.etabar = c.etabar0 + (1-v.xhat).*c.L0.*c.S0;
    S = repmat(c.S0,1,c.N);
    v.etabar = fliplr(c.etabar0 + cumsum(horzcat(0,v.dx2.*S)));

    v.etabar(1:c.N1)= v.etabar(c.N1+1);
    % Juvenile Channel ICs
    xhat2 = (v.xhat-c.Lch/c.L0)/(c.L0-c.Lch)*c.L0;
    temp = xhat2 > c.RatioAvgBank;
    switch c.Juv
        case 0
            v.gam = ones(1,N+1);
        case [{1,3,4,5,6,7} num2cell(71:79)] %exponential
            v.gam(~temp) = c.gamMax;
            v.gam(temp)  = c.gamMax.*exp(c.kTau*(c.RatioAvgBank - xhat2(temp))/c.RatioAvgBank);
    %             indmax = min(find(temp));
        otherwise 
            v.gam = ones(1,N+1);
            warning('incorrect input in CallICs');
    end
    v.LamMud = ones(1,N+1);      
    v.Qw(Ns:Ne)  = c.Qwt;
    c.Hbf = eqHbf(c);

end