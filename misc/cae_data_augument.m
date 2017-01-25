function [augument_data, target_data, augument_labels] = cae_data_augument(stat_full_file, index, stat_feature, stat_feature_augument)
%CAE_DATA_AUGUMENT Summary of this function goes here
%   Detailed explanation goes here
    c.stat_full_file = stat_full_file;
    c.index = index;
    c.stat_feature = stat_feature;
    c.stat_feature_augument = stat_feature_augument;
    c.augument_data = [];
    c.target_data = [];
    c.augument_labels = [];
    c = augument(1, c);
    augument_data = c.augument_data;
    target_data = c.target_data;
    augument_labels = c.augument_labels;
end

