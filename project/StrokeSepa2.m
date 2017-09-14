%Tao Jia 11/17/16, 3rd code
%Tuning parameters: thres, thres_simil, thres_nbin

tic

%Separate the strokes into connected components. Can change "18" to "26"
%for better connectivity.
[nline, npix, nbintimes2]=size(bbod);
nbin=nbintimes2/2;
bbod_knn=bbod;
bbod_knn(bbod_knn<0)=0;
sepa = bwconncomp(bbod_knn,18);
cells = sepa.PixelIdxList;
strokeCells = [];
NCells = max(size(cells));

%Too short a component is probably noise
thres = 40; %for Yingbi
%thres=80;%for LiuGongquan
%thres=120;%for ChuSuiliang
ii = 1;
while ii<=max(size(cells))
    
    if max(size(cell2mat(cells(ii))))<=thres
        cells(ii)=[];
    else

        ii=ii+1;
    end
end

%Convert from cell to individual stroke matrices
default=-10;
strokeMat = ones(max(size(cells)),nline, npix)*default;
pixInStroke=zeros(1,max(size(cells)));
for ii=1:max(size(cells))
%     if ii==24
%         ii;
%     end
    [indx1,indx2, indx3]=ind2sub(size(bbod),cell2mat(cells(ii)));
    pixInStroke(ii)=length(indx1);
        for jj=1:pixInStroke(ii)
            strokeMat(ii,indx1(jj),indx2(jj))=indx3(jj);
        end
%     strokeMat(ii,:,:)=full(sparse(indx1, indx2, indx3, nline, npix));
%     if ii==24
%         strokeMat1=zeros(1,nline,npix);
%         for jj=1:pixInStroke
%             strokeMat1(1,indx1(jj),indx2(jj))=indx3(jj);
%         end
%     end
    ii;
    %strokeMat=full(strokeMat);
end
strokeMat=full(strokeMat);

%As the bbod is doubled to make the "perioditicity", there will be
%redundant strokes.
[npixs,pixRank]=sort(pixInStroke);
fakeStroke=zeros(1,length(pixRank));
simil=zeros(length(pixInStroke));
difNbin=zeros(length(pixInStroke));
thres_simil=0.2;
thres_nbin=1;

% h=waitbar(0,'Be patient!');
for ii=1:length(pixInStroke)
%     waitbar(ii/length(pixInStroke))
    indexii=find(squeeze(strokeMat(pixRank(ii),:,:))>=0);
    for ind=1:length(indexii)
        [indx1,indx2]=ind2sub(size(squeeze(strokeMat(pixRank(ii),:,:))),indexii(ind));
            
        for jj=ii+1:length(pixInStroke)
            if strokeMat(pixRank(ii),indx1,indx2)~=default&&...
               strokeMat(pixRank(jj),indx1,indx2)~=default&&...
               (abs(strokeMat(pixRank(jj),indx1,indx2)-strokeMat(pixRank(ii),indx1,indx2))<=nbin+thres_nbin&&...
               abs(strokeMat(pixRank(jj),indx1,indx2)-strokeMat(pixRank(ii),indx1,indx2))>=nbin-thres_nbin)%||...
               %abs(strokeMat(pixRank(jj),indx1,indx2)-strokeMat(pixRank(ii),indx1,indx2))<=thres_nbin)
%             if (strokeMat(pixRank(jj),indx1,indx2)==strokeMat(pixRank(ii),indx1,indx2)+nbin||...
%                 strokeMat(pixRank(jj),indx1,indx2)==strokeMat(pixRank(ii),indx1,indx2)-nbin) &&...
%                 strokeMat(pixRank(ii),indx1,indx2)~=0
                simil(pixRank(ii),pixRank(jj))=simil(pixRank(ii),pixRank(jj))+1;
                difNbin(pixRank(ii),pixRank(jj))=strokeMat(pixRank(jj),indx1,indx2)...
                    -strokeMat(pixRank(ii),indx1,indx2);
                %simil(pixRank(jj),pixRank(ii))=simil(pixRank(jj),pixRank(ii))+1;
            end
        end
    end
end
for ii=1:length(pixInStroke)
    if ii==11 || ii==20
        ii;
    end
    [countSimii,simii]=max(simil(ii,:));
    if countSimii/pixInStroke(ii)>thres_simil
        fakeStroke(ii)=1;
        
        %Add the rest pixels of the fake stroke
        [rlii,rpii,rbii]=find(squeeze(strokeMat(ii,:,:)~=default));
        for jj=1:length(rlii)
            if strokeMat(simii,rlii,rpii)==default
                strokeMat(simii,rlii,rpii)=rbii+difNbin(ii,simii);
            end
        end
    end
end
fakeStrokeIndex=find(fakeStroke);
strokeMat(fakeStrokeIndex,:,:)=[];
g=figure;
g.OuterPosition=[1200 500 500 500];
noStroke=size(strokeMat,1);
sqrtnoStroke=ceil(sqrt(noStroke));
for ii=1:noStroke
    subplot(sqrtnoStroke,sqrtnoStroke,ii);
    imagesc(squeeze(strokeMat(ii,:,:)/nbin*180));
    title(['Stroke', num2str(ii)]);
end

toc