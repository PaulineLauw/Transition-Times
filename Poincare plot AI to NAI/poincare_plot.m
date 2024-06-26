% Load the .mat files
data1 = load('final_RR_intervals_1ai.mat');
data2 = load('final_RR_intervals_2nai.mat');
data3 = load('final_RR_intervals_3ai.mat');
data4 = load('final_RR_intervals_4nai.mat');
data5 = load('final_RR_intervals_5ai.mat');
data6 = load('final_RR_intervals_6nai.mat');
data7 = load('final_RR_intervals_7ai.mat');
data8 = load('final_RR_intervals_8nai.mat');

% Access the loaded variables
RR_intervals_1ai = data1.all_RR_intervals_ai;
RR_intervals_2nai = data2.all_RR_intervals_nai;
RR_intervals_3ai = data3.all_RR_intervals_ai;
RR_intervals_4nai = data4.all_RR_intervals_nai;
RR_intervals_5ai = data5.all_RR_intervals_ai;
RR_intervals_6nai = data6.all_RR_intervals_nai;
RR_intervals_7ai = data7.all_RR_intervals_ai;
RR_intervals_8nai = data8.all_RR_intervals_nai;

% Combine all RR intervals for NAI and AI
RR_intervals_nai = [RR_intervals_2nai; RR_intervals_4nai; RR_intervals_6nai; RR_intervals_8nai];
RR_intervals_ai = [RR_intervals_1ai; RR_intervals_3ai; RR_intervals_5ai; RR_intervals_7ai];

% Calculate the mean and standard deviation for AI data
mean_data_ai = mean(RR_intervals_ai);
std_data_ai = std(RR_intervals_ai);

% Calculate z-scores and remove outliers for AI data
z_scores_ai = (RR_intervals_ai - mean_data_ai) / std_data_ai;
threshold = 3; % Define the outlier threshold
non_outlier_indices_ai = abs(z_scores_ai) < threshold;
cleaned_data_ai = RR_intervals_ai(non_outlier_indices_ai);

% Calculate the mean and standard deviation for NAI data
mean_data_nai = mean(RR_intervals_nai);
std_data_nai = std(RR_intervals_nai);

% Calculate z-scores and remove outliers for NAI data
z_scores_nai = (RR_intervals_nai - mean_data_nai) / std_data_nai;
non_outlier_indices_nai = abs(z_scores_nai) < threshold;
cleaned_data_nai = RR_intervals_nai(non_outlier_indices_nai);

% Update RR intervals after removing outliers
RR_intervals_ai = cleaned_data_ai;
RR_intervals_nai = cleaned_data_nai;

% Calculate differences for both datasets
RR_diff_nai = diff(RR_intervals_nai);
RR_diff_ai = diff(RR_intervals_ai);

% Calculate SD1 and SD2 for NAI data
SD1_nai = std(RR_diff_nai) / sqrt(2);
SD2_nai = sqrt(2 * std(RR_intervals_nai)^2 - SD1_nai^2);

% Calculate SD1 and SD2 for AI data
SD1_ai = std(RR_diff_ai) / sqrt(2);
SD2_ai = sqrt(2 * std(RR_intervals_ai)^2 - SD1_ai^2);

% Create the Poincaré plot
figure;
hold on;

% Plot the RR intervals for NAI and AI
plot(RR_intervals_nai(1:end-1), RR_intervals_nai(2:end), '.');
plot(RR_intervals_ai(1:end-1), RR_intervals_ai(2:end), 'r.');

% Calculate the line of identity
max_val = max([RR_intervals_nai; RR_intervals_ai]);
min_val = min([RR_intervals_nai; RR_intervals_ai]);
plot([min_val max_val], [min_val max_val], '--k');

% Mean RR intervals
mean_RR_nai = mean(RR_intervals_nai);
mean_RR_ai = mean(RR_intervals_ai);

% Plot SD1 and SD2 for NAI data in blue
% SD2 is parallel to the line of identity
line_identity_nai = [mean_RR_nai - SD2_nai, mean_RR_nai + SD2_nai];
plot(line_identity_nai, line_identity_nai, 'b', 'LineWidth', 2);

% SD1 is perpendicular to the line of identity
x_sd1_nai = mean_RR_nai + [-SD1_nai, SD1_nai] / sqrt(2);
y_sd1_nai = mean_RR_nai + [SD1_nai, -SD1_nai] / sqrt(2);
plot(x_sd1_nai, y_sd1_nai, 'b', 'LineWidth', 2);

% Plot SD1 and SD2 for AI data in red
% SD2 is parallel to the line of identity
line_identity_ai = [mean_RR_ai - SD2_ai, mean_RR_ai + SD2_ai];
plot(line_identity_ai, line_identity_ai, 'r', 'LineWidth', 2);

% SD1 is perpendicular to the line of identity
x_sd1_ai = mean_RR_ai + [-SD1_ai, SD1_ai] / sqrt(2);
y_sd1_ai = mean_RR_ai + [SD1_ai, -SD1_ai] / sqrt(2);
plot(x_sd1_ai, y_sd1_ai, 'r', 'LineWidth', 2);

% Annotate SD1 and SD2 values on the plot for NAI data in blue
text(mean_RR_ai-0.1, mean_RR_ai + SD2_ai + 0.05,  sprintf('SD1 = %.4f', SD1_nai), 'Color', 'b', 'FontSize', 13);
text(mean_RR_ai-0.1, mean_RR_ai + SD2_ai + 0.02, sprintf('SD2 = %.4f', SD2_nai), 'Color', 'b', 'FontSize', 13);

% Annotate SD1 and SD2 values on the plot for AI data in red
text(mean_RR_nai, mean_RR_nai - SD2_nai - 0.02, sprintf('SD1 = %.4f', SD1_ai), 'Color', 'r', 'FontSize', 13);
text(mean_RR_nai, mean_RR_nai - SD2_nai - 0.05, sprintf('SD2 = %.4f', SD2_ai), 'Color', 'r', 'FontSize', 13);

% Annotate SD1/SD2 ratios on the plot
text(0.7,1.1,sprintf('SD1/SD2 = %.4f', SD1_nai/SD2_nai), 'Color', 'b', 'FontSize', 13);
text(1,0.65,sprintf('SD1/SD2 = %.4f', SD1_ai/SD2_ai), 'Color', 'r', 'FontSize', 13);

% Add rectangles around the text annotations
dim = [0.22 0.04]; % Dimensions of the rectangle
% Blue rectangle for NAI
rectangle('Position', [0.69,1.083, dim], 'EdgeColor', 'b', 'LineWidth', 1.5);

% Red rectangle for AI
rectangle('Position', [0.99,0.63, dim], 'EdgeColor', 'r', 'LineWidth', 1.5);

% Label the axes
xlabel('RR_n (s)');
ylabel('RR_{n+1} (s)');

% Add a title to the plot
title('Poincaré Plot of RR Intervals from AI to NAI', 'FontSize', 15);

% Add a grid to the plot
grid on;

% Add a legend to the plot
legend('NAI', 'AI', 'Line of Identity', 'SD1 & SD2 (NAI)', '', 'SD1 & SD2 (AI)');

% Release the hold on the current plot
hold off;

% Set the figure and axis properties to be square
axis equal;
set(gca, 'Position', [0.15 0.15 0.7 0.7]); % Adjust this to set equal lengths for x and y axis in the figure

% Save the figure with the desired resolution
print('Plot_AI_to_NAI', '-dpng', '-r350');
