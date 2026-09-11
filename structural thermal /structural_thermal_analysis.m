%% structural_thermal_analysis.m
% Structural (wind load) and thermal (thermal expansion) analysis of the
% PV test bench frame. Closed-form engineering calculations — an
% open-source stand-in for the ANSYS Static Structural / Steady-State
% Thermal study (see ANSYS_SETUP_NOTES.md to reproduce it in real ANSYS).
%
% PLACEHOLDER geometry & material values — replace with your real frame
% dimensions and test conditions once you have the report.

clear; clc; close all;

%% ---- Placeholder geometry (matches the CAD model) ----
panel_L = 0.400;          % m, panel length
panel_W = 0.300;          % m, panel width
panelArea = panel_L * panel_W;   % m^2

strutWidth  = 0.020;      % m
strutThick  = 0.006;      % m
strutLength = 0.220;      % m, cantilevered support strut

%% ---- Aluminium 6061 material properties ----
E_al     = 69e9;          % Pa, Young's modulus
alpha_al = 23.1e-6;       % 1/degC, thermal expansion coefficient
yield_al = 240e6;         % Pa, yield strength
rho_air  = 1.225;         % kg/m^3
Cd_flat  = 1.28;          % drag coefficient, flat plate

I_strut = (strutWidth * strutThick^3) / 12;   % m^4, second moment of area
c_strut = strutThick / 2;                     % m, distance to outer fiber

%% ---- Wind load sweep across tilt angle and wind speed ----
tiltAngles = 0:15:90;              % deg, matches CAD protractor notches
windSpeeds = [5, 10, 15, 20];      % m/s

nT = length(tiltAngles);
nV = length(windSpeeds);

windForce  = zeros(nV, nT);   % N
bendStress = zeros(nV, nT);   % MPa
deflection = zeros(nV, nT);   % mm
safetyFac  = zeros(nV, nT);

for i = 1:nV
    v = windSpeeds(i);
    q_dyn = 0.5 * rho_air * v^2;          % dynamic pressure, Pa
    for j = 1:nT
        tiltRad = deg2rad(tiltAngles(j));
        if tiltAngles(j) > 0
            effArea = panelArea * sin(tiltRad);
        else
            effArea = panelArea * 0.05;    % near edge-on, small residual area
        end
        F = q_dyn * Cd_flat * effArea;             % N
        M = F * strutLength;                       % N*m
        sigma = M * c_strut / I_strut;              % Pa
        defl  = (F * strutLength^3) / (3 * E_al * I_strut);  % m

        windForce(i, j)  = F;
        bendStress(i, j) = sigma / 1e6;             % MPa
        deflection(i, j) = defl * 1000;             % mm
        if sigma > 0
            safetyFac(i, j) = yield_al / sigma;
        else
            safetyFac(i, j) = Inf;
        end
    end
end

%% ---- Thermal expansion of the frame ----
deltaT = 0:5:60;                              % degC rise from install baseline
frameDiagonal = hypot(panel_L, panel_W);      % m, worst-case dimension
thermalExpansion_mm = alpha_al * frameDiagonal * deltaT * 1000;  % mm

%% ---- Plots ----
figure('Name', 'Bending Stress vs Tilt & Wind Speed');
hold on;
for i = 1:nV
    plot(tiltAngles, bendStress(i, :), '-o', 'LineWidth', 1.5, ...
        'DisplayName', sprintf('%d m/s', windSpeeds(i)));
end
yline(yield_al / 1e6, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Yield strength');
xlabel('Tilt angle (deg)'); ylabel('Bending stress in strut (MPa)');
title('Support Strut Bending Stress vs Tilt Angle & Wind Speed');
legend('Location', 'northwest'); grid on;
saveas(gcf, 'stress_vs_tilt_wind.png');

figure('Name', 'Deflection vs Tilt & Wind Speed');
hold on;
for i = 1:nV
    plot(tiltAngles, deflection(i, :), '-s', 'LineWidth', 1.5, ...
        'DisplayName', sprintf('%d m/s', windSpeeds(i)));
end
xlabel('Tilt angle (deg)'); ylabel('Strut tip deflection (mm)');
title('Support Strut Deflection vs Tilt Angle & Wind Speed');
legend('Location', 'northwest'); grid on;
saveas(gcf, 'deflection_vs_tilt_wind.png');

figure('Name', 'Thermal Expansion');
plot(deltaT, thermalExpansion_mm, '-o', 'LineWidth', 1.5, 'Color', [0.85 0.33 0.10]);
xlabel('Temperature rise from install baseline (degC)');
ylabel('Frame diagonal expansion (mm)');
title('Thermal Expansion of Aluminium Frame');
grid on;
saveas(gcf, 'thermal_expansion.png');

%% ---- Summary table + worst case ----
[minSF, idx] = min(safetyFac(:));
[iw, it] = ind2sub(size(safetyFac), idx);
fprintf('Worst case: wind = %d m/s, tilt = %d deg -> stress = %.2f MPa, safety factor = %.1f\n', ...
    windSpeeds(iw), tiltAngles(it), bendStress(iw, it), minSF);
fprintf('Max thermal expansion over %d degC rise: %.3f mm\n', deltaT(end), thermalExpansion_mm(end));

% flatten results into a plain table, one row per (wind speed, tilt) pair
windCol  = zeros(nV * nT, 1);
tiltCol  = zeros(nV * nT, 1);
forceCol = zeros(nV * nT, 1);
stressCol = zeros(nV * nT, 1);
deflCol  = zeros(nV * nT, 1);
sfCol    = zeros(nV * nT, 1);

row = 0;
for i = 1:nV
    for j = 1:nT
        row = row + 1;
        windCol(row)  = windSpeeds(i);
        tiltCol(row)  = tiltAngles(j);
        forceCol(row) = windForce(i, j);
        stressCol(row) = bendStress(i, j);
        deflCol(row)  = deflection(i, j);
        sfCol(row)    = safetyFac(i, j);
    end
end

resultsTable = table(windCol, tiltCol, forceCol, stressCol, deflCol, sfCol, ...
    'VariableNames', {'WindSpeed_ms','Tilt_deg','WindForce_N','BendingStress_MPa', ...
                       'Deflection_mm','SafetyFactor'});
writetable(resultsTable, 'structural_summary.csv');
