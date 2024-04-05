function Bbf = eqBbf(c)
    typ = 1;
    switch typ
        case 0 %input 
            error('Not existent!');
        case 1 %constant Cz
            
            aS  = (c.R/c.Dstar^c.n/c.aEH/c.Cz/c.Be)^(1/(1+c.m));  
            eBQw = (2.5*c.m)/(1 + c.m);
            eBQt = 1- eBQw;
            Bbf = 1/c.Dstar^(2.5*c.n)/c.aEH/c.Cz^2/c.Be^2.5/sqrt(c.R*c.g*c.D)/c.D/aS^(2.5*c.m) * c.Qwt^(eBQw) * (c.Qtf)^eBQt;
        case 2 %variable Cz
            error('needs to be implemented.')
    end
end