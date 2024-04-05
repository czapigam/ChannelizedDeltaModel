function [v,deta_dt_end,Ss] = Exner2022(c,v,Ns,Ne,~,~,~,~,~)
% Use exner to establish the new slope based on differential sediment transport
for i=Ns:Ne    
    if i == Ns
        dQtdr(i)   = (v.Qt(i) - c.Qtf)/v.dx2(i); %dqt/dx 
    elseif i == Ne
        dQtdr(i)   = (v.Qt(i) - v.Qt(i-2))/(v.dx2(i-1)+v.dx2(i-2)); %The last node moves and can give bad results if dx is very small
    else
        dQtdr(i)   = (v.Qt(i) - v.Qt(i-1))/v.dx2(i-1); %dqt/dx
    end

    detabar1(i) = -c.If*(1+v.LamMud(i))/(1-c.lamp)*dQtdr(i)/v.Bv(i);
    detabar(i) = (detabar1(i)) *c.dt; 
end
    v.etabar(Ns:Ne)   = v.etabar(Ns:Ne)    + detabar(Ns:Ne);
    %Compute added volume to guide channel and delta
    deta_dt_end = detabar(Ne)/c.dt;
    Ss = -(3*v.etabar(Ne) - 4*v.etabar(Ne-1) + v.etabar(Ne-2))/((v.dx2(end)+v.dx2(end-1))); % higher order slope measurement to reduce boundary effects
end