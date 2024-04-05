function S = eqS(c)
    aS  = (c.R/c.Dstar^c.n/c.aEH/c.Cz/c.Be)^(1/(1+c.m));
    S = aS * (c.Qtf/c.Qwt)^(1/(1+c.m));