%14th code, to cluster Maobi strokes with Yingbi autoencoder and SOM
featChu = encode(autoencCen,cellChu);
chuLabelMat=zeros(33,length(testLabel));
for ii=1:length(chuLabels)
    if chuLabels(ii)>0
        chuLabelMat(chuLabels(ii),ii)=1;
    end
end

featChuLabel = [featChu;(chuLabels*10)'];

outChu=net(featChuLabel);

[clusterChu,sampleChu]=find(outChu==1);

clusterChuX = unique(clusterChu);
valueCountChu = histc(clusterChu, clusterChuX);
[sortValueCountChu, sortIndexChu]=sort(valueCountChu,'descend');

showClusterOption=0;
if showClusterOption==1
    nthBiggestCluster=3;

    samplexChu=find(clusterChu==clusterChuX(sortIndexChu(nthBiggestCluster)));
    figure;
    sqrtlensamChu=ceil(sqrt(length(samplexChu)));
    for ii=1:length(samplexChu)
        subplot(sqrtlensamChu,sqrtlensamChu,ii);
        imagesc(cellChu{samplexChu(ii)});
    end
end

softmaxOption=0;
if softmaxOption==1
    softnetChu = trainSoftmaxLayer(featChu,chuLabelMat,'MaxEpochs',400);

    Y = softnetChu(featChu);
    Y1=Y(Y>0.5);
    [name,num]=find(Y>0.5);
    countCorrectChu=0;
    for ii=1:length(chuLabels)
        if name(ii)==chuLabels(ii)
            countCorrectChu=countCorrectChu+1;
        end
    end

    chuError=1-countCorrectChu/length(chuLabels)
    compareName=[name chuLabels];

    showOption=0;%When 1, show first 16 strokes
    if showOption==1
    %     figure;
    %     for i = 1:16
    %         subplot(4,4,i);
    %         imshow(testSet{i});
    %     end
        chuReconstructed = predict(autoencCen,cellChu);
        figure;
        for i = 1:16
            subplot(4,4,i);
            imagesc(chuReconstructed{i});
        end

        strokeName={'h','s','p','d','hz','n','t','hzg','sg','hp','hg',...
            'swg','pz','st','sz','pd','szzg','xg','hzwg',...
            'hzt','wg','hzwg','sw','hzw','hzzzg','hxg','hzzp',...
            'szp','szz','hzz','hzzz','b','o'};
        figure;
        nameArray=cell(16,1);
        for ii=1:16
            subplot(4,4,ii);
            %ntitle(strokeName(name(ii)));
            nameArray{ii}=strokeName(name(ii));
            imagesc(cellChu{ii});
            pause(1);
        end
    end
end