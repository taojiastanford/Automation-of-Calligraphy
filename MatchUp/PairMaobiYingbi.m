%15th code, to find the corresponding Maobi stroke for a certain Yingbi
%character
%Tao 12/11/16

clusterChuX = unique(clusterChu);
valueCountChu = histc(clusterChu, clusterChuX);
[sortValueCountChu, sortIndexChu]=sort(valueCountChu,'descend');
maobiLabel=chuLabels;

noYingbi=164126;
%folder='C:\Users\Tao\Google Drive\Course\CS\CS229\ChineseCalligraphy\Characters\ChuSuiliang';
filesYingbi = dir([num2str(noYingbi),'*']);
noStrokeYingbi=length(filesYingbi);

maxPix=140;
maxLine=140;
wordMaobi=zeros(noStrokeYingbi,maxLine,maxPix);
wordYingbi=zeros(noStrokeYingbi,maxLine,maxPix);
wordYingbiOriginal=zeros(noStrokeYingbi,maxLine,maxPix);
for jj=1:noStrokeYingbi
    stsYingbi = load(filesYingbi(jj).name);
    [dataYingbijj,dataYingbiOrigin,labelYingbijj]=fnMakeBinaryImage(stsYingbi);
    
    featYingbijj=encode(autoencCen,dataYingbijj);
    featYingbijjLabel=[featYingbijj;labelYingbijj*10];
    outYingbijj=net(featYingbijjLabel);
    clusterYingbijj=find(outYingbijj==1);
    maobiNeibjj=find(clusterChu==clusterYingbijj);
    if isempty(maobiNeibjj)
        maobiSameLabeljj=find(maobiLabel==labelYingbijj);
        randS=ceil(rand()*length(maobiSameLabeljj));
        dataMaobijj=cellChu{maobiSameLabeljj(randS)};
    else
        randS=ceil(rand()*length(maobiNeibjj));
        dataMaobijj=cellChu{maobiNeibjj(randS)};
    end
    wordYingbiOriginal(jj,:,:)=dataYingbiOrigin;
    wordYingbi(jj,:,:)=dataYingbijj;
    wordMaobi(jj,:,:)=dataMaobijj;
end
sqrtNoStroke=ceil(sqrt(noStrokeYingbi));
figure;
for ii=1:noStrokeYingbi
    subplot(sqrtNoStroke,sqrtNoStroke,ii);
    imagesc(squeeze(wordYingbi(ii,:,:)));
end
figure;
for ii=1:noStrokeYingbi
    subplot(sqrtNoStroke,sqrtNoStroke,ii);
    imagesc(squeeze(wordMaobi(ii,:,:)));
end