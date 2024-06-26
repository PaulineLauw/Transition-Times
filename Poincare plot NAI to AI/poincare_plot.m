% Load the .mat files containing RR intervals
data2 = load('final_RR_intervals_2nai.mat');
data3 = load('final_RR_intervals_3ai.mat');
data4 = load('final_RR_intervals_4nai.mat');
data5 = load('final_RR_intervals_5ai.mat');
data6 = load('final_RR_intervals_6nai.mat');
data7 = load('final_RR_intervals_7ai.mat');

% Access the loaded RR interval variables
RR_intervals_2nai = data2.all_RR_intervals_nai;
RR_intervals_3ai = data3.all_RR_intervals_ai;
RR_intervals_4nai = data4.all_RR_intervals_nai;
RR_intervals_5ai = data5.all_RR_intervals_ai;
RR_intervals_6nai = data6.all_RR_intervals_nai;
RR_intervals_7ai = data7.all_RR_intervals_ai;

% Combine all NAI and AI RR intervals into single arrays
RR_intervals_nai = [RR_intervals_2nai; RR_intervals_4nai; RR_intervals_6nai];
RR_intervals_ai = [RR_intervals_3ai; RR_intervals_5ai; RR_intervals_7ai];

% Calculate the differences of successive RR intervals for both datasets
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

% Plot the RR intervals for NAI in blue and AI in red
plot(RR_intervals_nai(1:end-1), RR_intervals_nai(2:end), '.');
plot(RR_intervals_ai(1:end-1), RR_intervals_ai(2:end), 'r.');

% Calculate and plot the line of identity (y = x)
max_val = max([RR_intervals_nai; RR_intervals_ai]);
min_val = min([RR_intervals_nai; RR_intervals_ai]);
plot([min_val max_val], [min_val max_val], '--k');

% Calculate mean RR intervals for NAI and AI
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

% Annotate SD1 and SD2 values on the plot for both NAI and AI
text(mean_RR_ai-0.1, mean_RR_ai + SD2_ai + 0.04,  sprintf('SD1 = %.4f', SD1_nai), 'Color', 'b', 'FontSize', 13);
text(mean_RR_ai-0.1, mean_RR_ai + SD2_ai + 0.02, sprintf('SD2 = %.4f', SD2_nai), 'Color', 'b', 'FontSize', 13);
text(mean_RR_nai, mean_RR_nai - SD2_nai - 0.02, sprintf('SD1 = %.4f', SD1_ai), 'Color', 'r', 'FontSize', 13);
text(mean_RR_nai, mean_RR_nai - SD2_nai - 0.04, sprintf('SD2 = %.4f', SD2_ai), 'Color', 'r', 'FontSize', 13);

% Annotate SD1/SD2 ratios on the plot
text(0.7, 1.1, sprintf('SD1/SD2 = %.4f', SD1_nai/SD2_nai), 'Color', 'b', 'FontSize', 13);
text(1, 0.65, sprintf('SD1/SD2 = %.4f', SD1_ai/SD2_ai), 'Color', 'r', 'FontSize', 13);

% Add rectangles around the SD1/SD2 ratio annotations
dim = [0.21 0.04]; % Dimensions of the rectangle
rectangle('Position', [0.69, 1.083, dim], 'EdgeColor', 'b', 'LineWidth', 1.5); % Blue rectangle for NAI
rectangle('Position', [0.99, 0.63, dim], 'EdgeColor', 'r', 'LineWidth', 1.5); % Red rectangle for AI

% Add plot labels and title
xlabel('RR_n (s)');
ylabel('RR_{n+1} (s)');
title('Poincaré Plot of RR Intervals from NAI to AI', 'FontSize', 15);

% Add grid and legend
grid on;
legend('NAI', 'AI', 'Line of Identity', 'SD1 & SD2 (NAI)', '', 'SD1 & SD2 (AI)');

% Set axis properties to be equal and adjust figure position
axis equal;
set(gca, 'Position', [0.15 0.15 0.7 0.7]); % Adjust this to set equal lengths for x and y axis in the figure

% Save the figure with the desired resolution
print('Plot_NAI_to_AI', '-dpng', '-r350');
