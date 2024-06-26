 % Clear all variables, close all figures, and clear command window
clear all; close all; clc

% Define the sampling frequency
sampling_freq = 500;

% Define the portion variable (can be 2VS3, 4VS5 and 6VS7)
portion = '4VS5'; 

% Define the duration of each segment in seconds
duration_seconds = [6, 196, 119, 218, 97, 317, 231, 882, 420];

% Convert duration from seconds to samples
samples = duration_seconds * sampling_freq;

% Calculate the cumulative sum of samples
samples_sum = cumsum(samples);

% Extract the first and second numbers from the portion string
numbers = regexp(portion, '\d', 'match');
first_number = str2double(numbers{1});
second_number = str2double(numbers{2});

% Calculate the end and start indices for the elements
end_index_elements = samples_sum(first_number + 1);
start_index_elements = samples_sum(second_number) + (5 * 500); % Adding 5 seconds buffer

% Define the vector of seconds to analyze (4 seconds from NAI to AI)
vector_seconds = [4];

% Define the list of patient numbers
patient_numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 18, 19, 20, 21];

% Initialize empty arrays to store all RR intervals
all_RR_intervals_ai = [];
all_RR_intervals_nai = [];

% Loop through each specified number of seconds
for number_sec = vector_seconds 
    number_seconds = struct();
    
    % Loop through each patient number
    for patient_idx = 1:length(patient_numbers)
        patient_no = patient_numbers(patient_idx);
        
        % Load the final peaks data for the current patient
        final_peaks = load(sprintf('../labels/peaks_subject%d_update.txt', patient_no));
        
        % Define the file pattern to find the ECG data file
        filePattern = sprintf('../data/*A1%02d*.mat', patient_no);
        files = dir(filePattern);
        
        % Check if any files are found
        if isempty(files)
            error('No files found matching the pattern.');
        else
            % Load the first matching file
            filename = fullfile(files(1).folder, files(1).name);
            data = load(filename);
            disp(['Loaded file: ', filename]);
        end

        % Extract the ECG signal from the loaded data
        ecg_signal = data.data(:,1);
        
        % Design a bandpass filter between 8 and 20 Hz
        [b, a] = butter(2, [8, 20] / (sampling_freq / 2), 'bandpass');
        
        % Apply the bandpass filter to the ECG signal
        ecg_filt = filtfilt(b, a, ecg_signal);

        % Calculate the indices for AI and NAI periods
        ai_idx = end_index_elements - (number_sec * sampling_freq);
        nai_idx = start_index_elements + (number_sec * sampling_freq);
        
        % Extract the R peaks within the AI and NAI periods
        rpeaks_nai = final_peaks(final_peaks >= ai_idx & final_peaks <= end_index_elements);
        rpeaks_ai = final_peaks(final_peaks >= start_index_elements & final_peaks <= nai_idx);
        
        % Calculate RR intervals for AI and NAI periods
        RR_intervals_ai = diff(rpeaks_ai) / sampling_freq;
        RR_intervals_nai = diff(rpeaks_nai) / sampling_freq;
        
        % Append the calculated RR intervals to the overall lists
        all_RR_intervals_ai = [all_RR_intervals_ai; RR_intervals_ai(:)];
        all_RR_intervals_nai = [all_RR_intervals_nai; RR_intervals_nai(:)];
    end
end

% Save the final RR intervals to .mat files
save('final_RR_intervals_5ai.mat', 'all_RR_intervals_ai');
save('final_RR_intervals_4nai.mat', 'all_RR_intervals_nai');

disp('Final RR intervals saved to final_RR_intervals.mat');
