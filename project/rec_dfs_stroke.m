function [ success ] = rec_dfs_stroke( line, pixel, angle, currentStroke, nline, npix, nbin )
set(0,'RecursionLimit',10000)    
global stroke;
    if stroke(line, pixel, angle)==0
        % boundary control
        
        stroke(line, pixel, angle)=currentStroke;
        for ll=-1:1
            for pp=-1:1
                for aa=-1:1
                    if ll~=0||pp~=0  
                        
                        newline=line+ll;
                        newpixel=pixel+pp;
                        newangle=angle+aa;
                        if newline>nline || newline<1 ...
                            || newpixel>npix || newpixel<1
                            break;
                        end
                        if newangle>nbin
                            newangle=newangle-nbin;
                        end
                        if newangle==0
                            newangle=nbin;
                        end
                        rec_dfs_stroke(newline, newpixel, newangle, currentStroke, nline, npix, nbin);
                    end
                end
            end
        end
    end
    success=1;
end

