%8th code, train autoencoder and softmax for training data
%Tao, 12/10/16

%Train autoencoder, it takes ~40 min in Tao's computer

hiddenSize1=400;
autoencCen = trainAutoencoder(trainSet,hiddenSize1, ...
    'MaxEpochs',400, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);


%In case you got autoencoder already
%autoencCen=load(['C:\Users\Tao\Google Drive\Course\CS\CS229\ChineseCalligraphy\code\TryAutoencoder\Network\','autuencCen']);

feat1 = encode(autoencCen,trainSet);

optionSoftmax=1;
if optionSoftmax==1
    trainLabelMat=zeros(33,length(trainLabel));
    for ii=1:length(trainLabel)
        if trainLabel(ii)>0
            trainLabelMat(trainLabel(ii),ii)=1;
        end
    end

    softnetTrain = trainSoftmaxLayer(feat1,trainLabelMat,'MaxEpochs',2000);

    Y = softnetTrain(feat1);
    Y1=Y(Y>0.5);
    [name,num]=find(Y>0.5);

    countCorrectTrain=0;
    for ii=1:length(trainLabel)
        if name(ii)==trainLabel(ii)
            countCorrectTrain=countCorrectTrain+1;
        end
    end

    trainError=1-countCorrectTrain/length(trainLabel)

    showOption=0;%When 1, show first 16 strokes
    if showOption==1
        strokeName={'h','s','p','d','hz','n','t','hzg','sg','hp','hg',...
            'swg','pz','st','sz','pd','szzg','xg','hzwg',...
            'hzt','wg','hzwg','sw','hzw','hzzzg','hxg','hzzp',...
            'szp','szz','hzz','hzzz','b','o'};
        figure;
        nameArray=cell(1,16);
        for ii=1:16
            subplot(4,4,ii);
            %ntitle(strokeName(name(ii)));
            nameArray{ii}=strokeName(name(ii))
            imagesc(trainSet{ii});
            pause(1);
        end
    end
end