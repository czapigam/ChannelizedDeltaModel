function [c,fig] = checkInputDelta(c)
    % Check inputs to make sure all files exist
    if ~isfield(c,'N1')
        c.N1 = 0; end
    if ~isfield(c,'N2a')
        c.N2a = 0; end
    if ~isfield(c,'PlotON')
        c.PlotON = 1; end
    if ~isfield(c,'Nmax')
        c.Nmax = c.N; end
    if ~isfield(c,'BvG'); c.BvG = c.Bv0; end 
    
    if ~isfield(c,"EH_ff"); c.EH_ff = 1; end
    
    if ~isfield(c,'gamMax')
        c.gamMax = 0.99; end
    if c.PlotON
        fig=figure; %set(gcf, 'Position', get(0, 'Screensize')); pause(1e-50);
        set(gcf,'Position',[105 165 1280 720]);
    else 
        fig = []; 
    end
