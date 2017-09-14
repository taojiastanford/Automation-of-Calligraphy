sepa = bwconncomp(orientation);
cells = sepa.PixelIdxList;
strokeCells = [];
NCells = max(size(cells));
bbod_knn=bbod;
bbod_knn(bbod_knn<0)=-500;

thres = 100;
ii = 1;
while ii<=max(size(cells))
    
    if max(size(cell2mat(cells(ii))))<=thres
        cells(ii)=[];
    else

        ii=ii+1;
    end
end


strokeMat = ones(max(size(cells)),nline, npix)*(-10);
pixInStroke=zeros(1,max(size(cells)));
for ii=1:max(size(cells))
        
        [indx1,indx2, indx3]=ind2sub(size(bbod),cell2mat(cells(ii)));
        pixInStroke(ii)=length(indx1);
        strokeMat(ii,:,:)=sparse(indx1, indx2, indx3, nline, npix);
        strokeMat=full(strokeMat);
        strokeMat=strokeMat/nbin*180;
        figure;
        imagesc(squeeze(strokeMat(ii,:,:)));
end

[~,pixRank]=sort(pixInStroke);
fakeStroke=zeros(1,length(pixRank));
for ii=1:length(pixInStroke)
    indexii=find(squeeze(strokeMat(pixRank(ii),:,:))>=0);
    for ind=1:length(indexii)
        [indx1,indx2]=ind2sub(size(squeeze(strokeMat(pixRank(ii),:,:))),indexii(ind));
            
        for jj=ii+1:length(pixInStroke)
            if strokeMat(pixRank(jj),indx1,indx2)==strokeMat(pixRank(ii),indx1,indx2)+nbin||...
                strokeMat(pixRank(jj),indx1,indx2)==strokeMat(pixRank(ii),indx1,indx2)-nbin
                fakeStroke(pixRank(ii))=1;
            end
        end
    end
end

% ii=1;
% while ii<=size(strokeMat,1)

% for ss=1:nos
% index=find(CH>0.5); 

