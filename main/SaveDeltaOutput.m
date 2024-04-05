function [o,vOut] = SaveDeltaOutput(c,v,o,vOut,N,Ns,Ne,nCount,Tcount,ss,sb,ssdot,er2,co)
    Nn = c.Nmax+1;
    o.t(co) = nCount;
    o.T(co) = c.T0 + Tcount;
    o.ss(co) = ss; 
    o.ssdot(co) = ssdot;
    o.sb(co) = sb;
    o.Ne(co) = Ne;
    
    if isfield(c,'savevars')
        fn = fieldnames(v);
        for i = 1:length(fn)
            if any(strcmp(fn{i},c.savevars)) %if it is in savevars
                var = v.(fn{i});
                vOut.(fn{i})(:,co) = horzcat(var,NaN(1,Nn-length(var))); 
            end
        end
    else 
        vOut(co) = v; 
    end
end