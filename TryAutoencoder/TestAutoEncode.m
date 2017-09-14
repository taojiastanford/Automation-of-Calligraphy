%9th code, to generate test error using softmax
%Tao Jia, 12/09/16
featTest = encode(autoenc1,testSet);
testLabelMat=zeros(33,length(testLabel));
for ii=1:length(testLabel)
    if testLabel(ii)>0
        testLabelMat(testLabel(ii),ii)=1;
    end
end

softnetTest = trainSoftmaxLayer(featTest,testLabelMat,'MaxEpochs',400);

Y = softnetTest(featTest);
Y1=Y(Y>0.5);
[name,num]=find(Y>0.5);
countCorrectTest=0;
for ii=1:length(testLabel)
    if name(ii)==testLabel(ii)
        countCorrectTest=countCorrectTest+1;
    end
end

testError=1-countCorrectTest/length(testLabel)
compareName=[name testLabel];






showOption=1;%When 1, show first 16 strokes
if showOption==1
%     figure;
%     for i = 1:16
%         subplot(4,4,i);
%         imshow(testSet{i});
%     end
    testReconstructed = predict(autoenc1,testSet);
    figure;
    for i = 1:16
        subplot(4,4,i);
        imagesc(testReconstructed{i});
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
        nameArray{ii}=strokeName(name(ii))
        imagesc(testSet{ii});
        pause(1);
    end
end