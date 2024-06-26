function process_data(portion, sampling_freq, patient_numbers)
    % Calculate sample indices based on portion
    duration_seconds = [6, 196, 119, 218, 97, 317, 231, 882, 420];
    samples = duration_seconds * sampling_freq;
    samples_sum = cumsum(samples);
    numbers = regexp(portion, '\d', 'match');
    first_number = str2double(numbers{1});
    second_number = str2double(numbers{2});
    end_index_elements = samples_sum(first_number + 1);
    start_index_elements = samples_sum(second_number);
    
    % Add 5 seconds to beginning of clip 5 for analysis
    if strcmp(portion, '4VS5')
        start_index_elements = samples_sum(second_number)+(5*sampling_freq);
    end

    % Vector of seconds to process
    vector_seconds = 4:30;

    for number_sec = vector_seconds 
        % Initialize structure to hold features
        features_struct = struct('AI_meanRR', [], 'AI_rmssd', [], 'AI_sdnn', [], 'AI_lf_power', [], 'AI_hf_power', [], 'AI_lf_hf_ratio', [],'AI_sd1', [], 'AI_sd2', [], ...
                                     'AI_sd1_sd2_ratio', [], ...
                                     'NAI_meanRR', [], 'NAI_rmssd', [], 'NAI_sdnn', [], 'NAI_lf_power', [], 'NAI_hf_power', [], 'NAI_lf_hf_ratio', [],'NAI_sd1', [], 'NAI_sd2', [], ...
                                     'NAI_sd1_sd2_ratio', []);
        number_seconds = repmat(features_struct, length(patient_numbers), 1);

        for patient_idx = 1:length(patient_numbers)
            patient_no = patient_numbers(patient_idx);
            final_peaks = load(sprintf('../labels/peaks_subject%d_update.txt', patient_no));
            ecg_signal = load_ecg_signal(patient_no, sampling_freq);

            % Process ECG signal
            [ecg_ai, ecg_nai, rpeaks_ai, rpeaks_nai] = process_ecg_signal(ecg_signal, final_peaks, ...
                end_index_elements, start_index_elements, number_sec, sampling_freq);

            % Extract features based on the selected feature type
                features_struct = extract_hrv_features(rpeaks_ai, rpeaks_nai, sampling_freq);
          

            % Store the features for the current patient
            number_seconds(patient_idx) = features_struct;
        end

        % Save and normalize features
        save_and_normalize_features(number_sec, number_seconds, patient_numbers);
    end

    % Create structured features files
    create_structured_features(vector_seconds);

    % Perform statistical analysis
    perform_statistical_analysis(vector_seconds);
end