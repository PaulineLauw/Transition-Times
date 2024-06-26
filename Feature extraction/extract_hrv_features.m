function features = extract_hrv_features(rpeaks_ai, rpeaks_nai, sampling_freq)
    % HRV AI Features
    RR_intervals_ai = diff(rpeaks_ai) / sampling_freq;
    features.AI_meanRR = mean(RR_intervals_ai);     
    features.AI_rmssd = sqrt(mean(diff(RR_intervals_ai).^2));
    features.AI_sdnn = std(RR_intervals_ai);
    [features.AI_lf_power, features.AI_hf_power, features.AI_lf_hf_ratio] = calc_power_spectral_density(RR_intervals_ai, sampling_freq);

    features.AI_sd1 = sqrt(0.5 * var(diff(RR_intervals_ai)));
    features.AI_sd2 = sqrt(2 * var(RR_intervals_ai(1:end-1)) - 0.5 * var(diff(RR_intervals_ai)));
    features.AI_sd1_sd2_ratio = features.AI_sd1 / features.AI_sd2;

    
    % HRV NAI Features
    RR_intervals_nai = diff(rpeaks_nai) / sampling_freq;
    features.NAI_meanRR = mean(RR_intervals_nai);    
    features.NAI_rmssd = sqrt(mean(diff(RR_intervals_nai).^2));
    features.NAI_sdnn = std(RR_intervals_nai);
    [features.NAI_lf_power, features.NAI_hf_power, features.NAI_lf_hf_ratio] = calc_power_spectral_density(RR_intervals_nai, sampling_freq);

    features.NAI_sd1 = sqrt(0.5 * var(diff(RR_intervals_nai)));
    features.NAI_sd2 = sqrt(2 * var(RR_intervals_nai(1:end-1)) - 0.5 * var(diff(RR_intervals_nai)));
    features.NAI_sd1_sd2_ratio = features.NAI_sd1 / features.NAI_sd2;

    end

function [lf_power, hf_power, lf_hf_ratio] = calc_power_spectral_density(RR_intervals, sampling_freq)
    t_intervals = cumsum(RR_intervals);
    t_resampled = (0:1/sampling_freq:t_intervals(end));
    RR_resampled = interp1(t_intervals, RR_intervals, t_resampled, 'linear', 'extrap');
    [pxx, f] = pwelch(RR_resampled, [], [], [], sampling_freq);
    lf_power = bandpower(pxx, f, [0.04, 0.15], 'psd');
    hf_power = bandpower(pxx, f, [0.15, 0.4], 'psd');
    lf_hf_ratio = lf_power / hf_power;
end
