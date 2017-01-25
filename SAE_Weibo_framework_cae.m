isclean = true;

%% prepare
if isclean 
    close all
    clear
    clc
    
    include
    isclean = true;% is cleaned out...
end


%% configurate
stat_prefix = '../shared/data/weibo/';
addpath(stat_prefix);
stat_full_file_prefix = 'all.mat';
stat_full_file = load([stat_prefix stat_full_file_prefix]);

stat_features = {{'feature_content', 'feature_visual', 'feature_social'}};
stat_features_augument = {[0 1 1]}; % augument a training set with the feature set to 0 if this set to 1
stat_n = numel(stat_features);
stat_m = numel(stat_full_file.train_index);
stat_l = 15;

%% configurate network
inputSize = 0;
numClasses = 2;%size(trainClassification, 1);
network.layerSize = [inputSize 100 100 numClasses];
network.f.f = {getSoftplus getSoftplus};
network.f.b = {getSoftplus getSoftplus};
network.hasBias.f = [1 1 0];
network.hasBias.b = [1 1 ];
network.out.f = getBatchSoftmax;
network.out.cost = getBatchSoftmaxCost;

%------------- finetune plugin
weightdecay_hook.f = @SBPWeightDecay;
weightdecay_hook.opt.decay = [0 0 1];
weightdecay_hook.opt.lambda = 1e-1;
network.finetuneHooks = {weightdecay_hook};

%------------- pretrain plugin
weightdecay_hook.f = @SBPWeightDecay;
weightdecay_hook.opt.decay = [1 1];
weightdecay_hook.opt.lambda = 2e-1;

sparse_hook.f = @SBPKLSparse;
sparse_hook.opt.sparse = [0 1 0];
sparse_hook.opt.rho = 0.25;
sparse_hook.opt.beta = 4;
network.pretrainHooks = {weightdecay_hook, sparse_hook};

network.minOptions.maxIter = 400;
network.minOptions.Display = 'final'; % Level of display [ off | final | (iter) | full | excessive ]

%% prepare loop
if isclean 
    stat_accuracys = zeros(stat_m, stat_n, stat_l);
    stat_precisions = zeros(stat_m, stat_n, stat_l);
    stat_recalls = zeros(stat_m, stat_n, stat_l);
    stat_f1s = zeros(stat_m, stat_n, stat_l);
    stat_confusion = cell(stat_m, stat_n, stat_l);
end

for stat_feature_set_idx = 1:stat_n
    stat_full_data = [];
    for stat_feature_idx = 1:numel(stat_features{stat_feature_set_idx})
        stat_full_data = cat(1, stat_full_data, stat_full_file.(stat_features{stat_feature_set_idx}{stat_feature_idx})');
    end

    inputSize = size(stat_full_data, 1);
    network.layerSize = [inputSize 400 400 numClasses];
    for stat_ex_idx = 1:stat_m
        fprintf(1, '---------------------------------\n');
        fprintf('feature %d - ex %d\n', stat_feature_set_idx, stat_ex_idx);
        % trainData trainLabels
        trainData = stat_full_data(:,stat_full_file.train_index{stat_ex_idx});
        trainLabels = stat_full_file.labels(:,stat_full_file.train_index{stat_ex_idx});
        
        % testData testLabels
        testData = stat_full_data(:,stat_full_file.test_index{stat_ex_idx});
        testLabels = stat_full_file.labels(:,stat_full_file.test_index{stat_ex_idx});
        
        %% pre-train
        fprintf(1, '---------------------------------\n');
        fprintf(1, '========= Pre-trainning =========\n');
        
        [augument_data, target_data, augument_labels] = cae_data_augument(stat_full_file, stat_full_file.train_index{stat_ex_idx}, stat_features{stat_feature_set_idx}, stat_features_augument{stat_feature_set_idx});

        [thetaPre, ~] = SAEPreTrain(network, augument_data, target_data);
        
        %-----------------------------------------------------------------------
        for stat_label_idx = 1:size(trainLabels,1)
            fprintf(1, '---------------------------------\n');
            fprintf('Label %d\n', stat_label_idx);
            %% finetune
            fprintf(1, '---------------------------------\n');
            fprintf(1, '=========== Finetune  ===========\n');
            labels = augument_labels(stat_label_idx, :) + 1;
            gt = full(sparse(labels, 1:numel(labels), 1));
            [thetaOpt, ~] = SAEFinetune(thetaPre, network, augument_data, gt);
            
            result = SAEFeedForward(thetaOpt, augument_data, network, []);
            [ accuracy, precision, recall, f1 ] = pr_result( result, gt );
            fprintf('Train result:\t%f\t%f\t%f\t%f\n', accuracy, mean(precision), mean(recall), mean(f1));
            
            labels = testLabels(stat_label_idx, :) + 1;
            gt = full(sparse(labels, 1:numel(labels), 1));
            result = SAEFeedForward(thetaOpt, testData, network, []);
            [ accuracy, precision, recall, f1, confusion ] = pr_result( result, gt );
            fprintf('Test result:\t%f\t%f\t%f\t%f\n', accuracy, mean(precision), mean(recall), mean(f1));
            
            stat_accuracys(stat_ex_idx, stat_feature_set_idx, stat_label_idx) = accuracy;
            stat_precisions(stat_ex_idx, stat_feature_set_idx, stat_label_idx) = mean(precision);
            stat_recalls(stat_ex_idx, stat_feature_set_idx, stat_label_idx) = mean(recall);
            stat_f1s(stat_ex_idx, stat_feature_set_idx, stat_label_idx) = mean(f1);
            stat_confusion{stat_ex_idx, stat_feature_set_idx, stat_label_idx} = confusion;
        end
        %-0---------------------------------------------------------------------
        
    end
end
