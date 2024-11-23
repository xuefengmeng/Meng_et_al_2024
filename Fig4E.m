% Female number, male number, and sex ratio

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

% total female number
function result = F(n,t)
    persistent cacheF;
    if isempty(cacheF)
        cacheF = containers.Map('KeyType','char','ValueType','double');
    end
    key = sprintf('%d_%f', n, t);
    if isKey(cacheF, key)
        result = cacheF(key);
        return;
    end
    if n == 0
        result = 1000;
    else
        [M_prev, F_prev] = getMF(n-1,t);
        if 2 * M_prev >= F_prev
            result = (2 * t - 1) * F_prev * R(n-1,t) + F_prev;
        else
            result = (4 * t - 2) * M_prev * R(n-1,t) + 2 * M_prev;
        end
    end
    cacheF(key) = result;
end

% total male number
function result = M(n,t)
    persistent cacheM;
    if isempty(cacheM)
        cacheM = containers.Map('KeyType','char','ValueType','double');
    end
    key = sprintf('%d_%f', n, t);
    if isKey(cacheM, key)
        result = cacheM(key);
        return;
    end
    if n == 0
        result = 1000;
    else
        [M_prev, F_prev] = getMF(n-1,t);
        if 2 * M_prev >= F_prev
            result = (1 - 2 * t) * F_prev * R(n-1,t) + F_prev;
        else
            result = (2 - 4 * t) * M_prev * R(n-1,t) + 2 * M_prev;
        end
    end
    cacheM(key) = result;
end

function [M_prev, F_prev] = getMF(n,t)
    % Helper function to get the values of M(n) and F(n)
    M_prev = M(n,t);
    F_prev = F(n,t);
end

% total fly number
function result = Total(n,t)
    result = M(n,t) + F(n,t);
end

% male/female sex ratio
function result = ratio(n,t)
    result = M(n,t)/F(n,t);
end

% Plotting sex ratio and population
n_values = 0:1:250;
t = 0.6;
y1 = arrayfun(@(n) M(n,t), n_values);
y2 = arrayfun(@(n) F(n,t), n_values);
y3 = arrayfun(@(n) ratio(n,t), n_values);

% Define colors
color_y1 = [0.8500, 0.3250, 0.0980];
color_y2 = [0, 0.4470, 0.7410];
color_y3 = [0, 0, 0];

figure;

% Plot y1 and y2 on the left Y-axis
yyaxis left;
plot(n_values, y1, 'Color', color_y1, 'LineWidth', 2, 'LineStyle', '-');
hold on;
plot(n_values, y2, 'Color', color_y2, 'LineWidth', 2, 'LineStyle','-');
ylim([0 16*10^10]);
ylabel('Population');
set(gca, 'YColor', color_y3);

% Plot y3 on the right Y-axis
yyaxis right;
plot(n_values, y3, 'Color', color_y3, 'LineWidth', 2,'LineStyle','-');
ylabel('Male/female ratio');
set(gca, 'YColor', color_y3);
ylim([0 1]);

xlabel('Generations', 'FontSize', 20);
title(['Plot of population and male/female ratio when t=' num2str(t)], 'FontSize', 30);
grid on;
legend({'male', 'femlae', 'male/female ratio'});

% Set the thickness of the axes
ax = gca; % Get current axis
ax.LineWidth = 1; % Set axis line width

% Set the size of the axis numbers (tick labels)
ax.FontSize = 15; % Set font size of tick labels
ax.FontName = 'Arial'; % Set font name of tick labels
ax.FontWeight = 'normal'; % Set font weight of tick labels
