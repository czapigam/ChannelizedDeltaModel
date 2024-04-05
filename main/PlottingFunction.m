function PlottingFunction(f1,c,v,ccc,Ns,Ne,xs,xb,xsdot,Tcount)
    disp([c.InputFile,'; Year: ',num2str(c.T0 + Tcount),'/',num2str(c.T)]);
    if c.PlotON == 1
        plotPost(c,v,f1,Ns,Ne,xs,xb,xsdot,v.gammaEnd,Tcount);
        if c.Gif == 1 MakeGif(c,f1,c.gifSpacing,ccc); end
        saveas(gcf,fullfile(c.FigFolder,['Fig_',sprintf('%04.0f',ccc)]),'jpeg');    
    end