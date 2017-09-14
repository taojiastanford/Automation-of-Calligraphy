%16th code, to make the Maobi character by shifting the Maobi strokes
%created from PairMaobiYingbi
%Tao Jia, 12/12/16

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
    pixYingbiMin = min(pixYingbi);
    pixYingbiMax = max(pixYingbi);
    pixYingbiCent=round((pixYingbiMin+pixYingbiMax)/2);
    
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
    maobiChar(maxLine+lineYingbiCent-lineMaobiDistBy2:maxLine+lineYingbiCent-lineMaobiDistBy2+lineMaobiDist,...
        maxPix+pixYingbiCent-pixMaobiDistBy2:maxPix+pixYingbiCent-pixMaobiDistBy2+pixMaobiDist)...
        =chopMaobiMat+...
        maobiChar(maxLine+lineYingbiCent-lineMaobiDistBy2:maxLine+lineYingbiCent-lineMaobiDistBy2+lineMaobiDist,...
        maxPix+pixYingbiCent-pixMaobiDistBy2:maxPix+pixYingbiCent-pixMaobiDistBy2+pixMaobiDist);
    yingbiChar=yingbiChar+squeeze(wordYingbiOriginal(ii,:,:));
end
maobiCharStandard=maobiChar(maxPix+1:2*maxPix,maxLine+1:2*maxLine);
maobiCharStandard(maobiCharStandard>0)=1;
yingbiChar(yingbiChar>0)=1;
g=figure;
imagesc(maobiCharStandard);
truesize(g,[560 560]);
g=figure;
imagesc(yingbiChar);
truesize(g,[560 560]);