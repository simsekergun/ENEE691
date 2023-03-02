% this code does the multi-linear regression 
% no of independent variables: 9
% no of dependent variables: 1
clear;
% Set the default values and formats
set(0,'defaultlinelinewidth',2);
set(0,'DefaultAxesFontSize',18);
set(0,'DefaultTextFontSize',18);
% load dataset
load PIN_designs % ths dps1 dps2 Qs Ds Is Ps RFPs

A = [ones(length(ths),1) ths log10(dps1) log10(dps2)]; % bias + dependent variables
y = Qs; % dependent variable

numObservations = length(ths);
numObservationsTrain = floor(0.7*numObservations); % let's use 70% of the data for training
numObservationsTest = numObservations - numObservationsTrain; % rest of testing

% I am not sure whether Matlab has its own
% train-test split. Let's do it manually
% the idea is simple: create a random vector
% and use its order as a random indexing
rng(1); rth = rand(numObservations,1); [asd, idx] = sort(rth); 

idxTrain = idx(1:numObservationsTrain);         % for training
idxTest = idx(numObservationsTrain+1:end);  % for testing

XTrain = A(idxTrain,:);
XValidation = A(idxTest,:);     % validation = testing

YTrain = y(idxTrain);
YValidation = y(idxTest);

solu = XTrain\YTrain;                   % linear regression
YPrediction = XValidation*solu;    % prediction

Rsquare = 1 - sum((YValidation - YPrediction).^2)/sum((YValidation - mean(YValidation)).^2)

aline = [min(YValidation) max(YValidation)]; % for x = y line

figure(1); clf;
plot(YValidation,YPrediction,'ro',aline, aline,'k');
grid on;
axis equal;
axis square;
xlabel('True {\it{Q}}_{eff}');
ylabel('Predicted {\it{Q}}_{eff}');
title(['{{\it{R}}^2: }' num2str(round(1000*Rsquare)/1000)])
