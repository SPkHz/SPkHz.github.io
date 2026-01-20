function dp3_IMN_OMN_driver_gpu()

% runs both IMN and OMN networks and compares with target value

clc;
clear;
close all;

% Constants
G = 1e9; M = 1e6; K = 1e3;
m = 1e-3; u = 1e-6; n = 1e-9;
p = 1e-12; f = 1e-15;

% Transistor parameters
Ri = 23.0767;
Ci = 245.2104 * f;
Li = 347.8189 * p;
Ro = 44.0222;
Co = 283.0342 * f;
Lo = 202.0340 * p;
Z0 = 50;

% Frequency specifications
fL = 9*G;
fH = 20*G;
f0 = sqrt(fL*fH);
f_min = 8*G;
f_max = 21*G;
df = 25*M;

% Initialize frequency sweep
freq = f_min:df:f_max;
fx = [fL, f0, fH];
freq = union(freq, fx);
freq = sort(freq);
N_Freq = length(freq);

% IMN & OMN Test
fprintf('========== Running IMN Design ==========\n');
[S_IMN, nt_I, Parts_I, T_IMN] = dp3_IMN_gpu_Placzek();

fprintf('\n========== Running OMN Design ==========\n');
[S_OMN, nt_O, Parts_O, ~, T_OMN] = dp3_OMN_gpu_Placzek();

%% -------------------- Full Circuit Simulation --------------------
fprintf('\n========== Running Full Amplifier Simulation ==========\n');

% Load S-parameter data for transistor
[freq_FET, S_FET, Mult] = Read_SParam_s2p('NE321000.s2p');
freq_FET = freq_FET * Mult;

% Simulate amplifier with both IMN and OMN
S_Amp = zeros(N_Freq, 2, 2);

for kk = 1:N_Freq
    fk = freq(kk);
    
    % Interpolate transistor S-parameters
    Sx = S_Param_Interp(S_FET, freq_FET, fk);
    Tx = S_to_ABCD(Sx, Z0);
    
    % Get IMN and OMN ABCD matrices for this frequency
    T_IMN_k = squeeze(T_IMN(kk, :, :));
    T_OMN_k = squeeze(T_OMN(kk, :, :));
    
    % Cascade: IMN -> Device -> OMN
    T_total = T_IMN_k * Tx * T_OMN_k;
    
    % Convert to S-parameters
    S_Amp(kk, :, :) = ABCD_to_S(T_total, Z0);
end

%% -------------------- Extract S-Parameters --------------------
S11_Amp = S_Amp(:, 1, 1);
S11_Amp_Mag = abs(S11_Amp);
S11_Amp_dB = 20*log10(S11_Amp_Mag);
S21_Amp = S_Amp(:, 2, 1);
S21_Amp_Mag = abs(S21_Amp);
S21_Amp_dB = 20*log10(S21_Amp_Mag);
S22_Amp = S_Amp(:, 2, 2);
S22_Amp_Mag = abs(S22_Amp);
S22_Amp_dB = 20*log10(S22_Amp_Mag);
S12_Amp = S_Amp(:, 1, 2);
S12_Amp_Mag = abs(S12_Amp);
S12_Amp_dB = 20*log10(S12_Amp_Mag);

% Find markers at specific frequencies
I_fx = ismember(freq, fx);
S11_fx_dB = S11_Amp_dB(I_fx);
S21_fx_dB = S21_Amp_dB(I_fx);
S22_fx_dB = S22_Amp_dB(I_fx);

% Check if gain meets specs at f0
I_f0 = find(freq == f0, 1);
if ~isempty(I_f0)
    f0_gain = S21_Amp_dB(I_f0);
    fprintf('Gain at f0 (%.2f GHz): %.2f dB\n', f0/G, f0_gain);
    if abs(f0_gain - 8.15) <= 0.17
        fprintf('✓ Gain meets specification (8.15 dB ± 0.17 dB)\n');
    else
        fprintf('✗ Gain does not meet specification\n');
    end
end

%% -------------------- Plot Results --------------------
figure(1);
plot(freq / G, S21_Amp_dB, 'r', 'LineWidth', 2.5); hold on;
plot(fx / G, S21_Amp_dB(I_fx), 'ro', 'LineWidth', 4);
grid on; grid minor;
xlabel('Frequency (GHz)');
ylabel('|S_{21}| (dB)');
title('Amplifier Gain');
axis([f_min/G, f_max/G, 6, 9]);
legend('S_{21}', 'Marker Points', 'Location', 'best');

figure(2);
plot(freq / G, S11_Amp_dB, 'b', 'LineWidth', 2.5); hold on;
plot(fx / G, S11_Amp_dB(I_fx), 'bo', 'LineWidth', 4);
grid on; grid minor;
xlabel('Frequency (GHz)');
ylabel('|S_{11}| (dB)');
title('Input Return Loss');
axis([f_min/G, f_max/G, -25, 0]);
legend('S_{11}', 'Marker Points', 'Location', 'best');

figure(3);
plot(freq / G, S22_Amp_dB, 'g', 'LineWidth', 2.5); hold on;
plot(fx / G, S22_Amp_dB(I_fx), 'go', 'LineWidth', 4);
grid on; grid minor;
xlabel('Frequency (GHz)');
ylabel('|S_{22}| (dB)');
title('Output Return Loss');
axis([f_min/G, f_max/G, -25, 0]);
legend('S_{22}', 'Marker Points', 'Location', 'best');

fprintf('\nSimulation complete. Please check plots for amplifier performance.\n');
end
