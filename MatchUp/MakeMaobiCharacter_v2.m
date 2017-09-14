%16th code, to make the Maobi character by shifting the Maobi strokes
%created from PairMaobiYingbi
%Tao Jia, 12/12/16

%v2: With resized strokes
noStrokeYingbi=size(wordYingbi,1);

maxPix=140;
maxLine=140;
maobiChar=zeros(maxLine*3,maxPix*3);
yingbiChar=zeros(maxLine,maxPix);
for ii=1:noStrokeYingbi
    [lineYingbi,pixYingbi] = find(squeeze(wordYingbiOriginal(ii,:,:)));
    lineYingbiMin = min(lineYingbi);
    lineYingbiMax = max(lineYingbi);
    lineYingbiCent=round((lineYingbiMin+lineYingbiMax)/2);
    lineYingbiDist=(lineYingbiMax-lineYingbiMin);
    lineYingbiDistBy2=round(lineYingbiDist/2);
    pixYingbiMin = min(pixYingbi);
    pixYingbiMax = max(pixYingbi);
    pixYingbiCent=round((pixYingbiMin+pixYingbiMax)/2);
    pixYingbiDist=(pixYingbiMax-pixYingbiMin);
    pixYingbiDistBy2=round(pixYingbiDist/2);
    
    [lineMaobi,pixMaobi] = find(squeeze(wordMaobi(ii,:,:)));
    lineMaobiMin = min(lineMaobi);
    lineMaobiMax = max(lineMaobi);
    lineMaobiDist=(lineMaobiMax-lineMaobiMin);
    lineMaobiDistBy2=round(lineMaobiDist/2);
    pixMaobiMin = min(pixMaobi);
    pixMaobiMax = max(pixMaobi);
    pixMaobiDist=(pixMaobiMax-pixMaobiMin);
    pixMaobiDistBy2=round(pixMaobiDist/2);
    %centMaobi=[round((lineMaobiMin+lineMaobiMax)/2),round((pixMaobiMin+pixMaobiMax)/2)];
    
    chopMaobiMat=squeeze(wordMaobi(ii,lineMaobiMin:lineMaobiMax,pixMaobiMin:pixMaobiMax));
    resizedMaobiMat=imresize(chopMaobiMat,[lineYingbiDist pixYingbiDist]);
    %reResizedMaobiMat=[resizedMaobiMat,]
    
    %Version of resizing
    maobiChar(maxLine+lineYingbiCent-lineYingbiDistBy2+1:maxLine+lineYingbiCent-lineYingbiDistBy2+lineYingbiDist,...
        maxPix+pixYingbiCent-pixYingbiDistBy2+1:maxPix+pixYingbiCent-pixYingbiDistBy2+pixYingbiDist)...
        =resizedMaobiMat+...
        maobiChar(maxLine+lineYingbiCent-lineYingbiDistBy2+1:maxLine+lineYingbiCent-lineYingbiDistBy2+lineYingbiDist,...
        maxPix+pixYingbiCent-pixYingbiDistBy2+1:maxPix+pixYingbiCent-pixYingbiDistBy2+pixYingbiDist);
    
%     maobiChar(maxLine+lineYingbiCent-lineMaobiDistBy2:maxLine+lineYingbiCent-lineMaobiDistBy2+lineMaobiDist,...
%         maxPix+pixYingbiCent-pixMaobiDistBy2:maxPix+pixYingbiCent-pixMaobiDistBy2+pixMaobiDist)...
%         =chopMaobiMat+...
%         maobiChar(maxLine+lineYingbiCent-lineMaobiDistBy2:maxLine+lineYingbiCent-lineMaobiDistBy2+lineMaobiDist,...
%         maxPix+pixYingbiCent-pixMaobiDistBy2:maxPix+pixYingbiCent-pixMaobiDistBy2+pixMaobiDist);
    yingbiChar=yingbiChar+squeeze(wordYingbiOriginal(ii,:,:));
end
maobiCharStandard=maobiChar(maxPix+1:2*maxPix,maxLine+1:2*maxLine);

%After resize, there will be some flakes of pixels
sepa = bwconncomp(maobiCharStandard,18);
cells = sepa.PixelIdxList;

strokeCells = [];
NCells = max(size(cells));

%Too short a component is probably flake
thres = 40; %for ChuSuiliang
ii = 1;
while ii<=max(size(cells))
    
    if max(size(cell2mat(cells(ii))))<=thres
        cells(ii)=[];
    else
        ii=ii+1;
    end
end
maobiCharNoFlake=zeros(size(maobiCharStandard));
pixInComp=zeros(1,max(size(cells)));
for ii=1:max(size(cells))
    [indx1,indx2, indx3]=ind2sub(size(maobiCharStandard),cell2mat(cells(ii)));
    pixInComp(ii)=length(indx1);
        for jj=1:pixInComp(ii)
            maobiCharNoFlake(indx1(jj),indx2(jj))=indx3(jj);
        end
end

maobiCharNoFlake(maobiCharNoFlake>0)=1;
maobiCharNoFlake(maobiCharNoFlake<=0)=0;

% maobiCharStandard(maobiCharStandard>0)=1;
% maobiCharStandard(maobiCharStandard<=0)=0;





yingbiChar(yingbiChar>0)=1;
g=figure;
imagesc(maobiCharNoFlake);
truesize(g,[560 560]);
g=figure;
imagesc(yingbiChar);
truesize(g,[560 560]);