% Frequency of the driving X chromosome in the total X pool

% frequency of X' in males
function result = R(n,t)
    persistent cacheR;
    if isempty(cacheR)
        cacheR = containers.Map('KeyType','char','ValueType','double');
    end
    key = sprintf('%d_%f', n, t);
    if isKey(cacheR, key)
        result = cacheR(key);
        return;
    end
    if n == 0
        result = 1/1000;
    elseif n == 1
        result = 1/1000;
    else
        result = 0.5 * R(n-1,t) + t * R(n-2,t) / ((2 * t - 1) * R(n-2,t) + 1);
    end
    cacheR(key) = result;
end

% frequency of X' in females
function result = K(n,t)
    persistent cacheK;
    if isempty(cacheK)
        cacheK = containers.Map('KeyType','char','ValueType','double');
    end
    key = sprintf('%d_%f', n, t);
    if isKey(cacheK, key)
        result = cacheK(key);
        return;
    end
    if n == 0
        result = 1/1000;
    else
        result = 0.5 * K(n-1,t) + t * R(n-1,t) / ((2 * t - 1) * R(n-1,t) + 1);
    end
    cacheK(key) = result;
end

% Plotting
n_values = 0:1:250; % Number of generations

t1 = 0.5;
t2 = 0.6;
t3 = 0.7;
t4 = 0.8;
t5 = 0.9;
t6 = 1;

% Plotting driver frequency in males and females are very similar. Here is
% plotting in males
y1 = arrayfun(@(n) R(n,t1), n_values);
y2 = arrayfun(@(n) R(n,t2), n_values);
y3 = arrayfun(@(n) R(n,t3), n_values);
y4 = arrayfun(@(n) R(n,t4), n_values);
y5 = arrayfun(@(n) R(n,t5), n_values);
y6 = arrayfun(@(n) R(n,t6), n_values);

figure;
plot(n_values, y1, 'LineWidth', 2);
hold on;
plot(n_values, y2, 'LineWidth', 2);
hold on;
plot(n_values, y3, 'LineWidth', 2);
hold on;
plot(n_values, y4, 'LineWidth', 2);
hold on;
plot(n_values, y5, 'LineWidth', 2);
hold on;
plot(n_values, y6, 'Color', [0, 0, 0], 'LineWidth', 2);
grid on;

xlabel('Generations', 'FontSize', 20);
ylabel('Frequency of driving X in total X', 'FontSize', 20);
title('Plot of driver frequency in males', 'FontSize', 30);
legend('t=0.5', 't=0.6', 't=0.7', 't=0.8', 't=0.9', 't=1', 'FontName', 'Arial', 'FontSize', 20);

% Set the thickness of the axes
ax = gca; % Get current axis
ax.LineWidth = 1; % Set axis line width

% Set the size of the axis numbers (tick labels)
ax.FontSize = 15; % Set font size of tick labels
ax.FontName = 'Arial'; % Set font name of tick labels
ax.FontWeight = 'normal'; % Set font weight of tick labels

% Very similar result is obtained if plotting driver frequency in females
y7 = arrayfun(@(n) K(n,t1), n_values);
y8 = arrayfun(@(n) K(n,t2), n_values);
y9 = arrayfun(@(n) K(n,t3), n_values);
y10 = arrayfun(@(n) K(n,t4), n_values);
y11 = arrayfun(@(n) K(n,t5), n_values);
y12 = arrayfun(@(n) K(n,t6), n_values);

figure;
plot(n_values, y7, 'LineWidth', 2);
hold on;
plot(n_values, y8, 'LineWidth', 2);
hold on;
plot(n_values, y9, 'LineWidth', 2);
hold on;
plot(n_values, y10, 'LineWidth', 2);
hold on;
plot(n_values, y11, 'LineWidth', 2);
hold on;
plot(n_values, y12, 'Color', [0, 0, 0], 'LineWidth', 2);
grid on;

xlabel('Generations', 'FontSize', 20);
ylabel('Frequency of driving X in total X', 'FontSize', 20);
title('Plot of driver frequency in females', 'FontSize', 30);
legend('t=0.5', 't=0.6', 't=0.7', 't=0.8', 't=0.9', 't=1', 'FontName', 'Arial', 'FontSize', 20);

% Set the thickness of the axes
ax = gca; % Get current axis
ax.LineWidth = 1; % Set axis line width

% Set the size of the axis numbers (tick labels)
ax.FontSize = 15; % Set font size of tick labels
ax.FontName = 'Arial'; % Set font name of tick labels
ax.FontWeight = 'normal'; % Set font weight of tick labels
