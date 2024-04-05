function [c,v,sb] = ICelevations(c,v,N,ss,Lt,Ns,Ne,Nd,Nb)
    v=CallBackwater(c,v,c.xi_d,N,ss,Lt,Ns,Ne,Nd,Nb,1);
    sb = Lt + (v.etabar(Ne)-v.etabase(Ne)) / (c.Sa-c.Sb); %full length with foreslope
    v.etabase(N+2) = c.etabx0 - c.Sb*(sb-c.Lch);
    c.Ldsb = sb;

