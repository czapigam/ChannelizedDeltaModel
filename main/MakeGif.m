function MakeGif(c,fig,gifspacing,ccc)
% CODE FOR GIF MOVIE
    drawnow
    frame = getframe(fig);
    im = frame2im(frame);
    [A,map] = rgb2ind(im,256);  
    if ccc == 1
        imwrite(A,map,c.filenameGif,'gif','LoopCount',Inf,'DelayTime',gifspacing);
    else
        imwrite(A,map,c.filenameGif,'gif','WriteMode','append','DelayTime',gifspacing);
    end
end