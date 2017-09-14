%Tao Jia 11/17/16, 2nd code
%v2: separate by 45 degrees
%Tuning parameters: nbin, epsilon, co_max, co_mean

% % BBOD of each pixel
index=find(CH>0.5); 
[indx1,indx2]=ind2sub(size(CH),index);
num=length(indx1);
nbin=40;%dtheta=180/nbin
epsilon=1e-2;
bbod=zeros(nline, npix, nbin);
orientation=ones(nline, npix)*(-10);
degree=zeros(num,1);
tic
pix2dis=ones(nbin,1);
for ii=1:nbin
    if ii~=nbin/2
        pix2dis(ii)=1/abs(cos(ii/nbin*pi));
    end
end

% h=waitbar(0,'Be patient!')
for k=1:num
%     waitbar(k/num)
    line=indx1(k);
    pixel=indx2(k);
%      line=113;
%      pixel=58;
    
    count=zeros(nbin,1);
    for i=1:2*nbin
        theta=i*pi/nbin;
        newline=line;newpixel=pixel;
        dist=0;
         if theta==126/180*pi
             theta;
         end
        while CH(newline,newpixel)>=1
            if i>nbin
                count(i-nbin)=count(i-nbin)+1;
                dist=dist+1;
            else
                count(i)=count(i)+1; 
                dist=dist+1;
            end
            % find the next pixel
            toltheta=0.5/180*pi;
           
            if theta<pi/4 || theta>pi*7/4
                newline=round(-tan(theta)*dist+line);
                newpixel=newpixel+1;
            elseif theta<pi*5/4 && theta>pi*3/4
                newline=round(tan(theta)*dist+line);
                newpixel=newpixel-1;
            elseif theta>=pi/4&&theta<=pi*3/4
                newline=newline-1;
                newpixel=round(cot(theta)*dist+pixel);
            else
                newline=newline+1;
                newpixel=round(-cot(theta)*dist+pixel);
            end
           
            % boundary control
            if newline>nline || newline<1 || newpixel>npix || newpixel<1 
                break;
            end
            if theta>pi/2-epsilon && theta<pi/2+epsilon
                theta;
            end
        end
        
        
        
%          end
    end
    thetas=(pi/nbin:pi/nbin:pi)*180/pi;
    % determine the degree of the pixel
%     figure
%     plot(thetas,count)
%        hold on
    %We are counting distance, not just pixel.
    %count=count.*pix2dis;

    %plot(thetas,count)
    count=smooth(count,2);
%     plot(thetas,count)
    count(count<max(1/3*max(count),mean(count)))=0;

%     plot(thetas,count)
%     hold off
    
    [peaks2, loc2]=findpeaks([count;count]);
    
    if isempty(loc2)
        continue;
    end
        
    if length(loc2)>=2
        distmin=round(45/(360/nbin));
        for ii=1:length(loc2)-1
            if ii<length(loc2)
                dist_=abs(loc2(ii)-loc2(ii+1));
                if dist_<distmin
                    peaks2(ii)=[];
                    loc2(ii)=[];
                end
            end
        end
    end
    
    for ii=1:length(loc2)
        
        if loc2(ii)<=nbin
            bbod(line, pixel, loc2(ii))=peaks2(ii);
        else
            bbod(line, pixel, loc2(ii)-nbin)=peaks2(ii);
        end
    end
    
    [peak, peakInd]=max(peaks2);
    if loc2(peakInd)<=nbin%*9/8
        orientation(line, pixel)=loc2(peakInd)/nbin*180;
    else
        orientation(line, pixel)=(loc2(peakInd)-nbin)/nbin*180;
    end
end
toc
bbod=cat(3,bbod,bbod);
figure
imagesc(orientation)
colorbar
hold on