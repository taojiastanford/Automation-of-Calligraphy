% PBOD
clear;clc;close all;

% read characters into a matrix CH
CH=imread('Yingbi_163140.gif');
CH=double(CH);
nline=size(CH,1);npix=size(CH,2);
indx=find(CH<0.5);indx0=find(CH>0.5);
CH(indx)=1;CH(indx0)=0;
figure
imagesc(CH)
colorbar

% PBOD of each pixel
index=find(CH>0.5); 
[indx1,indx2]=ind2sub(size(CH),index);
num=length(indx1);
nbin=40;
degree=zeros(num,1);
tic
figure
h=waitbar(0,'Be patient!')
for k=1:num
    waitbar(k/num)
    line=indx1(k);
    pixel=indx2(k);
%     line=109;
%     pixel=59;
    
    count=zeros(nbin,1);
    for i=1:nbin
        theta=i*2*pi/nbin;
        newline=line;newpixel=pixel;
        newlinesc=newline;newpixelsc=newpixel;
        dist=0;
%          if theta==162/180*pi
        while length(find(CH(newlinesc,newpixelsc)>0.5))>=1
             count(i)=count(i)+1; 
             dist=dist+1;
            % find the next pixel
            toltheta=1/180*pi;
           
            if theta<pi/2 || theta>pi/2*3
                newline=round(-tan(theta)*dist+line);
                newline1=round(-tan(theta-toltheta)*dist+line);
                newline2=round(-tan(theta+toltheta)*dist+line);
                newpixel=newpixel+1;
                newlinesc=max(1,min(newline1,newline2)):min(nline,max(newline1,newline2));
                newpixelsc=newpixel;
                else if theta<pi/2*3 && theta>pi/2
                    newline=round(tan(theta)*dist+line);
                    newline1=round(tan(theta-toltheta)*dist+line);
                    newline2=round(tan(theta+toltheta)*dist+line);
                    newpixel=newpixel-1;
                    newlinesc=max(1,min(newline1,newline2)):min(nline,max(newline1,newline2));
                    newpixelsc=newpixel;
                        else
                            newline=line+dist*sign(theta-pi);
                            newpixel=pixel;
                            newpixelsc=max(pixel-dist,1):min(npix,pixel+dist);
                            newlinesc=newline;
                    end
            end
           
            % boundary control
            if newline>nline || newline<1 || newpixel>npix || newpixel<1
                break;
            end
      
        end
%          end
    end
    thetas=(2*pi/nbin:2*pi/nbin:2*pi)*180/pi;
    % determine the degree of the pixel
%     plot(thetas,count)
    count(count<max(1/5*max(count),2*mean(count)))=0;
%     hold on
%     plot(thetas,count)
%     hold off
%     
    [peaks, loc]=findpeaks(count);
    numfalsepeak=0;
    
    if length(loc)>=2
        dist_=zeros(length(loc)-1,1);
        for ii=1:length(loc)-1
            dist_(ii)=abs(loc(ii)-loc(ii+1));
        end
        distmin=round(45/(360/nbin));
        falsepeak=find(dist_<distmin);
        numfalsepeak=length(falsepeak);
    end
    numpeaks=length(findpeaks(count))-numfalsepeak;
    
    [peaks2, loc2]=findpeaks([count;count]);
    numfalsepeak=0;
    if length(loc2)>=2
        dist_=zeros(length(loc2)-1,1);
        for ii=1:length(loc2)-1
            dist_(ii)=abs(loc2(ii)-loc2(ii+1));
        end
        distmin=round(45/(360/nbin));
        falsepeak=find(dist_<distmin);
        numfalsepeak=length(falsepeak);
    end
    numpeaks2=length(findpeaks([count;count]))-numfalsepeak;
    if numpeaks2>2*numpeaks
        degree(k)=numpeaks+1;
    else
        degree(k)=numpeaks;
    end
end
toc

edgeindx=sub2ind(size(CH),indx1(degree==1),indx2(degree==1));
bodyindx=sub2ind(size(CH),indx1(degree==2),indx2(degree==2));
singindx=sub2ind(size(CH),indx1(degree>=3),indx2(degree>=3));
CH(edgeindx)=2;
CH(singindx)=3;
figure
imagesc(CH)
colorbar