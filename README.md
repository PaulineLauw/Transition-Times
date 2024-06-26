# Transition Times


## Introduction

This project provides the code to assess transition time through ECG signal in varying anxiety stimuli. It is the author's semester project (12 credits) in ETH Zürich.

## Summary

This project comprises mainly two parts: the extraction of the features for the considered segments resulting in the supplementary tables and the Poincaré Plots. 

To extract the features for the considered segments, the worklfow followed is the following: 
1. Segmenting the ECG signal in the length desired for each transition
2. Extracting a feature from each segment
3. Evaluating the statistical significance from the segments

## Package Requirements
- Signal Processing Toolbox version 24.1
- Statistics and Machine Learning Toolbox version 24.1

## Configuration 
The experiments were run on the author's personal laptop. The configurations are provided as the reference: 
- macOS Sonoma Version 14.3

The code is written in matlab language and version is MATLAB_R2024a.

## Code Structure 

### Feature extraction 

***Main Files***

1. 'main.m'
   
- This is the entry point of the program.
- Sets parameters such as portion, features, and sampling_freq.
- Loads patient data and calls the process_data function.

2. 'process_data.m'

- Main function to process ECG data.
- Calculates sample indices based on the selected portion.
- Loops through different segment durations (vector_seconds).
- Calls various feature extraction functions based on the selected feature type (HRV, IMF1/2, IMF3/4, Gabor, Hilbert).
- Saves and normalizes features, creates structured feature files, and performs statistical analysis.

***Feature Extraction Functions***

3. 'extract_hrv_features.m'

- Extracts Heart Rate Variability (HRV) features from the ECG data.
- Computes features such as mean RR intervals, RMSSD, SDNN, LF/HF power, and more.

4. 'extract_imf_features.m'

- Extracts Intrinsic Mode Function (IMF) features from the ECG data.
- Uses Empirical Mode Decomposition (EMD) to decompose the ECG signal.
- Computes features for specified IMFs such as mean absolute value, standard deviation, skewness, kurtosis, energy, entropy, and instantaneous frequency statistics.

5. 'extract_gabor_features.m'

- Extracts features using the Gabor filter from the ECG data.
- Applies Gabor filtering to the signal and computes features such as mean amplitude, standard deviation, skewness, kurtosis, energy, entropy, and instantaneous frequency statistics.

6. 'extract_hilbert_features.m'

- Extracts features using the Hilbert transform from the ECG data.
- Computes features such as mean amplitude, standard deviation, skewness, kurtosis, phase, and instantaneous frequency statistics.

***Helper Functions***

7. 'initialize_features_struct.m'

- Initializes a structure with all possible fields set to empty, based on the selected feature type.

8. 'load_ecg_signal.m'

- Loads the ECG signal for a specified patient.

9. 'process_ecg_signal.m'

- Processes the ECG signal to filter it and extract R-peaks.
- Segments the ECG signal into AI and NAI segments.

10. 'save_and_normalize_features.m'

- Saves the extracted features for each segment duration.
- Normalizes the features using Min-Max normalization.

11. 'create_structured_features.m'

- Converts the normalized feature matrix to a structured format.
- Saves the structured features to .mat files.

12. 'perform_statistical_analysis.m'

- Performs statistical analysis on the extracted features.
- Conducts Wilcoxon rank-sum tests and two-sample t-tests.
- Saves the p-values of the statistical tests.

### Poincaré Plots

Both folders "Poincaré Plots AI to NAI" and "Poincaré Plot NAI to AI" have:

1. 'RR_intervals_mat_files.m'

- Extracts RR intervals for each segment considered of a specific clip
- Saves the RR intervals to corresponding .mat files

2. 'poincare_plot.m'

- Calculates and plots the Poincaré Plot with corresponding SD1/SD2

### Data Files

1. labels/peaks_subjectX_update.txt

- Contains R-peak annotations for each subject.
- Used for feature extraction in the process_ecg_signal function.

2. data/*.mat

- Contains ECG data files for each subject.
- Loaded by the load_ecg_signal function.

## Dataset
Anxiety dataset available at: https://figshare.com/articles/dataset/Anxiety_Dataset_2022/19875217

## Usage

### Feature extraction
1. Set Parameters

Open the main.m file and set the desired parameters: portion and features.

2. Execute the Script

Run the main.m script in MATLAB. You can do this by navigating to the directory containing the script and typing main in the MATLAB Command Window.

3. Processing Data

The process_data function will be called with the specified parameters.
The function will process the ECG data, extract features based on the selected feature type, save and normalize the features, create structured feature files, and perform statistical analysis.

### Poincaré Plot

1. Extract RR_intervals (Optional)

Resulting .mat files containing RR intervals are already in the corresponding folder. To regenerate them, run the 'RR_intervals_mat_files.m' script with setting the protion parameter to the specific clips to be analyzed. 

2. Plot

Once the RR_intervals.mat files are extracted you can execute the code 'poincare_plot.m', which will geenrate you the final plot of the transition considered.

## Example Results

This is the resulting table that can be found in the p_values_ecg_all.mat file, once you have followed the steps in the "Feature extraction" of Usage. 

| Lowest p-values | meanRR  | sdnn    | rmssd   | lf_power | hf_power | lf/hf  | sd1    | sd2    | sd1/sd2 |
|-----------------|---------|---------|---------|----------|----------|--------|--------|--------|---------|
| 4sec            | 0.5372  | 0.9874  | 0.8370  | 0.8370   | 0.8370   | NaN    | 0.2613 | 0.9243 | 0.0000  |
| 5sec            | 0.9369  | 0.2113  | 0.3506  | 0.6924   | 0.6924   | NaN    | 0.6693 | 0.0032 | 0.0499  |
| 6sec            | 0.8868  | 0.8370  | 0.8868  | 0.6464   | 0.6464   | NaN    | 0.9621 | 0.7758 | 0.1135  |
| 7sec            | 0.9118  | 0.2750  | 0.9118  | 0.6924   | 0.6924   | NaN    | 0.9874 | 0.1288 | 0.1879  |
| 8sec            | 0.8618  | 0.6016  | 0.7397  | 0.7159   | 0.7159   | NaN    | 0.9621 | 0.0053 | 0.0002  |
| 9sec            | 0.9369  | 0.6464  | 0.8124  | 0.6693   | 0.6693   | NaN    | 0.8618 | 0.0056 | 0.0000  |
| 10sec           | 0.9369  | 0.7159  | 1.0000  | 0.9369   | 0.8618   | 0.1925 | 0.9874 | 0.1787 | 0.2613  |
| 11sec           | 0.9118  | 0.7397  | 0.9621  | 0.7397   | 0.7880   | 0.1173 | 0.9118 | 0.0688 | 0.0155  |
| 12sec           | 0.8370  | 0.5165  | 0.7397  | 0.7637   | 0.8868   | 0.2231 | 0.7637 | 0.2354 | 0.0905  |
| 13sec           | 0.8868  | 0.6924  | 0.9369  | 1.0000   | 0.9874   | 0.8618 | 0.9369 | 0.2354 | 0.3189  |
| 14sec           | 0.7637  | 0.9874  | 0.9621  | 0.9874   | 0.9621   | 0.3189 | 0.9621 | 0.1787 | 0.1499  |
| 15sec           | 0.6693  | 1.0000  | 0.9621  | 0.9874   | 0.9118   | 0.4963 | 0.9118 | 0.2231 | 0.1787  |
| 16sec           | 0.7159  | 0.8868  | 0.9621  | 0.9874   | 0.9874   | 0.4571 | 1.0000 | 0.3672 | 0.4197  |
| 17sec           | 0.6693  | 0.9369  | 0.9118  | 0.8868   | 0.9118   | 0.1328 | 0.8868 | 0.4197 | 0.3842  |
| 18sec           | 0.7397  | 0.8868  | 0.8618  | 0.8370   | 0.8370   | 0.2231 | 0.8618 | 0.4571 | 0.2481  |
| 19sec           | 0.8370  | 0.9369  | 0.6693  | 0.9621   | 0.2354   | 0.9118 | 0.6693 | 0.6924 | 0.0642  |
| 20sec           | 0.9118  | 0.8868  | 0.5372  | 0.9118   | 0.9369   | 0.9874 | 0.5372 | 0.6238 | 0.3038  |
| 21sec           | 1.0000  | 0.6464  | 0.7397  | 0.7637   | 0.8370   | 0.6464 | 0.6464 | 0.6924 | 0.4963  |
| 22sec           | 0.9621  | 0.8370  | 0.6238  | 0.7637   | 0.8370   | 0.0517 | 0.5798 | 0.5372 | 0.2891  |
| 23sec           | 0.9874  | 0.8868  | 0.6693  | 0.8124   | 0.8618   | 0.1412 | 0.6693 | 0.3345 | 0.2113  |
| 24sec           | 0.7880  | 0.6693  | 0.6693  | 0.8370   | 0.8868   | 0.7637 | 0.6238 | 0.1173 | 0.1787  |
| 25sec           | 0.7397  | 0.7880  | 0.6464  | 0.9118   | 0.9369   | 0.5165 | 0.6464 | 0.2000 | 0.4197  |
| 26sec           | 0.7637  | 0.9621  | 0.9369  | 0.8370   | 0.6016   | 0.2000 | 0.9874 | 0.3038 | 0.5165  |
| 27sec           | 0.7637  | 0.9118  | 0.9118  | 0.8618   | 0.6693   | 0.4017 | 0.9369 | 0.4017 | 0.5583  |
| 28sec           | 0.7397  | 0.8618  | 0.8618  | 0.9874   | 0.8618   | 0.4765 | 0.8618 | 0.2891 | 0.7397  |
| 29sec           | 0.7637  | 0.8618  | 0.8618  | 1.0000   | 0.9369   | 1.0000 | 0.8868 | 0.2354 | 0.7397  |
| 30sec           | 0.8868  | 0.8618  | 0.6924  | 0.9369   | 0.6238   | 0.7637 | 0.6924 | 0.3506 | 0.9874  |

## Contact 
If you have any questions, please feel free to contact me at plauwers@student.ethz.ch or Dr. Elgendi at moe.elgendi@gmail.com.
