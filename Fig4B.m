% Population change rate_3D plotting

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

% population change
function result = rate(n,t)
    result = Total(n+1,t)/Total(n,t);
end

% Define the range for n and t
n_values = 0:1:200;
t_values = 0.5:0.01:1;

% Create the grid of n and t values
[N, T] = meshgrid(n_values, t_values);

% Initialize the matrix to hold the Total values
rate_values = zeros(size(N));

% Evaluate Total for each pair (n, t)
for i = 1:numel(N)
    rate_values(i) = rate(N(i), T(i));
end

Steady_state = ones(size(N));

% Plot the surface
figure;
h1 = surf(N, T, rate_values);
hold on;
h2 = surf(N, T, Steady_state);

% Apply different colors to the surfaces
h1.CData = rate_values;
h2.CData = Steady_state;
h2.FaceColor = [0, 0, 0]; % Set the steady state surface color
h2.EdgeColor = 'none'; % Remove edge lines for the steady state surface

% Apply a colormap to the figure
colormap(jet);
set(h2, 'FaceAlpha', 0.5); % Make the steady state surface semi-transparent

colorbar;
xlabel('Generations', 'FontSize', 30);
ylabel('Drive strength', 'FontSize', 30);
zlabel('Population change rate', 'FontSize', 30);

% Set the thickness of the axes
ax = gca; % Get current axis
ax.LineWidth = 1; % Set axis line width

% Set the size of the axis numbers (tick labels)
ax.FontSize = 15; % Set font size of tick labels
ax.FontName = 'Arial'; % Set font name of tick labels
ax.FontWeight = 'normal'; % Set font weight of tick labels

% View angle for Fig.4b(i)
view(-2.433820023341874e+02,34.206131385975354);
grid on;

% View angle for Fig.4b(ii)
% set(h2, 'FaceAlpha', 0); % Make the steady state surface transparent
% view(-2.697578277403512e+02,90);
% grid on;
