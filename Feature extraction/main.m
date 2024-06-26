% main.m
clear all; close all; clc;

% Parameters
portion = '7VS8';
sampling_freq = 500;

% Load patient data
patient_numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 18, 19, 20, 21];

% Call function to process data
process_data(portion, sampling_freq, patient_numbers);