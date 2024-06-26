% Clear workspace, close all figures, and clear command window
clear all; close all; clc

% Define the sampling frequency
sampling_freq = 500;

% Define the portion string (can be 1VS2, 3VS4, 5VS6 and 7VS8)
portion = '7VS8';

% Define the duration of each segment in seconds
duration_seconds = [6, 196, 119, 218, 97, 317, 231, 882, 420];

% Convert duration from seconds to samples
samples = duration_seconds * sampling_freq;

% Calculate cumulative sum of samples
samples_sum = cumsum(samples);

% Extract the numbers from the portion string
numbers = regexp(portion, '\d', 'match');
first_number = str2double(numbers{1});
second_number = str2double(numbers{2});

% Calculate the end index for AI and the start index for NAI
end_index_elements = samples_sum(first_number + 1);
start_index_elements = samples_sum(second_number);

% Define the number of seconds for RR interval calculation (12 seconds for
% AI to NAI)
vector_seconds = [12];

% List of patient numbers
patient_numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 18, 19, 20, 21];

% Initialize arrays to store all RR intervals for AI and NAI
all_RR_intervals_ai = [];
all_RR_intervals_nai = [];

% Loop over the vector of seconds (only one value in this case)
for number_sec = vector_seconds 
    number_seconds = struct();  % Initialize a structure (not used further in this code)
    
    % Loop over each patient
    for patient_idx = 1:length(patient_numbers)
        patient_no = patient_numbers(patient_idx);
        
        % Load the final peaks data for the current patient
        final_peaks = load(sprintf('../labels/peaks_subject%d_update.txt', patient_no));
        
        % Find the .mat file for the current patient
        filePattern = sprintf('../data/*A1%02d*.mat', patient_no);
        files = dir(filePattern);
        
        % Error handling if no files are found
        if isempty(files)
            error('No files found matching the pattern.');
        else
            % Load the .mat file data
            filename = fullfile(files(1).folder, files(1).name);
            data = load(filename);
            disp(['Loaded file: ', filename]);
        end

        % Extract the ECG signal from the loaded data
        ecg_signal = data.data(:,1);
        
        % Apply a bandpass filter to the ECG signal
        [b, a] = butter(2, [8, 20] / (sampling_freq / 2), 'bandpass');
        ecg_filt = filtfilt(b, a, ecg_signal);

        % Calculate indices for AI and NAI segments
        ai_idx = end_index_elements - (number_sec * sampling_freq);
        nai_idx = start_index_elements + (number_sec * sampling_freq);
        
        % Extract R-peaks within the AI and NAI segments
        rpeaks_ai = final_peaks(final_peaks >= ai_idx & final_peaks <= end_index_elements);
        rpeaks_nai = final_peaks(final_peaks >= start_index_elements & final_peaks <= nai_idx);

        % Calculate RR intervals for AI and NAI segments
        RR_intervals_ai = diff(rpeaks_ai) / sampling_freq;
        RR_intervals_nai = diff(rpeaks_nai) / sampling_freq;

        % Append the calculated RR intervals to the respective arrays
        all_RR_intervals_ai = [all_RR_intervals_ai; RR_intervals_ai(:)];
        all_RR_intervals_nai = [all_RR_intervals_nai; RR_intervals_nai(:)];
    end
end

% Save the final RR interval vectors to .mat files
save('final_RR_intervals_7ai.mat', 'all_RR_intervals_ai');
save('final_RR_intervals_8nai.mat', 'all_RR_intervals_nai');

% Display a message indicating that the final RR intervals have been saved
disp('Final RR intervals saved to final_RR_intervals.mat');
