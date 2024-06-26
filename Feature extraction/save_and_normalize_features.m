function save_and_normalize_features(number_sec, number_seconds, patient_numbers)
    % Convert struct to matrix
    feature_names = fieldnames(number_seconds(1));
    num_features = length(feature_names);
    num_patients = length(patient_numbers);

    features_matrix = zeros(num_patients, num_features);
    for j = 1:num_features
        for i = 1:num_patients
            features_matrix(i, j) = number_seconds(i).(feature_names{j});
        end
    end

    % Save features matrix to .mat file
    save(sprintf('second_%d_features.mat', number_sec), 'features_matrix');
    disp(['Saved features for ', num2str(number_sec), ' seconds segment.']);

    % Min-Max normalization per feature
    for j = 1:num_features
        if all(real(features_matrix(:, j)) == 1)
            continue; % Skip normalization if all elements are 1
        end
        min_val = min(features_matrix(:, j));  % Ensure real part only
        max_val = max(features_matrix(:, j));  % Ensure real part only
        features_matrix(:, j) = (features_matrix(:, j) - min_val) / (max_val - min_val);
    end

    % Save normalized features to .mat file
    save(sprintf('normalized_second_%d_features.mat', number_sec), 'features_matrix');
    disp(['Saved normalized features for ', num2str(number_sec), ' seconds segment.']);
end

