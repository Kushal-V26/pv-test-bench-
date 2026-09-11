%% pv_efficiency_analysis.m
% Theoretical vs. measured PV panel efficiency analysis.
% Reconstruction of bachelor project analysis (solar panel test bench).
%
% PLACEHOLDER DATASHEET VALUES — replace with the real panel's datasheet
% numbers from your report before publishing results.
%
% Simplest compliant approach: single-diode I-V model solved with a
% fixed-point iteration (no toolboxes required), plus a synthetic
% "measured" curve built by applying realistic real-world losses
% (series resistance, temperature derating, irradiance mismatch) to the
% theoretical curve. Replace the synthetic measured data with your real
% multimeter/logger readings when available (see loadMeasuredData below).

clear; clc; close all;

%% ---- Placeholder panel datasheet (STC: 1000 W/m^2, 25 degC) ----
Voc_stc   = 21.6;      % V   open-circuit voltage
Isc_stc   = 0.61;      % A   short-circuit current
Vmp_stc   = 17.8;      % V   voltage at max power point
Imp_stc   = 0.56;      % A   current at max power point
Pmp_stc   = Vmp_stc * Imp_stc;   % W
panelArea = 0.4 * 0.3;           % m^2  (matches placeholder CAD dims)

n_cells   = 36;        % number of series cells (typical small panel)
k         = 1.380649e-23;  % Boltzmann constant
q         = 1.602176634e-19; % electron charge
idealityFactor = 1.3;

%% ---- Test conditions to sweep (replace with your logged conditions) ----
irradiance = [1000, 800, 600, 400];   % W/m^2
temperature = [25, 35, 45, 55];       % degC, panel surface temp

tempCoeff_Voc = -0.0032;  % per degC (typical crystalline Si, fraction of Voc_stc)
tempCoeff_Isc =  0.0005;  % per degC (fraction of Isc_stc)

results = table();

for i = 1:length(irradiance)
    G = irradiance(i);
    T = temperature(i);
    Tk = T + 273.15;

    % Adjust Voc/Isc for irradiance and temperature
    Isc_T = Isc_stc * (G / 1000) * (1 + tempCoeff_Isc * (T - 25));
    Voc_T = Voc_stc * (1 + tempCoeff_Voc * (T - 25));

    Vt = n_cells * idealityFactor * k * Tk / q;   % thermal voltage

    % ---- Theoretical I-V curve (single-diode, ignoring Rs/Rsh) ----
    V = linspace(0, Voc_T, 200);
    I0 = Isc_T / (exp(Voc_T / Vt) - 1);
    I_theoretical = Isc_T - I0 * (exp(V / Vt) - 1);
    I_theoretical(I_theoretical < 0) = 0;
    P_theoretical = V .* I_theoretical;
    [Pmp_theo, idx_theo] = max(P_theoretical);
    Vmp_theo = V(idx_theo);
    eff_theo = Pmp_theo / (G * panelArea) * 100;

    % ---- Synthetic "measured" curve: real-world losses ----
    % Replace this block with loadMeasuredData(G, T) once you have real
    % logger/multimeter readings from the report.
    Rs = 0.9;                       % Ohm, series resistance loss
    mismatchLoss = 0.94;            % wiring/mismatch/soiling derate
    I_measured = max(I_theoretical - V .* (1/1e4) - Rs * 0.02, 0) * mismatchLoss;
    P_measured = V .* I_measured;
    [Pmp_meas, idx_meas] = max(P_measured);
    Vmp_meas = V(idx_meas);
    eff_meas = Pmp_meas / (G * panelArea) * 100;

    % ---- Plot ----
    figure('Name', sprintf('G=%dW/m^2, T=%dC', G, T));
    subplot(2,1,1);
    plot(V, I_theoretical, 'b-', 'LineWidth', 1.5); hold on;
    plot(V, I_measured, 'r--', 'LineWidth', 1.5);
    xlabel('Voltage (V)'); ylabel('Current (A)');
    legend('Theoretical', 'Measured', 'Location', 'southwest');
    title(sprintf('I-V Curve  |  G = %d W/m^2, T = %d degC', G, T));
    grid on;

    subplot(2,1,2);
    plot(V, P_theoretical, 'b-', 'LineWidth', 1.5); hold on;
    plot(V, P_measured, 'r--', 'LineWidth', 1.5);
    plot(Vmp_theo, Pmp_theo, 'bo', 'MarkerFaceColor', 'b');
    plot(Vmp_meas, Pmp_meas, 'ro', 'MarkerFaceColor', 'r');
    xlabel('Voltage (V)'); ylabel('Power (W)');
    legend('Theoretical', 'Measured', 'Location', 'southwest');
    title('P-V Curve');
    grid on;

    saveas(gcf, sprintf('pv_curve_G%d_T%d.png', G, T));

    results = [results; table(G, T, Pmp_theo, Pmp_meas, eff_theo, eff_meas, ...
        'VariableNames', {'Irradiance_Wm2','Temp_C','Pmp_theoretical_W', ...
        'Pmp_measured_W','Efficiency_theoretical_pct','Efficiency_measured_pct'})];
end

disp(results);
writetable(results, 'pv_efficiency_summary.csv');

%% ---- Efficiency drop-off summary plot ----
figure('Name', 'Efficiency vs Irradiance');
plot(results.Irradiance_Wm2, results.Efficiency_theoretical_pct, 'b-o', 'LineWidth', 1.5); hold on;
plot(results.Irradiance_Wm2, results.Efficiency_measured_pct, 'r-s', 'LineWidth', 1.5);
xlabel('Irradiance (W/m^2)'); ylabel('Efficiency (%)');
legend('Theoretical', 'Measured', 'Location', 'best');
title('Panel Efficiency: Theoretical vs Measured');
grid on;
saveas(gcf, 'efficiency_vs_irradiance.png');

%% ---- Helper for real data (fill in once report is available) ----
function [V, I] = loadMeasuredData(G, T)
    % TODO: replace with actual logged V-I sweep from the report,
    % e.g. read from a CSV: readmatrix(sprintf('measured_G%d_T%d.csv', G, T))
    V = [];
    I = [];
end
