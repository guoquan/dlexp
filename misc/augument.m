function c = augument(d, c)
    if d > numel(c.stat_feature_augument)
        %c.stat_feature_augument
        % do generate set
        augument_tmp = [];
        target_tmp = [];
        for stat_feature_idx = 1:numel(c.stat_feature)
            feat = c.stat_full_file.(c.stat_feature{stat_feature_idx})';
            feat = feat(:,c.index);
            target_tmp = cat(1, target_tmp, feat);
            if c.stat_feature_augument(stat_feature_idx)
                augument_tmp = cat(1, augument_tmp, zeros(size(feat)));
            else
                augument_tmp = cat(1, augument_tmp, feat );
            end
        end
        c.augument_data = cat(2, c.augument_data , augument_tmp);
        c.target_data = cat(2, c.target_data, target_tmp);
        c.augument_labels = cat(2, c.augument_labels, c.stat_full_file.labels(:, c.index));
    else
        % do coding
        if c.stat_feature_augument(d)
            c = augument(d+1, c);
            c.stat_feature_augument(d) = 0;
            c = augument(d+1, c);
            c.stat_feature_augument(d) = 1;
        else 
            c = augument(d+1, c);
        end
    end
end