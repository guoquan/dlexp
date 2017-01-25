%% prepare
close all; pause(0.01);
clear
clc

include

%% configurate
inputSize = 28 * 28;
numClasses = 5;
train_num = 60000;
test_num = 10000;

network.minOptions.maxIter = 400;
network.minOptions.Display = 'iter'; % Level of display [ off | final | (iter) | full | excessive ]

%% configurate network
network.layerSize = [inputSize 200 200 numClasses];
network.f.f = {getSigmoid getSigmoid};
network.f.b = {getSigmoid getSigmoid};
network.hasBias.f = [1 1 1];
network.hasBias.b = [1 1];
network.out.f = getBatchSoftmax;
network.out.cost = getBatchSoftmaxCost;

% pretrainHooks
weightdecay_hook.f = @SBPWeightDecay;
weightdecay_hook.opt.decay = [1 1];
weightdecay_hook.opt.lambda = 3e-3;

sparse_hook.f = @SBPKLSparse;
sparse_hook.opt.sparse = [0 1 0];
sparse_hook.opt.rho = 0.1;
sparse_hook.opt.beta = 3;

network.pretrainHooks = {weightdecay_hook, sparse_hook};

% finetuneHooks
weightdecay_ft_hook.f = @SBPWeightDecay;
weightdecay_ft_hook.opt.decay = [0 0 1];
weightdecay_ft_hook.opt.lambda = 1e-4;

network.finetuneHooks = {weightdecay_ft_hook};

%% load training data
fprintf(1, '---------------------------------\n');
fprintf(1, '=========== Load Data ===========\n');
prefix = '../shared/data/mnist/';
addpath(prefix);
mnistData   = loadMNISTImages([prefix 'train-images-idx3-ubyte'], train_num);
[mnistLabels, m] = loadMNISTLabels([prefix 'train-labels-idx1-ubyte'], train_num);

% Simulate a Labeled and Unlabeled set
labeledSet   = find(mnistLabels >= 0 & mnistLabels <= 4);
unlabeledSet = find(mnistLabels >= 5);

numTrain = round(numel(labeledSet)/2);
trainSet = labeledSet(1:numTrain);
testSet  = labeledSet(numTrain+1:end);

unlabeledData = mnistData(:, unlabeledSet);

trainData   = mnistData(:, trainSet);
trainLabels = mnistLabels(trainSet)' + 1; % Shift Labels to the Range 1-5
trainGroundTruth = full(sparse(trainLabels, 1:numel(trainLabels), 1));

testData   = mnistData(:, testSet);
testLabels = mnistLabels(testSet)' + 1;   % Shift Labels to the Range 1-5
testGroundTruth = full(sparse(testLabels, 1:numel(testLabels), 1));

% Output Some Statistics
fprintf('# examples in unlabeled set: %d\n', size(unlabeledData, 2));
fprintf('# examples in supervised training set: %d\n\n', size(trainData, 2));
fprintf('# examples in supervised testing set: %d\n\n', size(testData, 2));

%% pre-train
fprintf(1, '---------------------------------\n');
fprintf(1, '========= Pre-trainning =========\n');
[thetaPre, ~] = SAEPreTrain(network, unlabeledData);

%% display first layer feature
sae = getEncoderNetwork(network);
stack = paramUnfold(thetaPre, sae);
w1 = stack{1}.w;
%w2 = stack{2}.w;
display_network(w1');

%% finetune
fprintf(1, '=========== Finetune  ===========\n');
[thetaOpt, ~] = SAEFinetune(thetaPre, network, trainData, trainGroundTruth);

%% display first layer feature
figure
sae = getFeadForwardNetwork(network);
stack = paramUnfold(thetaOpt, sae);
w1 = stack{1}.w;
%w2 = stack{2}.w;
display_network(w1');

%% Softmax
fprintf(1, '---------------------------------\n');
fprintf(1, '======== Train a Softmax ========\n');
trainFeature = SAEFeatureForward(thetaPre, trainData, network, []);
[thetaSoftmax, ~] = SAESoftmax(network, trainFeature, trainGroundTruth);

%% train a big bp
fprintf(1, '---------------------------------\n');
fprintf(1, '========= Training a BP =========\n');
bp = getFeadForwardNetwork(network);

thetaInit_bp = SBPInitParam(bp);
[thetaOpt_bp, ~] = SBPTrain(thetaInit_bp, bp, trainData, trainGroundTruth);

%% test and result
fprintf(1, '======== Testing Models  ========\n');

fprintf('                               \t\t\t\tAccuracy\tPrecision\tRecall\tF1\n');
result = SBPFeedforward(thetaOpt_bp, testData, bp, []);
[ accuracy_bp, precision_bp, recall_bp, f1_bp ] = pr_result( result, testGroundTruth );
fprintf('Test Accuracy without pretrain:\t\t\t\t%f\t%f\t%f\t%f\n', accuracy_bp, mean(precision_bp), mean(recall_bp), mean(f1_bp));

result = SAEFeedForward([thetaPre; thetaSoftmax], testData, network, []);
[ accuracy_soft, precision_soft, recall_soft, f1_soft ] = pr_result( result, testGroundTruth );
fprintf('Test Accuracy without finetune:\t\t\t\t%f\t%f\t%f\t%f\n', accuracy_soft, mean(precision_soft), mean(recall_soft), mean(f1_soft));

result = SAEFeedForward(thetaOpt, testData, network, []);
[ accuracy, precision, recall, f1 ] = pr_result( result, testGroundTruth );
fprintf('Test Accuracy with pretrain and finetune:\t%f\t%f\t%f\t%f\n', accuracy, mean(precision), mean(recall), mean(f1));