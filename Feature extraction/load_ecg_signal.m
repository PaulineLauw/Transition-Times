function ecg_signal = load_ecg_signal(patient_no, sampling_freq)
    filePattern = sprintf('../data/*A1%02d*.mat', patient_no);
    files = dir(filePattern);
    if isempty(files)
        error('No files found matching the pattern.');
    else
        filename = fullfile(files(1).folder, files(1).name);
        data = load(filename);
        disp(['Loaded file: ', filename]);
    end
    ecg_signal = data.data(:, 1);
end