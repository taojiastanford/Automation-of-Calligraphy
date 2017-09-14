%12th code, to see the elements in the nth biggest cluster
%Tao Jia, 12/10/16
%Tuning parameter: nthBiggestCluster

[cluster,sample]=find(outputSOM==1);

%freqC=mode(cluster);
clusterX = unique(cluster);
valueCount = histc(cluster, clusterX);
[sortValueCount, sortIndex]=sort(valueCount,'descend');

nthBiggestCluster=30;

samplex=find(cluster==clusterX(sortIndex(nthBiggestCluster)));
figure;
sqrtlensam=ceil(sqrt(length(samplex)));
for ii=1:length(samplex)
    subplot(sqrtlensam,sqrtlensam,ii);
    imagesc(trainSet{samplex(ii)});
end