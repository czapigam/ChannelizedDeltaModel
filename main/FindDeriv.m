function [v] = FindDeriv(c,v,ss,Ns,Ne,au)
    v.S(Ns)    = -(v.etac(Ns+1)   - v.etac(Ns))     /v.dx(Ns); 
    v.Sbase(Ns) = (v.etabase(Ns+1)- v.etabase(Ns))  /v.dx(Ns); 
    v.Sgam(Ns)  = (v.gam(Ns+1)    - v.gam(Ns))  /v.dx(Ns); 
    v.S(Ne)    = -(v.etac(Ne)    - v.etac(Ne-1))   /v.dx(Ne-1);
    v.Sbase(Ne) = (v.etabase(Ne) - v.etabase(Ne-1))/v.dx(Ne-1);
    v.Sgam(Ne)  = (v.gam(Ne)     - v.gam(Ne-1))   /v.dx(Ne-1);

    for i=Ns+1:Ne-1
        v.S(i) = -(au*(v.etac(i) - v.etac(i-1))/v.dx(i-1) + (1-au)*(v.etac(i+1)- v.etac(i))/v.dx(i));
        v.Sbase(i) = (au*(v.etabase(i) - v.etabase(i-1))/v.dx(i-1) + (1-au)*(v.etabase(i+1)- v.etabase(i))/v.dx(i));
        v.Sgam(i) = (au*(v.gam(i) - v.gam(i-1))/v.dx(i-1) + (1-au)*(v.gam(i+1)- v.gam(i))/v.dx(i));
    end    
end