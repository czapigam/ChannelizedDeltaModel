function [ssdot,sbdot]= ShockCondition(c,v,N,ss,sb,def_dt_end,Ss,null)
% Compute the delta progradation rate
    ssdot = 1 / (c.Sa-Ss) * (c.If * (1 + c.WL) * v.Qt(N+1) / (1 - c.lamp) / v.Bv(N+1) / (sb - ss) )...
          - 1 / (c.Sa-Ss) * (def_dt_end );
    sbdot = 1 / (c.Sa - c.Sb) * (def_dt_end + (c.Sa-Ss) * ssdot );   
end