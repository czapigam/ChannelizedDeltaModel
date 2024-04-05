function plotPost(c,v,fig,Ns,Ne,Lt,sb,ssdot,gammaEnd,T)
%To plot results
figure(fig);
% WATER SURFACE ELEVATION
    x = v.xhat(Ns:Ne).*Lt-c.Lch; %0 = the delta apex
    xss = Lt - c.Lch;
    xsb = sb - c.Lch;

    eta         = [v.etalev(Ns:Ne)];
    etacPlot    = [v.etac(Ns:Ne)];
    etabarPlot  = [v.etabar(Ns:Ne)];
    eta_loc     = [v.xhat(Ns:Ne).*Lt];
    etac_loc    = [v.xhat(Ns:Ne).*Lt];
    if ~isfield(v,'LamMud') v.LamMud = ones(Ns,Ne).*c.WL; end
    
    limx = [-c.Lch, xsb];
    limx2 = [-c.Lch, 2*x(end)-x(end-1)];
    Yup = ceil(max(v.xi));
    Ylow = min([floor(min(v.etac)),floor(min(v.etabase))]);
    Ft = 14;
% PROFILE PLOT 
    ax(1)= subplot(3,3,[1:6]);
    plot(x,v.etac(Ns:Ne),'-k',x,v.etabar(Ns:Ne),'-gs',x,v.xi(Ns:Ne),'-b',x,v.etalev(Ns:Ne),'-r',...
        [x,xsb],[v.etabase(Ns:Ne+1)],'--k'); hold on;
    plot([xss, xsb],[v.etabar(Ne) v.etabase(Ne+1)],'-.','color',0.8*[1 1 1]); 

    hold off;
    xlabel('Length (m)');
    ylabel('\eta_{nc} (m) ');
    set(gca,'FontSize',Ft);
    xlim(limx);
    grid minor;
    ylim([Ylow Yup]);

%-----------
% WIDTH  PLOT
    temp=0;
    ax(2) = subplot(3,3,[7]); 
    plot(x,v.Bv(Ns:Ne),'o','color',[1 0 0],'Markersize',2,'MarkerFaceColor','r'); hold on; 
    plot(x,v.Bc(Ns:Ne-temp),'-r',x,v.Bv(Ns:Ne-temp),'-b');
    tempy = ylim; ylim([10^2 tempy(2)]); tempy=ylim;
	xlim(limx2);	
    ylabel('Width (m)'); xlabel('Length (m)'); set(gca,'FontSize',Ft);
    set(gca,'yscale','log'); 
    grid minor;
    hold off;

% DEPTH  PLOT
    temp=0;
    ax(3) = subplot(3,3,[8]); 
    plot(x,repmat(eqHbf(c),1,Ne-Ns+1),'-ro','color',[1 0 0],'Markersize',1,'MarkerFaceColor','r'); hold on; 
    plot(x,v.H(Ns:Ne),'-k+'); 
	xlim(limx2);
    ylabel('Depth (m)'); xlabel('Length (m)'); set(gca,'FontSize',Ft);
    grid minor;
    hold off;

%-----------
% gamma PLOTS
    ax(4) = subplot(3,3,[9]);
    xlabel('Length (m)');
    set(gca,'FontSize',Ft);
    plot(x,v.gam(Ns:Ne),'-.r+'); hold on;
    plot(2*x(end)-x(end-1),gammaEnd,'rs');
    legend('\gamma','location','southwest');
    xlabel('Length(m)');
    set(gca,'FontSize',Ft);
    
    tempy = ylim; ylim([0 tempy(2)]); clear tempy;
    xlim(limx2); 
    ylim([0 1]);
    grid minor;
    hold off;

% Set the title
    sgtitle(['\bf{Year: ',num2str(c.T0 + T),'}']);
    pause(1e-10); 
end