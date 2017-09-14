%Tao Jia 12/07/16, 5th code
%Tuning parameter: leftPrio

strokeName={'h','s','p','d','hz','n','t','hzg','sg','hp','hg',...
    'swg','pz','st','sz','pd','szzg','xg','hzwg',...
    'hzt','wg','hzwg','sw','hzw','hzzzg','hxg','hzzp',...
    'szp','szz','hzz','hzzz','b','o'};
BAD=length(strokeName)-1;
OTHER=length(strokeName);

%To give center of substroke, for ranking substrokes
strokeStruct=[];

x = inputdlg('Enter space-separated numbers for each stroke:',...
             'Stroke', [1 50]);

strokes=strsplit(x{:});
data=zeros(size(strokes));
for ii=1:length(strokes)
    for jj=1:length(strokeName)
        if strcmp(strokeName(jj),strokes{ii})
            data(ii)=jj;
        end
    end
end

for jj=1:noNewStroke
    if data(jj)==BAD
        noBadStroke=noBadStroke+1;
        continue;
    elseif data(jj)==OTHER
        noOtherStroke=noOtherStroke+1;
    else
        noTotStroke=noTotStroke+1;
    end
    
    subjj=find(binLabel==jj);%substrokes of stroke jj
    noSubjj=length(subjj);
    coStroke=zeros(noSubjj,2);
    prioStroke=zeros(noSubjj,1);%left first, then up first. Bigger prioStroke=in front.
    
    
    for ii=1:noSubjj
        [lineii,pixii,binii]=find(squeeze(strokeMat(subjj(ii),:,:))>0);
        coStroke(ii,:)=[mean(lineii),mean(pixii)];
        meanAngle=binii/nbin*180;
        leftPrio=10;
        prioStroke(ii)=(npix-coStroke(ii,2))*leftPrio-coStroke(ii,1);
    end
    %subStrokeMat=sparse(subStrokeMat);
    [~,seqSubStroke]=sort(prioStroke,'descend');
    
    subStrokeMat=zeros(noSubjj,nline,npix);
    for ii=1:noSubjj
        subStrokeMat(ii,:,:)=strokeMat(subjj(seqSubStroke(ii)),:,:);
    end
    stStroke=struct('noSubstroke',noSubjj,'name',data(jj),'BBODs',subStrokeMat);
    
    
    

    
    if noSubjj>1&&data(jj)~=BAD
        g=figure;
        g.OuterPosition=[1000 0 500 500];
        sqrtnoSubStroke=ceil(sqrt(noSubjj));
        for ii=1:noSubjj
            subplot(sqrtnoSubStroke,sqrtnoSubStroke,ii);
            imagesc(squeeze(subStrokeMat(ii,:,:)/nbin*180));
            title(['BinnedStroke', num2str(ii)]);
            drawnow
            
            pause(1);
        end
    end

    save([folder,'\',num2str(wordNow),'_',num2str(jj)],'stStroke');
end
