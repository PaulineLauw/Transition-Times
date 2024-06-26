function perform_statistical_analysis(vector_seconds)
    feature_names = {'meanRR_all', 'rmssd_all', 'sdnn_all', 'lf_power_all', 'hf_power_all', 'lf_hf_ratio_all', ...
                         'sd1_all', 'sd2_all', 'sd1_sd2_ratio_all'};
                        
  

    p_values_matrix = strings(length(vector_seconds), length(feature_names)); % Initialize as string array

    % Loop through each feature name
    for f = 1:length(feature_names)
        feature_name = feature_names{f};
        
        % Loop through each number of seconds
        for s = 1:length(vector_seconds)
            num_seconds = vector_seconds(s);
            data = load(sprintf('structured_features_%dsec.mat', num_seconds));
            
            AI_feature_name = ['AI_', feature_name];
            NAI_feature_name = ['NAI_', feature_name];
            
            anx = data.(AI_feature_name);
            non_anx = data.(NAI_feature_name);
            
            % Perform Wilcoxon rank-sum test
            [p_wilcoxon_ecg, ~, ~] = ranksum(anx, non_anx);
            
            % Perform two-sample t-test
            [~, p_ttest_ecg, ~, ~] = ttest2(anx, non_anx);
            
            % Store p-values in the matrices
            p_values_matrix(s, f) = sprintf('%.4f', p_wilcoxon_ecg); % Format as string with four decimal places
        end
    end

    save('p_values_ecg_all.mat', 'p_values_matrix');
end