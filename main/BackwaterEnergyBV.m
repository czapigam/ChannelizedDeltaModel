function [v] = BackwaterEnergyBV(c,v,xi_d,~,N,Ns,~,~,~)
	plotON=0;
    c.Hbf = eqHbf(c);
    c.Bbf = eqBbf(c);
    options = optimoptions('fsolve','Display','none','OptimalityTolerance',1e-5);

    itermethod = 2; %1 = dumb way, 2 = fsolve
   
    v.xi(N+1) = xi_d;
    Hmaybe = fsolve(@(H1)iterB2(c,v,xi_d,N,H1),c.Hbf,options);
    [~,~,~,Bmaybe,~,~,~,~,~,~,~,~,~,~,~] = subcompute(c,v,N+1,Hmaybe);
    if Bmaybe > v.Bv(N+1)
        v.H(N+1) = xi_d - v.etabar(N+1);
        [v.Hc(N+1),v.Hf(N+1),v.Sf(N+1),v.Bc(N+1),v.etalev(N+1),v.etac(N+1),v.Qwc(N+1),v.Qwf(N+1),v.Uc(N+1),v.Uf(N+1),v.E(N+1),v.xi(N+1),v.taus(N+1),v.taub(N+1),v.Qt(N+1)] = subcomputeCW(c,v,N+1,v.H(N+1));
    else
        v.H(N+1) = Hmaybe;
        [v.Hc(N+1),v.Hf(N+1),v.Sf(N+1),v.Bc(N+1),v.etalev(N+1),v.etac(N+1),v.Qwc(N+1),v.Qwf(N+1),v.Uc(N+1),v.Uf(N+1),v.E(N+1),v.xi(N+1),v.taus(N+1),v.taub(N+1),v.Qt(N+1)] = subcompute(c,v,N+1,v.H(N+1));
    end

	for i = N:-1:Ns
        dE = v.Sf(i+1).*v.dx2(i);
		v.E(i) = v.E(i+1) + dE;
        E = v.E(i);
        H1 = v.H(i+1);
        if itermethod >1
            Hmaybe = fsolve(@(H1)iter2(c,v,i,0,H1),H1,options);
        else
            [H1,H2] = iter(c,v,i,0);
		    Hmaybe = (H2 + H1)/2; %now we've found the right H we can solve with it
        end
        [~,~,~,Bmaybe,~,~,~,~,~,~,~,~,~,~,~] = subcompute(c,v,i,Hmaybe);

        if Bmaybe > v.Bv(i) %then use energy to solve for a confined
            if itermethod >1
                v.H(i) = fsolve(@(H1)iter2(c,v,i,1,H1),H1,options);
            else
                [H1,H2] = iter(c,v,i,1);
		        v.H(i) = (H2 + H1)/2;
            end
            [v.Hc(i),v.Hf(i),v.Sf(i),v.Bc(i),v.etalev(i),v.etac(i),v.Qwc(i),v.Qwf(i),v.Uc(i),v.Uf(i),~,v.xi(i),v.taus(i),v.taub(i),v.Qt(i)] = subcomputeCW(c,v,i,v.H(i));
        else
            v.H(i) = Hmaybe;
            [v.Hc(i),v.Hf(i),v.Sf(i),v.Bc(i),v.etalev(i),v.etac(i),v.Qwc(i),v.Qwf(i),v.Uc(i),v.Uf(i),~,v.xi(i),v.taus(i),v.taub(i),v.Qt(i)] = subcompute(c,v,i,v.H(i));
        end
        if any(~isreal(v.E))
            error('Imaginary depths');
        end
    end
%     if plotON ==1; plotter(c,v,ss); end
end

function F = iter2(c,v,i,vers,H1)
    %fsolve iteration
    E = v.E(i);
    if vers==0
        [Hc1,Hf1,Sf1,Bc1,etaf1,etac1,Qwc1,Qwf1,Uc1,Uf1,E1,xi1,taub,taus,Qtf1] = subcompute(c,v,i,H1);
    else 
        [Hc1,Hf1,Sf1,Bc1,etaf1,etac1,Qwc1,Qwf1,Uc1,Uf1,E1,xi1,taub,taus,Qtf1] = subcomputeCW(c,v,i,H1);
    end
    Hn = H1;
    F = (E-E1);
end

function [H1,H2] = iter(c,v,i,vers)
    inc = 0.001;
    imax = 1e5;
    E = v.E(i);
    H1 = v.H(i+1); 
	H2 = H1;
	done = 1; co=1;
	while done && co < imax
		H1 = H2;	
        if vers==0
            [Hc1,Hf1,Sf1,Bc1,etaf1,etac1,Qwc1,Qwf1,Uc1,Uf1,E1,xi1,taub,taus,Qtf1] = subcompute(c,v,i,H1);
        else 
            [Hc1,Hf1,Sf1,Bc1,etaf1,etac1,Qwc1,Qwf1,Uc1,Uf1,E1,xi1,taub,taus,Qtf1] = subcomputeCW(c,v,i,H1);
        end
		if co == 1 % choose your adventure; which direction do you iterate?
			typ = 0;
			if E1 > E; typ = 1; end
		end
		switch typ % increase or decrease 
			case 0 
				done = E1 < E;
                H2 = H1 + inc;
                H3 = H1 - inc;
			case 1 
				done = E1 > E;
                H2 = H1 - inc;
                H3 = H1 + inc;
		end
		co=co+1;
    end
    H2 = H3; %fix 
    if co >= imax; 
        warning('exceeded iteration limit'); end
end

function [Hc1,Hf1,Sf1,Bc1,etaf1,etac1,Qwc1,Qwf1,Uc1,Uf1,E1,xi,taus1,taub1,Qt1] = subcompute(c,v,i,H1)
    Bvi = v.Bv(i); 
    Hc1 = v.gam(i)*H1;
    Hf1 = (1-v.gam(i))*H1;
    Sf1 = (v.gam(i)*c.Be*c.Dstar^c.n*c.R*c.D/H1)^(1/(1-c.m)); %This is OK becuase i set c.n2 = 0
    if Hf1>0 
        Bc1 = (c.Qwt - (c.Czf * sqrt(c.g*Sf1) * Bvi * Hf1^1.5))...
                    / (sqrt(c.g*Sf1) * (c.Cz*H1^1.5 - c.Czf*Hf1^1.5));
	    etaf1 = (Bvi*v.etabar(i) + Bc1*Hc1) / Bvi;
        etac1 = etaf1 - Hc1;
    else % the floodplain is at the water surface

        Fr2 = c.Cz^2*Sf1;
        Bc1 = sqrt(c.Qwt^2 / c.g / Fr2 / H1^3);
        etac1 = 1/Bvi*(v.etabar(i)*Bvi - H1*(Bvi-Bc1));
        etaf1 = etac1 + H1;
    end
	Qwc1 = c.Cz* sqrt(c.g*Sf1)*Bc1*H1^1.5;
	Qwf1 = c.Czf*sqrt(c.g*Sf1)*(Bvi-Bc1)*Hf1^1.5;
    
	Uc1 = Qwc1 / H1 / Bc1;
	Uf1 = Qwf1 / Hf1 / (Bvi-Bc1);
    if isnan(Uf1) Uf1 = 0; Qwf1=0; end % in case Hf1 == 0

    Ac1 = H1*Bc1;
    Af1 = Hf1 * (Bvi-Bc1);
    Ubar = (Ac1*Uc1 + Af1*Uf1)/(Ac1+Af1); %energy coefficient = 1
    
% 	E1 = H1 + etac1 + 1/c.Qwt*(Qwc1 * Uc1^2/2/c.g + Qwf1 * Uf1^2/2/c.g);
    E1 = H1 + etac1 + Ubar.^2/2/c.g;
    xi = etac1 + H1;
    taus1 = H1*Sf1/c.R/c.D;
    taub1 = taus1.*c.rho*c.R*c.g*c.D;
    Qt1 = sqrt(c.R*c.g*c.D)*c.D*Bc1*c.aEH*c.Cz^2*taus1^(5/2);
end

function [Hc1,Hf1,Sf1,Bc1,etaf1,etac1,Qwc1,Qwf1,Uc1,Uf1,E1,xi,taus1,taub1,Qt1] = subcomputeCW(c,v,i,H1)
    % Bc = Bv; Bf = 0; etac = etabar = etaf
    % H1 is guessed
    % Definitions
    etac1 = v.etabar(i);
    etaf1 = etac1;
    Hc1 = H1; 
    Hf1 = 0;
    xi = etac1 + H1;
    Bc1 = v.Bv(i);
    Bf1 = 0;
    Qwf1 = 0;
    Qwc1 = v.Qw(i);
    Uf1 = 0;
    Uc1 = Qwc1/H1/Bc1;

    %Compute
    E1 = H1 + etac1 + Uc1^2/2/c.g;
    Fr2 = Qwc1^2/(c.g*Bc1^2*H1^3); %B is fixed in time
    Sf1 = Fr2 / c.Cz.^2; %only in the channel
    taus1 = H1*Sf1/c.R/c.D;
    taub1 = taus1.*c.rho*c.R*c.g*c.D;
    Qt1 = sqrt(c.R*c.g*c.D)*c.D*Bc1*c.aEH*c.Cz^2*taus1^(5/2);
end

function [F] = iterB2(c,v,xi_d,N,H1)
   % it needs to optimize when F = 0  
    Hc1 = v.gam(N+1)*H1;
    Hf1 = (1-v.gam(N+1))*H1;
    Sf1 = (v.gam(N+1)*c.Be*c.Dstar^c.n*c.R*c.D/H1)^(1/(1-c.m));
    Bc1 = (c.Qwt - (c.Czf * sqrt(c.g*Sf1) * v.Bv(N+1) * Hf1^1.5))...
                / (sqrt(c.g*Sf1) * (c.Cz*H1^1.5 - c.Czf*Hf1^1.5));
    etaf1 = (v.Bv(N+1)*v.etabar(N+1) + Bc1*Hc1) / v.Bv(N+1);
    Hf2 = xi_d - etaf1;
    H1n = Hf2 ./ (1-v.gam(N+1));
    F = abs(H1-H1n);

end
% 
% function plotter(c,v,ss)
%     clf;
%     Np =5;
%     x = v.xhat.*ss-c.Lch;
%     subplot(Np,1,[1 2]); plot(x,v.etac,'-x',x,v.etalev,x,v.etabar,x,v.xi,'linewidth',2); legend ('\eta_c','\eta_f','\eta_{bar}','\xi'); set(gca,'fontsize',12);
%     subplot(Np,1,3); plot(x,v.Bc,x,v.Bv-v.Bc); ylabel('width (m)'); ylim([0 max(ylim)]); legend('Bc','Bf');
%     subplot(Np,1,4); plot(x,v.Qwc./c.Qwt,x,v.Qt./c.Qtf); legend('Q_{c,norm}','Q_{t,norm}');
%     subplot(Np,1,5); plot(x,v.Hf./v.H,x,v.Hc./v.H); ylabel('Hc,Hf (m)'); ylim([-0.1 1.1]);legend('Hf','Hc','location','southwest');
%     set(gca,'Fontsize',12); pause(1e-10);
%     disp(['etac = ', num2str(v.etac(end)),'; H = ',num2str(v.H(end)),'; Hf = ',num2str(v.Hf(end))]);
%     Bf = v.Bv - v.Bc;
%     pause(1e-100);
% end


