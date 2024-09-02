% Threshold drive strength with mating index w and reproduction index z

% Define the range for w and z
w = 2:1:10;
z = 2:1:10;

% Create a grid of w and z values
[W, Z] = meshgrid(w, z);

% Calculate threshold t values
T = 1 - 1 ./ (Z .* W);

% Plot the surface
figure;
h = surf(W, Z, T);

% Add labels and title
colorbar;
xlabel('Mating index', 'FontSize', 20);
ylabel('Reproduction index', 'FontSize', 20);
zlabel('Threshold drive strength', 'FontSize', 20);
zlim([0.7 1]);
xlim([2 10]);
ylim([2 10]);

% Adjust the view angle
view(-3.223557887062943e+02,15.578978294488728);
grid on;

% Set the thickness of the axes
ax = gca; % Get current axis
ax.LineWidth = 1; % Set axis line width

% Set the size of the axis numbers (tick labels)
ax.FontSize = 15; % Set font size of tick labels
ax.FontName = 'Arial'; % Set font name of tick labels
ax.FontWeight = 'normal'; % Set font weight of tick labels