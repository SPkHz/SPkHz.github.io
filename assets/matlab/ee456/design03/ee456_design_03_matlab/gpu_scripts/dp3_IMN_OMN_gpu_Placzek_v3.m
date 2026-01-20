%% 5-Element IMN Chebyshev Matching Network with Transformer for NE321000
% Implements the specific IMN topology: C5-C4-L3-L2-L6 with transformer
% For NEC NE321000 Transistor
% Design specifications:
% - Frequency range: 9-20 GHz
% - Sloped response (6 dB/octave)
% - IL_min = 0.0 dB and Ripple = 0.1 dB

clc;
clear all;
close all;



%% Constants and Unit Conversion
G = 10^9;    % 1 GHz
M = 10^6;    % 1 MHz
K = 10^3;    % 1 kHz
m = 10^-3;   % 1 milli
u = 10^-6;   % 1 micro
n = 10^-9;   % 1 nano
p = 10^-12;  % 1 pico
f = 10^-15;  % 1 femto

%% User Variables from Project Specs
fL = 9*G;    % Lower frequency (Hz)
fH = 20*G;   % Upper frequency (Hz)
f0 = sqrt(fL*fH);  % Center frequency (Hz)
fc = f0;     % Design center frequency (Hz)
BW_design = fH - fL;  % Design bandwidth (Hz)
Zs = 50;     % Source impedance (ohm)
Z0 = 50;     % System impedance (ohm)
N = 5;       % Network order (5 reactive elements)
Goal = -15;  % Goal S11 (dB)
ripple = 0.1; % Passband ripple in dB for Chebyshev filter
NS = 1;      % Use sloped insertion loss function (6 dB/octave)
NF = 14;     % Font size for plots

% Component bounds for optimization
L_lb = 0.2e-9;  % Lower bound of inductance (nH)
L_ub = 10.0e-9; % Upper bound of inductance (nH)
C_lb = 0.05e-12; % Lower bound of capacitance (pF)
C_ub = 5.0e-12;  % Upper bound of capacitance (pF)

% Transistor input impedance model parameters (from project specs)
Ri = 23.0767;         % Input resistance (ohms)
Ci = 245.2104 * f;    % Input capacitance (F)
Li = 347.8189 * p;    % Input inductance (H)

%% Frequency calculations
f_min = 8*G;   % Min freq for plotting (Hz)
f_max = 22*G;  % Max freq for plotting (Hz)
df = 50*M;     % Frequency step (Hz)

% Initialize frequency sweep
freq = f_min:df:f_max;
freq_key = [fL, f0, fH];
freq = union(freq, freq_key);
freq = sort(freq);
N_Freq = length(freq);
w = 2*pi*freq;  % Angular frequency

% Important angular frequencies
wU = 2*pi*fH;    % Upper angular frequency
wL = 2*pi*fL;    % Lower angular frequency
w0 = sqrt(wL*wU); % Center angular frequency
BW_w = wU - wL;  % Bandwidth (rad/s)

%% S-Parameter Reading for the NE321000 Transistor
% Read the S-parameter data from the uploaded file
fprintf('Reading S-parameters from NE321000.s2p file...\n');
[freq_FET, S_FET, Mult, S_Type] = Read_SParam_s2p('NE321000.s2p');

% Calculate impedance at each frequency point
Z0_FET = 50; % Assume 50 ohm reference
S11_FET = squeeze(S_FET(:,1,1));
Z_FET = Z0_FET * (1 + S11_FET) ./ (1 - S11_FET);

% Plot transistor S-parameters and impedance
figure(1);
plot(freq_FET/G, 20*log10(abs(squeeze(S_FET(:,1,1)))), 'b-', 'LineWidth', 1.5); hold on;
plot(freq_FET/G, 20*log10(abs(squeeze(S_FET(:,2,1)))), 'r-', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (GHz)', 'FontSize', NF);
ylabel('Magnitude (dB)', 'FontSize', NF);
title('NE321000 Transistor S-Parameters', 'FontSize', NF);
legend('S11', 'S21', 'Location', 'best');
set(gca, 'FontSize', NF);

figure(2);
plot(freq_FET/G, real(Z_FET), 'b-', 'LineWidth', 1.5); hold on;
plot(freq_FET/G, imag(Z_FET), 'r-', 'LineWidth', 1.5);
grid on;
xlabel('Frequency (GHz)', 'FontSize', NF);
ylabel('Impedance (Ω)', 'FontSize', NF);
title('NE321000 Transistor Input Impedance', 'FontSize', NF);
legend('Real', 'Imaginary', 'Location', 'best');
set(gca, 'FontSize', NF);

%% Filter prototype - Chebyshev type I
% Calculate Chebyshev type I prototype element values
g = cheby1_g(N, ripple);

% Convert normalized filter prototype to component values
% The topology is: C5 (series) - C4 (shunt) - L3 (shunt) - L2 (series) - L6 (shunt)

% Calculate bandpass transformation scaling factors
FBW = BW_design/f0; % Fractional bandwidth

% For bandpass with Chebyshev prototype:
C5 = 1/(BW_w*Z0*w0*g(1));      % Series capacitor
C4 = g(2)/(BW_w*Z0);           % Shunt capacitor  
L3 = Z0*(BW_w)/(w0^2*g(3));    % Shunt inductor
L2 = Z0*g(4)/(BW_w);           % Series inductor
L6 = Z0*(BW_w)/(w0^2*g(5));    % Shunt inductor

% Store initial values
C5_init = C5;
C4_init = C4;
L3_init = L3;
L2_init = L2;
L6_init = L6;

% Display initial values (in pF and nH)
fprintf('Initial component values from Chebyshev prototype:\n');
fprintf('C5 = %.4f pF (series)\n', C5*1e12);
fprintf('C4 = %.4f pF (shunt)\n', C4*1e12);
fprintf('L3 = %.4f nH (shunt)\n', L3*1e9);
fprintf('L2 = %.4f nH (series)\n', L2*1e9);
fprintf('L6 = %.4f nH (shunt)\n', L6*1e9);

%% Transformer turns ratio calculation
% Calculate transformer initial value based on input impedance
nt_initial = sqrt(Z0/Ri);
fprintf('Initial transformer turns ratio = %.4f\n', nt_initial);

%% Impedance Matching Optimization
% Prepare optimization variables
x0 = [C5*1e12, C4*1e12, L3*1e9, L2*1e9, L6*1e9, nt_initial];  % Initial values [pF, pF, nH, nH, nH, ratio]
lb = [C_lb, C_lb, L_lb, L_lb, L_lb, 0.5];  % Lower bounds
ub = [C_ub, C_ub, L_ub, L_ub, L_ub, 3.0];  % Upper bounds

% Optimization function for sloped response
objFun = @(x) evaluate_network_sloped(x, freq, N_Freq, Ri, Ci, Li, Z0, Goal, fL, fH);

% Run the optimizer
fprintf('Starting optimization...\n');
options = optimoptions('fmincon', 'Display', 'iter', 'MaxIterations', 100, 'MaxFunctionEvaluations', 500);
[xopt, fval] = fmincon(objFun, x0, [], [], [], [], lb, ub, [], options);

% Get optimized component values
C5_opt = xopt(1)*1e-12;  % Convert back to F
C4_opt = xopt(2)*1e-12;
L3_opt = xopt(3)*1e-9;   % Convert back to H
L2_opt = xopt(4)*1e-9;
L6_opt = xopt(5)*1e-9;
nt_opt = xopt(6);        % Transformer turns ratio

% Display optimized values
fprintf('\nOptimized component values:\n');
fprintf('C5 = %.4f pF (series)\n', C5_opt*1e12);
fprintf('C4 = %.4f pF (shunt)\n', C4_opt*1e12);
fprintf('L3 = %.4f nH (shunt)\n', L3_opt*1e9);
fprintf('L2 = %.4f nH (series)\n', L2_opt*1e9);
fprintf('L6 = %.4f nH (shunt)\n', L6_opt*1e9);
fprintf('Transformer turns ratio = %.4f\n', nt_opt);
fprintf('Objective function value: %.4f\n', fval);

%% Evaluate initial and optimized networks
[S11_init, S21_init] = evaluate_full_network([C5_init*1e12, C4_init*1e12, L3_init*1e9, L2_init*1e9, L6_init*1e9, nt_initial], freq, Ri, Ci, Li, Z0);
[S11_opt, S21_opt] = evaluate_full_network([C5_opt*1e12, C4_opt*1e12, L3_opt*1e9, L2_opt*1e9, L6_opt*1e9, nt_opt], freq, Ri, Ci, Li, Z0);

% Find S-parameters at key frequencies
I_fx = ismember(freq, freq_key);
S11_fx_dB = 20*log10(abs(S11_opt(I_fx)));
S21_fx_dB = 20*log10(abs(S21_opt(I_fx)));

%% Plot results
figure(3);
plot(freq/G, 20*log10(abs(S11_init)), 'b--', 'LineWidth', 1.5); hold on;
plot(freq/G, 20*log10(abs(S11_opt)), 'r-', 'LineWidth', 2);
plot(freq_key/G, S11_fx_dB, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
yline(Goal, 'k:', 'LineWidth', 1.5);
grid on;
xlim([f_min/G, f_max/G]);
xlabel('Frequency (GHz)', 'FontSize', NF);
ylabel('S11 (dB)', 'FontSize', NF);
legend('Initial', 'Optimized', 'Key Points', 'Goal', 'Location', 'best');
title('Input Return Loss (S11)', 'FontSize', NF);
set(gca, 'FontSize', NF);

figure(4);
plot(freq/G, 20*log10(abs(S21_init)), 'b--', 'LineWidth', 1.5); hold on;
plot(freq/G, 20*log10(abs(S21_opt)), 'r-', 'LineWidth', 2);
plot(freq_key/G, S21_fx_dB, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
grid on;
xlim([f_min/G, f_max/G]);
xlabel('Frequency (GHz)', 'FontSize', NF);
ylabel('S21 (dB)', 'FontSize', NF);
legend('Initial', 'Optimized', 'Key Points', 'Location', 'best');
title('Forward Transmission (S21)', 'FontSize', NF);
set(gca, 'FontSize', NF);

%% Calculate performance metrics
fprintf('\nPerformance metrics:\n');

% Find band indices
band_idx = (freq >= fL) & (freq <= fH);
f_band = freq(band_idx);

% S11 metrics
S11_opt_band = S11_opt(band_idx);
S11_opt_dB = 20*log10(abs(S11_opt_band));
S11_worst = max(S11_opt_dB);
S11_avg = mean(S11_opt_dB);

fprintf('S11 worst in band: %.2f dB\n', S11_worst);
fprintf('S11 average in band: %.2f dB\n', S11_avg);

% S21 metrics
S21_opt_band = S21_opt(band_idx);
S21_opt_dB = 20*log10(abs(S21_opt_band));
S21_min = min(S21_opt_dB);
S21_max = max(S21_opt_dB);
S21_avg = mean(S21_opt_dB);
S21_flatness = S21_max - S21_min;

fprintf('S21 min in band: %.2f dB\n', S21_min);
fprintf('S21 max in band: %.2f dB\n', S21_max);
fprintf('S21 average in band: %.2f dB\n', S21_avg);
fprintf('S21 flatness in band: %.2f dB\n', S21_flatness);

% Check if we meet the 6 dB/octave slope requirement
S21_9GHz = interp1(freq, 20*log10(abs(S21_opt)), 9*G);
S21_18GHz = interp1(freq, 20*log10(abs(S21_opt)), 18*G);
slope_per_octave = S21_9GHz - S21_18GHz;
fprintf('S21 slope: %.2f dB/octave (target: 6 dB/octave)\n', slope_per_octave);

% % Create a Smith chart to visualize the matching
% figure(5);
% smithchart; hold on;
% % Convert S11 to reflection coefficient and plot
% plot(real(S11_opt), imag(S11_opt), 'r-', 'LineWidth', 2);
% % Mark the key frequencies
% plot(real(S11_opt(I_fx)), imag(S11_opt(I_fx)), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
% title('Input Matching on Smith Chart', 'FontSize', NF);
% set(gca, 'FontSize', NF);

%% Save Results to a Mat File
save('NE321000_IMN_Design.mat', 'C5_opt', 'C4_opt', 'L3_opt', 'L2_opt', 'L6_opt', 'nt_opt', ...
    'freq', 'S11_opt', 'S21_opt', 'S11_opt_dB', 'S21_opt_dB', 'fL', 'f0', 'fH');

%% Helper functions
function g = cheby1_g(n, ripple_dB)
    % Calculate Chebyshev Type I filter prototype element values
    % n: filter order
    % ripple_dB: passband ripple in dB
    
    % Convert ripple from dB to linear scale
    epsilon = sqrt(10^(ripple_dB/10) - 1);
    
    % Calculate beta parameter
    beta = log(coth(ripple_dB/17.37));
    gamma = sinh(beta/(2*n));
    
    % Calculate a parameter
    a = zeros(1, n);
    for i = 1:n
        a(i) = sin(pi*(2*i-1)/(2*n));
    end
    
    % Initialize g values
    g = zeros(1, n+1);
    g(1) = 2*a(1)/gamma;
    
    % Calculate remaining g values
    for i = 2:n
        b1 = 1;
        b2 = 1;
        for j = 1:i-1
            b1 = b1 * a(j);
            b2 = b2 * a(i-j);
        end
        g(i) = 4*a(i-1)*a(i)/(b1*b2*gamma);
    end
    
    % Last element (for odd and even orders)
    if mod(n, 2) == 0
        % Even order
        b = 1;
        for j = 1:n/2
            b = b * sin((2*j-1)*pi/(2*n));
        end
        g(n+1) = 1/(tanh(beta/4)^2);
    else
        % Odd order
        g(n+1) = 1;
    end
end

function [S11, S21] = evaluate_full_network(x, freq, Ri, Ci, Li, Z0)
    % Evaluate the network performance for analysis
    % x: component values [C5, C4, L3, L2, L6, nt] in pF, nH and ratio
    
    % Convert to SI units
    C5 = x(1)*1e-12;  % pF to F
    C4 = x(2)*1e-12;
    L3 = x(3)*1e-9;   % nH to H
    L2 = x(4)*1e-9;
    L6 = x(5)*1e-9;
    nt = x(6);        % Transformer turns ratio
    
    % Frequency dependent analysis
    N_Freq = length(freq);
    S11 = zeros(N_Freq, 1);
    S21 = zeros(N_Freq, 1);
    
    for k = 1:N_Freq
        f_k = freq(k);
        w_k = 2*pi*f_k;
        
        % Transistor input impedance
        Z_transistor = Ri + 1/(1i*w_k*Ci) + 1i*w_k*Li;
        
        % Reflected impedance through transformer
        Z_reflected = Z_transistor / (nt^2);
        
        % Network elements' impedances
        Z_C5 = 1/(1i*w_k*C5);
        Z_C4 = 1/(1i*w_k*C4);
        Z_L3 = 1i*w_k*L3;
        Z_L2 = 1i*w_k*L2;
        Z_L6 = 1i*w_k*L6;
        
        % ABCD matrix calculation for each element
        T_C5 = [1, Z_C5; 0, 1];  % Series C5
        T_C4 = [1, 0; 1/Z_C4, 1];  % Shunt C4
        T_L3 = [1, 0; 1/Z_L3, 1];  % Shunt L3
        T_L2 = [1, Z_L2; 0, 1];  % Series L2
        T_L6 = [1, 0; 1/Z_L6, 1];  % Shunt L6
        
        % Cascade all matrices
        T = T_C5 * T_C4 * T_L3 * T_L2 * T_L6;
        
        % Convert ABCD to S-parameters with Z0 source and Z_reflected load
        A = T(1,1); B = T(1,2); C = T(2,1); D = T(2,2);
        
        % Calculate S-parameters
        denom = A*Z_reflected + B + C*Z0*Z_reflected + D*Z0;
        S11(k) = (A*Z_reflected + B - C*Z0*Z_reflected - D*Z0)/denom;
        S21(k) = 2*sqrt(real(Z0)*real(Z_reflected))/denom;
    end
end


function cost = evaluate_network_sloped(x, freq, N_Freq, Ri, Ci, Li, Z0, Goal, fL, fH)
    % Evaluate the network performance with a preference for sloped response
    % x: component values [C5, C4, L3, L2, L6, nt] in pF, nH and ratio
    
    % Get S-parameters
    [S11, S21] = evaluate_full_network(x, freq, Ri, Ci, Li, Z0);
    
    % Calculate return loss
    S11_dB = 20*log10(abs(S11));
    
    % Identify frequencies in the band
    band_idx = (freq >= fL) & (freq <= fH);
    f_band = freq(band_idx);
    S21_band = S21(band_idx);
    S21_dB_band = 20*log10(abs(S21_band));
    
    % Calculate cost for S11 (return loss)
    S11_cost = 0;
    for k = 1:N_Freq
        if S11_dB(k) > Goal
            S11_cost = S11_cost + (S11_dB(k) - Goal)^2;
        end
    end
    
    % Calculate cost for S21 slope
    % We want a 6 dB/octave slope (higher at lower frequencies)
    % Extract S21 at key frequencies
    S21_fL = interp1(freq, 20*log10(abs(S21)), fL);
    S21_fH = interp1(freq, 20*log10(abs(S21)), fH);
    
    % Calculate actual slope
    octaves = log2(fH/fL);
    target_slope = 6; % dB/octave
    actual_slope = (S21_fL - S21_fH) / octaves;
    
    % Penalize deviation from target slope
    slope_cost = (actual_slope - target_slope)^2;
    
    % Combine costs with appropriate weights
    total_cost = S11_cost + 2*slope_cost;
    
    % Add small penalty for extreme component values
    if any(x(1:5) < [0.05, 0.05, 0.1, 0.1, 0.1]) || any(x(1:5) > [5, 5, 10, 10, 10])
        total_cost = total_cost + 50;
    end
    
    % Add penalty for extreme transformer ratios
    if x(6) < 0.5 || x(6) > 3
        total_cost = total_cost + 50;
    end
    
    cost = total_cost;
end
