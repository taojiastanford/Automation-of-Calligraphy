%% 11th code. add labels to the feat matrix
%Haoli Guo, 12/10/2016
%output feat1Label

feat1Label = [feat1;(trainLabel*10)'];
featTestLabel = [featTest;(testLabel*10)'];
featAllLabel = [feat1Label featTestLabel];

