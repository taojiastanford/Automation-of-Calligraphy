%% add labels to the feat matrix
%output feat1Label

feat1Label = [feat1;(trainLabel*10)'];
featTestLabel = [featTest;(testLabel*10)'];
featAllLabel = [feat1Label featTestLabel];

