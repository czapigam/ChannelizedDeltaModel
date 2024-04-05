function Hbf = eqHbf(c)
    typ = 1;
    switch typ
        case 0 %input 
            Hbf = 10.5; 
        case 1 %constant Cz
            Hbf = c.Cz*c.D*c.aEH*c.Be^2*c.Dstar^(2*c.n)*...
            (c.R/c.Cz/c.Dstar^c.n/c.aEH/c.Be)^((2*c.m)/(1+c.m))*...
            (c.Qtf/c.Qwt)^((2*c.m)/(1+c.m)-1);
        case 2 %variable Cz
            %not implemented
    end

    aS  = (c.R/c.Dstar^c.n/c.aEH/c.Cz/c.Be)^(1/(1+c.m));
    eBQw = (2.5*c.m)/(1 + c.m);
    eBQt = 1- eBQw;
    Bbf = 1/c.Dstar^(2.5*c.n)/c.aEH/c.Cz^2/c.Be^2.5/sqrt(c.R*c.g*c.D)/c.D/aS^(2.5*c.m) * c.Qwt^(eBQw) * (c.Qtf)^eBQt;
    
end