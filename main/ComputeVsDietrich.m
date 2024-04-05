function vs = ComputeVsDietrich(c,D)
%computing settling velocity from Dietrich relation
    b1   = 2.891394;
    b2   = 0.95296;
    b3   = 0.056835;
    b4   = 0.002892;
    b5   = 0.000245;
    Rep  = sqrt(c.g*c.R * D) * D /c.Nu;    
    Rf   = exp(-b1 + b2*log(Rep)-b3*(log(Rep))^2 - b4*(log(Rep))^3 + b5*(log(Rep))^4);
    vs   = Rf* sqrt(c.g*c.R * D);
end