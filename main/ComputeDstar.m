function [Dbank,Dstar] = ComputeDbank(c,v)
    Dbank = (c.D + v.Dbank .* v.LamMud) /(1+v.LamMud);
    Dstar = (c.R*c.g)^(1/3)*Dbank/c.Nu^(2/3);
end