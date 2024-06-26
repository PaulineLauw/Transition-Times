function [ecg_ai, ecg_nai, rpeaks_ai, rpeaks_nai] = process_ecg_signal(ecg_signal, final_peaks, ...
    end_index_elements, start_index_elements, number_sec, sampling_freq)

    % Bandpass filter the ECG signal
    [b, a] = butter(2, [8, 20] / (sampling_freq / 2), 'bandpass');
    ecg_filt = filtfilt(b, a, ecg_signal);

    % Extract segments for AI and NAI
    ai_idx = end_index_elements - (number_sec * sampling_freq);
    nai_idx = start_index_elements + (number_sec * sampling_freq);
    rpeaks_ai = final_peaks(final_peaks >= ai_idx & final_peaks <= end_index_elements);
    rpeaks_nai = final_peaks(final_peaks >= start_index_elements & final_peaks <= nai_idx);
    ecg_ai = ecg_filt(ai_idx:end_index_elements);   
    ecg_nai = ecg_filt(start_index_elements:nai_idx);
end