function [c,v]=PreallocateVar(c,N)
    % pre-allocate the variables here.
    
    dx = (c.L0)/c.N2;
    c.Lch = dx.*c.N1;
    c.L0 = c.L0 + c.Lch; 
    L1 = 0:c.Lch/(c.N1):c.Lch; if isnan(L1) L1= 0; end
    temp2 = (c.L0-c.Lch)/(c.N2);
    v.r = horzcat(L1,c.Lch+temp2:temp2:c.L0);

    clear temp1 temp2;
    v.xhat        = [v.r./c.L0];
    v.dx          = diff(v.xhat);
    v.dx2         = diff(v.r);
    v.Bc          = c.Bv0.*ones(1,N+1);
    v.Bv          = v.Bc; %Just a filler
    v.Qw          = c.Qwt.*ones(1,N+1);
    v.LamMud      = zeros(1,N+1);
    v.taustar     = zeros(1,N+1); %Just a filler
    v.taus        = zeros(1,N+1);
    v.etabar      = NaN(1,N+1);
    v.etabase     = NaN(1,N+2);   %N+2 to include the toe of foreset
    v.gam         = ones(1,N+1);
    v.H           = zeros(1,N+1); %just a placeholder
    v.Hc          = zeros(1,N+1); %just a placeholder
    v.Hf          = zeros(1,N+1); %just a placeholder
    v.xi          = zeros(1,N+1);
    v.xsdotmat    = NaN(1,200);
end