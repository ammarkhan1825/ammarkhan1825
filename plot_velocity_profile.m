%=====================================================
% VELOCITY PROFILE ANALYSIS
%=====================================================
clear all; close all; clc;

% Define file paths
data_dir = 'D:\NPU\PhD\Research Data\Matlab\Sliding Grid';
file_x3d = fullfile(data_dir, 'wake_X3D.csv');
file_x4d = fullfile(data_dir, 'wake_X4D.csv');

%=====================================================
% Reading X3D file
%=====================================================
fprintf('Reading X3D file: %s\n', file_x3d);

% Use readtable which is more robust
try
    data_x3d = readtable(file_x3d);
    fprintf('X3D data loaded successfully. Size: %d x %d\n', size(data_x3d, 1), size(data_x3d, 2));
catch ME
    fprintf('Error reading X3D file: %s\n', ME.message);
    return;
end

%=====================================================
% Reading X4D file
%=====================================================
fprintf('Reading X4D file: %s\n', file_x4d);

try
    data_x4d = readtable(file_x4d);
    fprintf('X4D data loaded successfully. Size: %d x %d\n', size(data_x4d, 1), size(data_x4d, 2));
catch ME
    fprintf('Error reading X4D file: %s\n', ME.message);
    return;
end

%=====================================================
% Extract relevant columns
%=====================================================
% Column names (from your CSV headers)
% "Velocity: Magnitude (m/s)","Velocity[i] (m/s)","Velocity[j] (m/s)",...
% "Velocity[k] (m/s)","Position[X] (m)","Position[Y] (m)","Position[Z] (m)",...
% "Static Pressure (Pa)","X (m)","Y (m)","Z (m)"

% Get column names
col_names_x3d = data_x3d.Properties.VariableNames;
col_names_x4d = data_x4d.Properties.VariableNames;

fprintf('\nX3D Column Names:\n');
disp(col_names_x3d');

fprintf('\nX4D Column Names:\n');
disp(col_names_x4d');

% Extract data with proper variable names (handle special characters)
% Replace spaces and brackets in column names for easier access
vel_mag_x3d = data_x3d{:, 1};  % Velocity magnitude
vel_i_x3d = data_x3d{:, 2};    % Velocity i-component
vel_j_x3d = data_x3d{:, 3};    % Velocity j-component
vel_k_x3d = data_x3d{:, 4};    % Velocity k-component
pos_x_x3d = data_x3d{:, 5};    % Position X
pos_y_x3d = data_x3d{:, 6};    % Position Y
pos_z_x3d = data_x3d{:, 7};    % Position Z
pressure_x3d = data_x3d{:, 8}; % Static Pressure

vel_mag_x4d = data_x4d{:, 1};
vel_i_x4d = data_x4d{:, 2};
vel_j_x4d = data_x4d{:, 3};
vel_k_x4d = data_x4d{:, 4};
pos_x_x4d = data_x4d{:, 5};
pos_y_x4d = data_x4d{:, 6};
pos_z_x4d = data_x4d{:, 7};
pressure_x4d = data_x4d{:, 8};

%=====================================================
% Create comprehensive plots
%=====================================================

figure('Name', 'Velocity Profile Analysis', 'NumberTitle', 'off', 'Position', [100 100 1400 900]);

% Plot 1: Velocity Magnitude at X3D
subplot(2, 3, 1);
scatter3(pos_y_x3d, pos_z_x3d, vel_mag_x3d, 50, vel_mag_x3d, 'filled');
colorbar;
xlabel('Y Position (m)');
ylabel('Z Position (m)');
zlabel('Velocity Magnitude (m/s)');
title('X3D: Velocity Magnitude Field');
grid on;

% Plot 2: Velocity Magnitude at X4D
subplot(2, 3, 2);
scatter3(pos_y_x4d, pos_z_x4d, vel_mag_x4d, 50, vel_mag_x4d, 'filled');
colorbar;
xlabel('Y Position (m)');
ylabel('Z Position (m)');
zlabel('Velocity Magnitude (m/s)');
title('X4D: Velocity Magnitude Field');
grid on;

% Plot 3: Velocity i-component comparison
subplot(2, 3, 3);
plot(vel_i_x3d, 'b-', 'LineWidth', 1.5); hold on;
plot(vel_i_x4d, 'r-', 'LineWidth', 1.5);
xlabel('Data Point Index');
ylabel('Velocity i-component (m/s)');
legend('X3D', 'X4D');
title('Velocity i-component Comparison');
grid on;

% Plot 4: Pressure field at X3D
subplot(2, 3, 4);
scatter3(pos_y_x3d, pos_z_x3d, pressure_x3d, 50, pressure_x3d, 'filled');
colorbar;
xlabel('Y Position (m)');
ylabel('Z Position (m)');
zlabel('Static Pressure (Pa)');
title('X3D: Static Pressure Field');
grid on;

% Plot 5: Pressure field at X4D
subplot(2, 3, 5);
scatter3(pos_y_x4d, pos_z_x4d, pressure_x4d, 50, pressure_x4d, 'filled');
colorbar;
xlabel('Y Position (m)');
ylabel('Z Position (m)');
zlabel('Static Pressure (Pa)');
title('X4D: Static Pressure Field');
grid on;

% Plot 6: Velocity magnitude distribution
subplot(2, 3, 6);
histogram(vel_mag_x3d, 50, 'FaceColor', 'b', 'FaceAlpha', 0.5); hold on;
histogram(vel_mag_x4d, 50, 'FaceColor', 'r', 'FaceAlpha', 0.5);
xlabel('Velocity Magnitude (m/s)');
ylabel('Frequency');
legend('X3D', 'X4D');
title('Velocity Magnitude Distribution');
grid on;

%=====================================================
% Generate summary statistics
%=====================================================
fprintf('\n%s\n', repmat('=', 1, 60));
fprintf('VELOCITY PROFILE STATISTICS\n');
fprintf('%s\n\n', repmat('=', 1, 60));

fprintf('X3D Data:\n');
fprintf('  Velocity Magnitude - Mean: %.4f m/s, Std: %.4f m/s\n', mean(vel_mag_x3d), std(vel_mag_x3d));
fprintf('  Velocity Magnitude - Min: %.4f m/s, Max: %.4f m/s\n', min(vel_mag_x3d), max(vel_mag_x3d));
fprintf('  Static Pressure - Mean: %.4f Pa, Std: %.4f Pa\n', mean(pressure_x3d), std(pressure_x3d));
fprintf('  Static Pressure - Min: %.4f Pa, Max: %.4f Pa\n\n', min(pressure_x3d), max(pressure_x3d));

fprintf('X4D Data:\n');
fprintf('  Velocity Magnitude - Mean: %.4f m/s, Std: %.4f m/s\n', mean(vel_mag_x4d), std(vel_mag_x4d));
fprintf('  Velocity Magnitude - Min: %.4f m/s, Max: %.4f m/s\n', min(vel_mag_x4d), max(vel_mag_x4d));
fprintf('  Static Pressure - Mean: %.4f Pa, Std: %.4f Pa\n', mean(pressure_x4d), std(pressure_x4d));
fprintf('  Static Pressure - Min: %.4f Pa, Max: %.4f Pa\n\n', min(pressure_x4d), max(pressure_x4d));

fprintf('%s\n', repmat('=', 1, 60));

% Optional: Create additional detailed plots if needed
figure('Name', 'Velocity Components Analysis', 'NumberTitle', 'off', 'Position', [100 100 1400 900]);

% X3D components
subplot(2, 3, 1);
plot(vel_i_x3d, 'r-', 'LineWidth', 1.5); hold on;
plot(vel_j_x3d, 'g-', 'LineWidth', 1.5);
plot(vel_k_x3d, 'b-', 'LineWidth', 1.5);
xlabel('Data Point Index');
ylabel('Velocity Component (m/s)');
legend('i-component', 'j-component', 'k-component');
title('X3D: Velocity Components');
grid on;

% X4D components
subplot(2, 3, 2);
plot(vel_i_x4d, 'r-', 'LineWidth', 1.5); hold on;
plot(vel_j_x4d, 'g-', 'LineWidth', 1.5);
plot(vel_k_x4d, 'b-', 'LineWidth', 1.5);
xlabel('Data Point Index');
ylabel('Velocity Component (m/s)');
legend('i-component', 'j-component', 'k-component');
title('X4D: Velocity Components');
grid on;

% Y-Z plane velocity vectors at X3D
subplot(2, 3, 3);
quiver(pos_y_x3d(1:10:end), pos_z_x3d(1:10:end), vel_j_x3d(1:10:end), vel_k_x3d(1:10:end));
xlabel('Y Position (m)');
ylabel('Z Position (m)');
title('X3D: Velocity Vectors in Y-Z Plane (subsampled)');
grid on;
axis equal;

% Y-Z plane velocity vectors at X4D
subplot(2, 3, 4);
quiver(pos_y_x4d(1:10:end), pos_z_x4d(1:10:end), vel_j_x4d(1:10:end), vel_k_x4d(1:10:end));
xlabel('Y Position (m)');
ylabel('Z Position (m)');
title('X4D: Velocity Vectors in Y-Z Plane (subsampled)');
grid on;
axis equal;

% Comparison of j-component
subplot(2, 3, 5);
plot(vel_j_x3d, 'b-', 'LineWidth', 1.5); hold on;
plot(vel_j_x4d, 'r-', 'LineWidth', 1.5);
xlabel('Data Point Index');
ylabel('j-component (m/s)');
legend('X3D', 'X4D');
title('j-component Comparison');
grid on;

% Comparison of k-component
subplot(2, 3, 6);
plot(vel_k_x3d, 'b-', 'LineWidth', 1.5); hold on;
plot(vel_k_x4d, 'r-', 'LineWidth', 1.5);
xlabel('Data Point Index');
ylabel('k-component (m/s)');
legend('X3D', 'X4D');
title('k-component Comparison');
grid on;

fprintf('\nAnalysis complete. Two figures have been created.\n');
