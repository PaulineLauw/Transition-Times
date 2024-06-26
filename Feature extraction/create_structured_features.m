function create_structured_features(vector_seconds)
    % Determine the feature names based on the feature type
    
     feature_names = {'AI_meanRR_all', 'AI_rmssd_all', 'AI_sdnn_all', 'AI_lf_power_all', 'AI_hf_power_all', 'AI_lf_hf_ratio_all', ...
                         'AI_sd1_all', 'AI_sd2_all', 'AI_sd1_sd2_ratio_all', ...
                         'NAI_meanRR_all', 'NAI_rmssd_all', 'NAI_sdnn_all', 'NAI_lf_power_all', 'NAI_hf_power_all', 'NAI_lf_hf_ratio_all', ...
                         'NAI_sd1_all', 'NAI_sd2_all', 'NAI_sd1_sd2_ratio_all'};
    

    for num_seconds = vector_seconds    
        % Load the provided .mat file
        load(sprintf('normalized_second_%d_features.mat', num_seconds));
           
        % Create a struct to hold the features
        features_struct = struct();
        
        % Assign each column of the features_matrix to the corresponding field in the struct
        for i = 1:length(feature_names)
            features_struct.(feature_names{i}) = features_matrix(:, i);
        end
        
        % Save the new .mat file with the struct
        save(sprintf('structured_features_%dsec.mat', num_seconds), '-struct', 'features_struct');
    end
end