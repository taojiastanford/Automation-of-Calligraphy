%Tao Jia 11/17/16, 4th code

EDGE=2;
BODY=1;
SING=3;
NONE=0;
NEARSING=4;
CHStrokeBin=CH;

%If some point is close enough to SING, it is probably not good to be a
%stroke junction
singRange=2;
thresSing=0.1;
index=find(CHStrokeBin==BODY|CHStrokeBin==EDGE); 
[indx1,indx2]=ind2sub(size(CHStrokeBin),index);
num=length(indx1);
for ii=1:length(index)
    pixNb=0;
    singNb=0;
    for ll=-singRange:singRange
        for pp=-singRange:singRange
            if (indx1(ii)+ll)>0 && (indx1(ii)+ll)<=nline...
                    && (indx2(ii)+pp)>0 && (indx2(ii)+pp)<=npix
                pixNb=pixNb+1;
                if CHStrokeBin(indx1(ii)+ll,indx2(ii)+pp)==SING
                    singNb=singNb+1;
                end
            end
        end
    end
    if singNb/pixNb>thresSing
        CHStrokeBin(indx1(ii),indx2(ii))=NEARSING;
    end
end
figure
imagesc(CHStrokeBin)
colorbar

%If two strokes share a non-SING pixel where they have very different 
%orientations, their similarity +=1
noStroke=size(strokeMat,1);
similarity=zeros(noStroke);
npixs=zeros(noStroke,1);
epsilonPara=30;%in degrees
for ii=1:noStroke
    strokeMatii=squeeze(strokeMat(ii,:,:));
    [lineii,pixii,binii]=find(strokeMatii>0);
    indii=sub2ind(size(strokeMatii),lineii,pixii);
    npixs(ii)=length(lineii);
    for jj=ii+1:noStroke
        strokeMatjj=squeeze(strokeMat(jj,:,:));
        [linejj,pixjj,binjj]=find(strokeMatjj>0);
        indjj=sub2ind(size(strokeMatjj),linejj,pixjj);
        npixs(jj)=length(linejj);
        for pii=1:npixs(ii)
            sameloc=find(indjj==indii(pii));
                
            %The condition: 
            %1 can find this pixel in stroke jj &&
            %(2 this pixel is BODY or EDGE ||
            %3 the two strokes are paralell at this pixel)
            if ~isempty(sameloc)&&...
                (CHStrokeBin(lineii(pii),pixii(pii))==BODY ||...
                CHStrokeBin(lineii(pii),pixii(pii))==EDGE ||...
                mod(abs(strokeMatii(lineii(pii),pixii(pii))-strokeMatjj(lineii(pii),pixii(pii))),nbin)...
                <epsilonPara/180*nbin)

                similarity(ii,jj)=similarity(ii,jj)+1;
            end
        end
    end
end

%If two strokes have high similarity, they are connected
epsilon_simi=1e-2;
connected=zeros(noStroke);
for ii=1:noStroke
    for jj=ii+1:noStroke
        if similarity(ii,jj)/npixs(ii)>epsilon_simi&&similarity(ii,jj)/npixs(jj)>epsilon_simi
            connected(ii,jj)=1;
        end
    end
end

%If two strokes are connected, they share the same label, and are combined
%into a same stroke in newStrokeMat
noRealStroke=noStroke;
labelStroke=1:noStroke;
for ii=1:noStroke
    for jj=ii+1:noStroke
        if connected(ii,jj)==1
            labelStroke(jj)=labelStroke(ii);
        end
    end
end
labels=unique(labelStroke);
newStrokeMat=zeros(length(labels),size(strokeMat,2),size(strokeMat,3));
for ii=1:length(labels)
    for jj=1:noStroke
        if labelStroke(jj)==labels(ii)
            newStrokeMat(ii,:,:)=newStrokeMat(ii,:,:)+strokeMat(jj,:,:);
        end
    end
    figure;
    imagesc(squeeze(newStrokeMat(ii,:,:)/nbin*180));
    title(['BinnedStroke', num2str(labels(ii))]);
    
end

