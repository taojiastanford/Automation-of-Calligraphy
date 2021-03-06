%11th code, generated by SOM, to get SOM model

% Solve a Clustering Problem with a Self-Organizing Map
% Script generated by Neural Clustering app
% Created 10-Dec-2016 10:18:30
%
% This script assumes these variables are defined:
%
%   feat1 - input data.

x = featAllLabel;

% Create a Self-Organizing Map
dimension1 = 10;
dimension2 = 10;
net = selforgmap([dimension1 dimension2]);

% Train the Network
[net,tr] = train(net,x);

% Test the Network
y = net(x);

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotsomtop(net)
%figure, plotsomnc(net)
%figure, plotsomnd(net)
%figure, plotsomplanes(net)
%figure, plotsomhits(net,x)
%figure, plotsompos(net,x)

