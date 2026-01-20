% Script to run the entire optimization process for the RF amplifier design
% This script orchestrates the optimization of both IMN and OMN, then
% simulates the complete amplifier

clc;
clear all;
close all;

delete(gcp('nocreate'));  % Clean up any existing pool
if isempty(gcp('nocreate'))
    parpool("threads");
end

disp('=========================================================');
disp('RF AMPLIFIER OPTIMIZATION WITH GPU-ACCELERATED SYNTHESIS');
disp('=========================================================');
disp('This script will optimize both the input and output matching');
disp('networks to meet the target specifications of:');
disp('- Frequency range: 9-20 GHz');
disp('- Target gain: 8.15 dB ± 0.17 dB');
disp('- IMN: 7 reactive elements with sloped response');
disp('- OMN: 7 reactive elements with flat response');
disp('=========================================================');

% Start timing the full optimization process
tic;

% Run the optimized implementation
fprintf('\nStarting optimized amplifier design...\n');
[S_OMN, nt_OMN, best_components_OMN, Tholder_OMN] = dp3_OMN_gpu_Placzek_Opt();

% Compute total runtime
total_time = toc;
fprintf('\nTotal optimization and simulation time: %.2f seconds (%.2f minutes)\n', total_time, total_time/60);

% Display final message
disp('=========================================================');
disp('OPTIMIZATION COMPLETE');
disp('Review the plots and performance metrics to evaluate the design.');
disp('Check the component values against the target specifications.');
disp('=========================================================');

% end

% function dp3_IMN_OMN_driver_gpu_Optimized()
% 
% % runs both optimized IMN and OMN networks and compares with target value
% 
% % Constants
% G = 1e9; M = 1e6; K = 1e3;
% m = 1e-3; u = 1e-6; n = 1e-9;
% p = 1e-12; f = 1e-15;
% 
% % Transistor parameters
% Ri = 23.0767;
% Ci = 245.2104 * f;
% Li = 347.8189 * p;
% Ro = 44.0222;
% Co = 283.0342 * f;
% Lo = 202.0340 * p;
% Z0 = 50;
% 
% % Frequency specifications
% fL = 9*G;
% fH = 20*G;
% f0 = sqrt(fL*fH);
% f_min = 8*G;
% f_max = 21*G;
% df = 25*M;
% 
% % Initialize frequency sweep
% freq = f_min:df:f_max;
% fx = [fL, f0, fH];
% freq = union(freq, fx);
% freq = sort(freq);
% N_Freq = length(freq);
% 
% % IMN & OMN Test
% fprintf('========== Running Optimized IMN Design ==========\n');
% tic;
% [S_IMN, nt_I, IMN_Components, T_IMN] = dp3_IMN_gpu_Optimized();
% imn_time = toc;
% fprintf('IMN optimization completed in %.2f seconds\n', imn_time);
% 
% fprintf('\n========== Running Optimized OMN Design ==========\n');
% tic;
% [S_OMN, nt_O, OMN_Components, ~, T_OMN] = dp3_OMN_gpu_Placzek_Optimized();
% omn_time = toc;
% fprintf('OMN optimization completed in %.2f seconds\n', omn_time);
% 
% % Extract IMN components
% [Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7] = deal(IMN_Components{:});
% fprintf('\n========== Final IMN Component Values ==========\n');
% fprintf('Ci1 = %.4f fF\n', Ci1 * 1e15);
% fprintf('Li2 = %.4f pH\n', Li2 * 1e12);
% fprintf('Li3 = %.4f pH\n', Li3 * 1e12);
% fprintf('Ci4 = %.4f fF\n', Ci4 * 1e15);
% fprintf('Ci5 = %.4f fF\n', Ci5 * 1e15);
% fprintf('Ci6 = %.4f fF\n', Ci6 * 1e15);
% fprintf('Li7 = %.4f pH\n', Li7 * 1e12);
% fprintf('Transformer ratio nt_I = %.4f\n', nt_I);
% 
% % Extract OMN components
% [Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7] = deal(OMN_Components{:});
% fprintf('\n========== Final OMN Component Values ==========\n');
% fprintf('Co1 = %.4f fF\n', Co1 * 1e15);
% fprintf('Lo2 = %.4f pH\n', Lo2 * 1e12);
% fprintf('Co3 = %.4f fF\n', Co3 * 1e15);
% fprintf('Lo4 = %.4f pH\n', Lo4 * 1e12);
% fprintf('Lo5 = %.4f pH\n', Lo5 * 1e12);
% fprintf('Lo6 = %.4f pH\n', Lo6 * 1e12);
% fprintf('Co7 = %.4f fF\n', Co7 * 1e15);
% fprintf('Transformer ratio nt_O = %.4f\n', nt_O);
% 
% %% -------------------- Full Circuit Simulation --------------------
% fprintf('\n========== Running Full Amplifier Simulation ==========\n');
% 
% % Load S-parameter data for transistor
% [freq_FET, S_FET, Mult] = Read_SParam_s2p('NE321000.s2p');
% freq_FET = freq_FET * Mult;
% 
% % Simulate amplifier with both IMN and OMN
% S_Amp = zeros(N_Freq, 2, 2);
% 
% for kk = 1:N_Freq
%     fk = freq(kk);
% 
%     % Interpolate transistor S-parameters
%     Sx = S_Param_Interp(S_FET, freq_FET, fk);
%     Tx = S_to_ABCD(Sx, Z0);
% 
%     % Get IMN and OMN ABCD matrices for this frequency
%     T_IMN_k = squeeze(T_IMN(kk, :, :));
%     T_OMN_k = squeeze(T_OMN(kk, :, :));
% 
%     % Cascade: IMN -> Device -> OMN
%     T_total = T_IMN_k * Tx * T_OMN_k;
% 
%     % Convert to S-parameters
%     S_Amp(kk, :, :) = ABCD_to_S(T_total, Z0);
% end
% 
% %% -------------------- Extract S-Parameters --------------------
% S11_Amp = S_Amp(:, 1, 1);
% S11_Amp_Mag = abs(S11_Amp);
% S11_Amp_dB = 20*log10(S11_Amp_Mag);
% S21_Amp = S_Amp(:, 2, 1);
% S21_Amp_Mag = abs(S21_Amp);
% S21_Amp_dB = 20*log10(S21_Amp_Mag);
% S22_Amp = S_Amp(:, 2, 2);
% S22_Amp_Mag = abs(S22_Amp);
% S22_Amp_dB = 20*log10(S22_Amp_Mag);
% S12_Amp = S_Amp(:, 1, 2);
% S12_Amp_Mag = abs(S12_Amp);
% S12_Amp_dB = 20*log10(S12_Amp_Mag);
% 
% % Find markers at specific frequencies
% I_fx = ismember(freq, fx);
% S11_fx_dB = S11_Amp_dB(I_fx);
% S21_fx_dB = S21_Amp_dB(I_fx);
% S22_fx_dB = S22_Amp_dB(I_fx);
% 
% % Check if gain meets specs at f0
% I_f0 = find(freq == f0, 1);
% if ~isempty(I_f0)
%     f0_gain = S21_Amp_dB(I_f0);
%     fprintf('Gain at f0 (%.2f GHz): %.2f dB\n', f0/G, f0_gain);
%     if abs(f0_gain - 8.15) <= 0.17
%         fprintf('✓ Gain meets specification (8.15 dB ± 0.17 dB)\n');
%     else
%         fprintf('✗ Gain does not meet specification\n');
%     end
% end
% 
% % Check gain at key frequencies
% fprintf('\nGain at key frequencies:\n');
% fprintf('Gain at fL (%.2f GHz): %.2f dB\n', fL/G, S21_fx_dB(1));
% fprintf('Gain at f0 (%.2f GHz): %.2f dB\n', f0/G, S21_fx_dB(2));
% fprintf('Gain at fH (%.2f GHz): %.2f dB\n', fH/G, S21_fx_dB(3));
% 
% % Check gain flatness
% gain_range = max(S21_Amp_dB) - min(S21_Amp_dB);
% fprintf('\nGain variation across band (max-min): %.2f dB\n', gain_range);
% 
% % Check return losses
% fprintf('\nReturn losses at key frequencies:\n');
% fprintf('Input return loss at f0 (%.2f GHz): %.2f dB\n', f0/G, S11_fx_dB(2));
% fprintf('Output return loss at f0 (%.2f GHz): %.2f dB\n', f0/G, S22_fx_dB(2));
% 
% %% -------------------- Plot Results --------------------
% figure(1);
% plot(freq / G, S21_Amp_dB, 'r', 'LineWidth', 2.5); hold on;
% plot(fx / G, S21_Amp_dB(I_fx), 'ro', 'LineWidth', 4);
% yline(8.15, 'k--', 'LineWidth', 1.5);
% yline(8.15 + 0.17, 'k:', 'LineWidth', 1);
% yline(8.15 - 0.17, 'k:', 'LineWidth', 1);
% grid on; grid minor;
% xlabel('Frequency (GHz)');
% ylabel('|S_{21}| (dB)');
% title('Optimized Amplifier Gain');
% axis([f_min/G, f_max/G, 6, 9]);
% legend('S_{21}', 'Marker Points', 'Target (8.15 dB)', 'Tolerance Limits', 'Location', 'best');
% 
% figure(2);
% plot(freq / G, S11_Amp_dB, 'b', 'LineWidth', 2.5); hold on;
% plot(fx / G, S11_Amp_dB(I_fx), 'bo', 'LineWidth', 4);
% grid on; grid minor;
% xlabel('Frequency (GHz)');
% ylabel('|S_{11}| (dB)');
% title('Optimized Input Return Loss');
% axis([f_min/G, f_max/G, -25, 0]);
% legend('S_{11}', 'Marker Points', 'Location', 'best');
% 
% figure(3);
% plot(freq / G, S22_Amp_dB, 'g', 'LineWidth', 2.5); hold on;
% plot(fx / G, S22_Amp_dB(I_fx), 'go', 'LineWidth', 4);
% grid on; grid minor;
% xlabel('Frequency (GHz)');
% ylabel('|S_{22}| (dB)');
% title('Optimized Output Return Loss');
% axis([f_min/G, f_max/G, -25, 0]);
% legend('S_{22}', 'Marker Points', 'Location', 'best');
% 
% % Plot S12 as well
% figure(4);
% plot(freq / G, S12_Amp_dB, 'm', 'LineWidth', 2.5); hold on;
% plot(fx / G, S12_Amp_dB(I_fx), 'mo', 'LineWidth', 4);
% grid on; grid minor;
% xlabel('Frequency (GHz)');
% ylabel('|S_{12}| (dB)');
% title('Optimized Reverse Isolation');
% axis([f_min/G, f_max/G, -30, -10]);
% legend('S_{12}', 'Marker Points', 'Location', 'best');
% 
% %% -------------------- Compare with Original Implementation --------------------
% fprintf('\n========== Comparing with Original Implementation ==========\n');
% 
% % Run original implementation
% tic;
% [S_IMN_orig, nt_I_orig, IMN_Parts_orig, T_IMN_orig] = dp3_IMN_gpu_Placzek();
% [S_OMN_orig, nt_O_orig, OMN_Parts_orig, ~, T_OMN_orig] = dp3_OMN_gpu_Placzek();
% orig_implementation_time = toc;
% 
% % Simulate original amplifier
% S_Amp_orig = zeros(N_Freq, 2, 2);
% 
% for kk = 1:N_Freq
%     fk = freq(kk);
% 
%     % Interpolate transistor S-parameters
%     Sx = S_Param_Interp(S_FET, freq_FET, fk);
%     Tx = S_to_ABCD(Sx, Z0);
% 
%     % Get IMN and OMN ABCD matrices for this frequency
%     T_IMN_orig_k = squeeze(T_IMN_orig(kk, :, :));
%     T_OMN_orig_k = squeeze(T_OMN_orig(kk, :, :));
% 
%     % Cascade: IMN -> Device -> OMN
%     T_total_orig = T_IMN_orig_k * Tx * T_OMN_orig_k;
% 
%     % Convert to S-parameters
%     S_Amp_orig(kk, :, :) = ABCD_to_S(T_total_orig, Z0);
% end
% 
% % Extract S-parameters
% S21_Amp_orig = S_Amp_orig(:, 2, 1);
% S21_Amp_orig_dB = 20*log10(abs(S21_Amp_orig));
% S11_Amp_orig = S_Amp_orig(:, 1, 1);
% S11_Amp_orig_dB = 20*log10(abs(S11_Amp_orig));
% S22_Amp_orig = S_Amp_orig(:, 2, 2);
% S22_Amp_orig_dB = 20*log10(abs(S22_Amp_orig));
% 
% % Check if original gain meets specs at f0
% I_f0 = find(freq == f0, 1);
% if ~isempty(I_f0)
%     f0_gain_orig = S21_Amp_orig_dB(I_f0);
%     fprintf('Original gain at f0 (%.2f GHz): %.2f dB\n', f0/G, f0_gain_orig);
%     if abs(f0_gain_orig - 8.15) <= 0.17
%         fprintf('✓ Original gain meets specification (8.15 dB ± 0.17 dB)\n');
%     else
%         fprintf('✗ Original gain does not meet specification\n');
%     end
% end
% 
% % Compare gain difference
% if ~isempty(I_f0)
%     fprintf('\nGain comparison at f0:\n');
%     fprintf('- Optimized: %.2f dB\n', f0_gain);
%     fprintf('- Original:  %.2f dB\n', f0_gain_orig);
%     fprintf('- Difference: %.2f dB\n', abs(f0_gain - f0_gain_orig));
% end
% 
% % Plot comparison of S21
% figure(5);
% plot(freq / G, S21_Amp_dB, 'r', 'LineWidth', 2.5); hold on;
% plot(freq / G, S21_Amp_orig_dB, 'b--', 'LineWidth', 2.5);
% plot(fx / G, S21_Amp_dB(I_fx), 'ro', 'LineWidth', 4);
% plot(fx / G, S21_Amp_orig_dB(I_fx), 'bo', 'LineWidth', 4);
% yline(8.15, 'k--', 'LineWidth', 1.5);
% yline(8.15 + 0.17, 'k:', 'LineWidth', 1);
% yline(8.15 - 0.17, 'k:', 'LineWidth', 1);
% grid on; grid minor;
% xlabel('Frequency (GHz)');
% ylabel('|S_{21}| (dB)');
% title('Amplifier Gain Comparison');
% axis([f_min/G, f_max/G, 6, 9]);
% legend('Optimized', 'Original', 'Optimized Points', 'Original Points', 'Target (8.15 dB)', 'Tolerance Limits', 'Location', 'best');
% 
% % Plot comparison of S11
% figure(6);
% plot(freq / G, S11_Amp_dB, 'r', 'LineWidth', 2.5); hold on;
% plot(freq / G, S11_Amp_orig_dB, 'b--', 'LineWidth', 2.5);
% grid on; grid minor;
% xlabel('Frequency (GHz)');
% ylabel('|S_{11}| (dB)');
% title('Input Return Loss Comparison');
% axis([f_min/G, f_max/G, -25, 0]);
% legend('Optimized', 'Original', 'Location', 'best');
% 
% % Plot comparison of S22
% figure(7);
% plot(freq / G, S22_Amp_dB, 'r', 'LineWidth', 2.5); hold on;
% plot(freq / G, S22_Amp_orig_dB, 'b--', 'LineWidth', 2.5);
% grid on; grid minor;
% xlabel('Frequency (GHz)');
% ylabel('|S_{22}| (dB)');
% title('Output Return Loss Comparison');
% axis([f_min/G, f_max/G, -25, 0]);
% legend('Optimized', 'Original', 'Location', 'best');
% 
% % Performance summary
% fprintf('\n========== Performance Summary ==========\n');
% fprintf('Original implementation time: %.2f seconds\n', orig_implementation_time);
% fprintf('Optimized implementation time: %.2f seconds (IMN: %.2f s, OMN: %.2f s)\n', imn_time + omn_time, imn_time, omn_time);
% 
% % Check if the amplifier meets the criteria
% % Calculate gain stats in band (9-20 GHz)
% in_band = freq >= fL & freq <= fH;
% gain_in_band = S21_Amp_dB(in_band);
% min_gain = min(gain_in_band);
% max_gain = max(gain_in_band);
% avg_gain = mean(gain_in_band);
% gain_flatness = max_gain - min_gain;
% 
% fprintf('\nGain Statistics (9-20 GHz):\n');
% fprintf('- Minimum gain: %.2f dB\n', min_gain);
% fprintf('- Maximum gain: %.2f dB\n', max_gain);
% fprintf('- Average gain: %.2f dB\n', avg_gain);
% fprintf('- Gain flatness: %.2f dB\n', gain_flatness);
% 
% % Check if gain at f0 is within specifications
% if abs(S21_Amp_dB(I_fx(2)) - 8.15) <= 0.17
%     fprintf('\n✓ SUCCESS: Amplifier gain at f0 (%.2f dB) meets the specification (8.15 dB ± 0.17 dB)\n', S21_Amp_dB(I_fx(2)));
% else
%     fprintf('\n✗ FAILURE: Amplifier gain at f0 (%.2f dB) does not meet the specification (8.15 dB ± 0.17 dB)\n', S21_Amp_dB(I_fx(2)));
% end
% 
% fprintf('\nSimulation complete. Please check plots for amplifier performance.\n');
% end
% 

%% IMN OPTI
function [S_IMN, nt_IMN, best_components_IMN, Tholder_IMN] = dp3_IMN_gpu_Placzek_Optimized()

%% -------------------- Constants --------------------
G = 1e9; M = 1e6; K = 1e3;
m = 1e-3; u = 1e-6; n = 1e-9;
p = 1e-12; f = 1e-15;
NF = 32; Z0 = 50;

%% -------------------- Transistor Input Model --------------------
Li = 347.8189 * p;
Ci = 245.2104 * f;
Ri = 23.0767;

%% -------------------- Project Parameters --------------------
NE = 7;
NS_I_values = [1, 0]; % Try both sloped and non-sloped IL functions (sloped is primary for IMN)
IL_min_dB_I_values = [0.0, 0.05, 0.1]; % Try different IL min values
Ripple_I = 0.1; % Fixed as per design requirement
fL = 9*G;
fH = 20*G;
f0 = sqrt(fL*fH);
BW_f = fH - fL;
f_min = 8*G;
f_max = 22*G;
df = 25*M;

%------------------------------------------------------------------
w0 = 2*pi*f0;
wH = 2*pi*fH;
wL = 2*pi*fL;
BW_w = 2*pi*BW_f;
Delta = BW_f/f0;

%-------------------------------------------------------------------
freq = f_min:df:f_max;
fx = [fL, f0, fH];
freq = union(freq, fx);
freq = sort(freq);
I_fx = ismember(freq, fx);
N_Freq = length(freq);
w = 2 * pi * freq;

fprintf('Using GPU-accelerated optimization for IMN design...\n');

%% -------------------- Storage for Solutions --------------------
all_components = {};
all_performance = [];
all_nts = [];
all_description = {};

%% -------------------- Try different IL function parameters --------------------
for ns_idx = 1:length(NS_I_values)
    NS_I = NS_I_values(ns_idx);
    ns_desc = sprintf('NS_%d', NS_I);
    
    for il_idx = 1:length(IL_min_dB_I_values)
        IL_min_dB_I = IL_min_dB_I_values(il_idx);
        il_desc = sprintf('IL_%.2f', IL_min_dB_I);
        
        % Fixed ripple value as per design requirement
        rip_desc = sprintf('Rip_%.2f', Ripple_I);
        IL_max_dB_I = IL_min_dB_I + Ripple_I;
        
        full_desc = sprintf('%s_%s_%s', ns_desc, il_desc, rip_desc);
            fprintf('Trying IMN with %s\n', full_desc);
            
            % Generate IL function
            N_Poly = (1/2)*(NE-1);
            IL_max_I = 10^(IL_max_dB_I/10);
            IL_min_I = 10^(IL_min_dB_I/10);
            k0_I = IL_min_I;
            kT_I = IL_max_I - k0_I;
            
            % Generate polynomials
            [IL_num, IL_den, R2_num, R2_den] = EE456_IL_Function_f0(fL, fH, k0_I, kT_I, N_Poly, NS_I);
            
            % Find poles and zeros
            sz2 = roots(R2_num); sz = sz2(real(sz2) < 0);
            sp2 = roots(R2_den); sp = sp2(real(sp2) < 0);
            
            % Generate impedance function
            R_Sign = 1;
            [Z_num, Z_den, R_num, R_den] = EE456_Z_Function(sz, sp, R_Sign);
            
            %% -------------------- Call the GPU Optimized Solution Finder --------------------
            [Parts, Parts_ID, Parts_unad, R_values] = Find_All_Solns_wt_Transformer_gpu_Placzek(...
                Z_num, Z_den, NE, Z0, Ri, w0, w0, R_Sign);
            
            n_solutions = size(Parts, 2);
            fprintf('Found %d potential solutions\n', n_solutions);
            
            %% -------------------- Evaluate each solution --------------------
            if ~isempty(Parts)
                for sol_idx = 1:n_solutions
                    % Extract component values
                    components = Parts(:, sol_idx);
                    component_types = Parts_ID(:, sol_idx);
                    R_term = R_values(sol_idx);
                    
                    % Calculate transformer turns ratio
                    nt_candidate = sqrt(Z0/R_term);
                    
                    % Skip if transformer ratio is unreasonable
                    if nt_candidate > 5 || nt_candidate < 0.2
                        continue;
                    end
                    
                    % Convert to actual components with transistor integration
                    [final_components, component_order] = convert_to_final_components(components, component_types, Ci, Li);
                    
                    % Evaluate S-parameters
                    S_params = evaluate_network_performance(final_components, component_order, freq, Ri, Z0);
                    
                    % Calculate performance metrics at key frequencies
                    perf_metrics = calculate_performance_metrics(S_params, I_fx);
                    
                    % Store this solution
                    all_components{end+1} = final_components;
                    all_performance(end+1,:) = perf_metrics;
                    all_nts(end+1) = nt_candidate;
                    all_description{end+1} = sprintf('%s_sol%d', full_desc, sol_idx);
                    
                    % Progress display for long runs
                    if mod(sol_idx, 100) == 0
                        fprintf('Evaluated %d/%d solutions for %s\n', sol_idx, n_solutions, full_desc);
                    end
                end
            end
        end
    end
end

%% -------------------- Select the best solution --------------------
if ~isempty(all_performance)
    % Define weights for different metrics (adjust as needed)
    weights = [0.6, 0.3, 0.1]; % [S21_slope, S11_at_band, S11_worst]
    
    % Calculate weighted scores
    weighted_scores = all_performance * weights';
    
    % Find the best solution
    [best_score, best_idx] = max(weighted_scores);
    
    best_components_OMN = all_components{best_idx};
    nt_OMN = all_nts(best_idx);
    best_description = all_description{best_idx};
    
    % Extract components for further use
    [Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7] = deal(best_components_OMN{:});
    store_Post_transform_and_Transitor = [Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7];
    
    %% -------------------- Display Best Results --------------------
    fprintf('\n========== Best IMN Component Values (%s, Score: %.4f) ==========\n', best_description, best_score);
    fprintf('Ci1 = %.4f fF\n', Ci1 * 1e15);
    fprintf('Li2 = %.4f pH\n', Li2 * 1e12);
    fprintf('Li3 = %.4f pH\n', Li3 * 1e12);
    fprintf('Ci4 = %.4f fF\n', Ci4 * 1e15);
    fprintf('Ci5 = %.4f fF\n', Ci5 * 1e15);
    fprintf('Ci6 = %.4f fF\n', Ci6 * 1e15);
    fprintf('Li7 = %.4f pH\n', Li7 * 1e12);
    fprintf('Transformer ratio nt = %.4f\n', nt_OMN);
    fprintf('========================================\n\n');

    %% -------------------- Calculate ABCD matrices and S-parameters for best solution --------------------
    S_XMN = zeros(N_Freq, 2, 2);
    Tholder_OMN = zeros(N_Freq, 2, 2);

    for kk = 1:N_Freq
        fk = freq(kk);
        sk = 1i * 2 * pi * fk;
        Zp1 = Ri + (1 / (Ci * sk)) + Li * sk;

        T1 = EE456_ABCD_Series_C(Ci1, fk);
        T2 = EE456_ABCD_Series_L(Li2, fk);
        T3 = EE456_ABCD_Shunt_L(Li3, fk);
        T4 = EE456_ABCD_Shunt_C(Ci4, fk);
        T5 = EE456_ABCD_Series_C(Ci5, fk);
        T6 = EE456_ABCD_Shunt_C(Ci6, fk);
        T7 = EE456_ABCD_Shunt_L(Li7, fk);

        T = T1 * T2 * T3 * T4 * T5 * T6 * T7;
        S_XMN(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
        Tholder_OMN(kk, :, :) = T;
    end

    %% -------------------- Plot S-Parameters --------------------
    S11_dB = 20 * log10(abs(S_XMN(:, 1, 1)));
    S21_dB = 20 * log10(abs(S_XMN(:, 2, 1)));
    S11_fx_dB = S11_dB(I_fx);
    S21_fx_dB = S21_dB(I_fx);

    IFigure = 100;

    figure(IFigure + 1);
    plot(freq / G, S21_dB, 'r', 'LineWidth', 2.5); hold on;
    plot(fx / G, S21_fx_dB, 'ro', 'LineWidth', 4);
    grid on; grid minor;
    xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{21}| (dB)');
    title('{\itS}_{21} Optimized IMN'); xlim([f_min, f_max] / G);
    set(gca, 'FontSize', NF, 'LineWidth', 1.5);

    figure(IFigure + 2);
    plot(freq / G, S11_dB, 'b', 'LineWidth', 2.5); hold on;
    plot(fx / G, S11_fx_dB, 'bo', 'LineWidth', 4);
    grid on; grid minor;
    xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{11}| (dB)');
    title('{\itS}_{11} Optimized IMN'); xlim([f_min, f_max] / G);
    set(gca, 'FontSize', NF, 'LineWidth', 1.5);
else
    fprintf('No valid solutions found. Try different IL function parameters.\n');
    S_XMN = [];
    nt_OMN = [];
    best_components_OMN = [];
    Tholder_OMN = [];
end

% end

%% -------------------- Helper Functions --------------------
function [final_components, component_order] = convert_to_final_components_IMN(components, component_types, Ci, Li)
    % This function converts the abstract component values to actual values with transistor integration
    % It returns the final component values in the correct order for the IMN
    
    % For the IMN, we assume a topology based on the original IMN design:
    % Series C - Series L - Shunt L - Shunt C - Series C - Shunt C - Shunt L
    
    % For demonstration, we'll use a fixed topology and adjust values
    Ci1 = ((1/components(1)) - (1/Ci))^-1; % Series C (adjusted for Ci)
    Li2 = components(2) - Li;              % Series L (adjusted for Li)
    Li3 = components(3);                   % Shunt L
    Ci4 = components(4);                   % Shunt C
    Ci5 = components(5);                   % Series C
    Ci6 = components(6);                   % Shunt C
    Li7 = components(7);                   % Shunt L
    
    final_components = {Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7};
    component_order = {'Series C', 'Series L', 'Shunt L', 'Shunt C', 'Series C', 'Shunt C', 'Shunt L'};
end

function S_params = evaluate_network_performance_IMN(components, component_order, freq, Ri, Z0)
    % This function evaluates the S-parameters of the network at all frequencies
    
    [Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7] = deal(components{:});
    
    N_Freq = length(freq);
    S_params = zeros(N_Freq, 2, 2);
    
    for kk = 1:N_Freq
        fk = freq(kk);
        sk = 1i * 2 * pi * fk;
        Zp1 = Ri + (1 / (Ci * sk)) + Li * sk;

        T1 = EE456_ABCD_Series_C(Ci1, fk);
        T2 = EE456_ABCD_Series_L(Li2, fk);
        T3 = EE456_ABCD_Shunt_L(Li3, fk);
        T4 = EE456_ABCD_Shunt_C(Ci4, fk);
        T5 = EE456_ABCD_Series_C(Ci5, fk);
        T6 = EE456_ABCD_Shunt_C(Ci6, fk);
        T7 = EE456_ABCD_Shunt_L(Li7, fk);

        T = T1 * T2 * T3 * T4 * T5 * T6 * T7;
        S_params(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
    end
end

function metrics = calculate_performance_metrics_IMN(S_params, I_fx)
    % Calculate performance metrics for the network
    
    % Extract S-parameters
    S11 = squeeze(S_params(:, 1, 1));
    S21 = squeeze(S_params(:, 2, 1));
    
    % Calculate S-parameters in dB
    S11_dB = 20 * log10(abs(S11));
    S21_dB = 20 * log10(abs(S21));
    
    % Calculate metrics at key frequencies
    S21_fx = S21_dB(I_fx);
    S11_fx = S11_dB(I_fx);
    
    % Calculate slope of S21 (for IMN we want a sloped response)
    % Higher slope is better for IMN
    S21_slope = S21_fx(1) - S21_fx(3);  % Difference between fL and fH
    S21_slope_metric = S21_slope / 6.0;  % Normalize to typical 6dB/octave
    
    % Calculate average S11 at key frequencies (lower is better)
    S11_avg = -mean(S11_fx);  % Negative because lower S11 is better
    
    % Calculate S11 worst case
    S11_worst = -min(S11_fx);  % Negative because lower S11 is better
    
    % Return metrics
    metrics = [S21_slope_metric, S11_avg, S11_worst];
    fprintf('Li2 = %.4f');
end



%% OMN OPTI


function [S_XMN, nt, best_components, fx, Tholder] = dp3_OMN_gpu_Placzek_Opt()

%% -------------------- Constants --------------------
G = 1e9; M = 1e6; K = 1e3;
m = 1e-3; u = 1e-6; n = 1e-9;
p = 1e-12; f = 1e-15;
NF = 32; Z0 = 50;

%% -------------------- Transistor Output Model --------------------
Ro = 44.0222;
Co = 283.0342*f;
Lo = 202.0340*p;

%% -------------------- Project Parameters --------------------
NE = 7;
NS_values = [0, 1]; % Try both non-sloped and sloped IL functions
IL_min_dB_values = [0.1, 0.2, 0.05]; % Try different IL min values
Ripple = 0.1; % Fixed as per design requirement
fL = 9*G;
fH = 20*G;
f0 = sqrt(fL*fH);
BW_f = fH - fL;
f_min = 8*G;
f_max = 22*G;
df = 25*M;

% Frequency setup
w0 = 2*pi*f0;
wH = 2*pi*fH;
wL = 2*pi*fL;
BW_w = 2*pi*BW_f;
Delta = BW_f/f0;

freq = f_min:df:f_max;
fx = [fL, f0, fH];
freq = union(freq, fx);
freq = sort(freq);
I_fx = ismember(freq, fx);
N_Freq = length(freq);
w = 2 * pi * freq;

fprintf('Using GPU-accelerated optimization for OMN design...\n');

%% -------------------- Storage for Solutions --------------------
all_components = {};
all_performance = [];
all_nts = [];

%% -------------------- Try different IL function parameters --------------------
for ns_idx = 1:length(NS_values)
    NS = NS_values(ns_idx);
    
    for il_idx = 1:length(IL_min_dB_values)
        IL_min_dB = IL_min_dB_values(il_idx);
        
        % Fixed ripple value as per design requirement
        IL_max_dB = IL_min_dB + Ripple;
        
        fprintf('Trying OMN with NS=%d, IL_min_dB=%.2f, Ripple=%.2f\n', NS, IL_min_dB, Ripple);
            
            % Generate IL function
            N_Poly = (1/2)*(NE-1);
            IL_max = 10^(IL_max_dB/10);
            IL_min = 10^(IL_min_dB/10);
            k0 = IL_min;
            kT = IL_max - k0;
            
            % Generate polynomials
            [IL_num, IL_den, R2_num, R2_den] = EE456_IL_Function_f0(fL, fH, k0, kT, N_Poly, NS);
            
            % Find poles and zeros
            sz2 = roots(R2_num); sz = sz2(real(sz2) < 0);
            sp2 = roots(R2_den); sp = sp2(real(sp2) < 0);
            
            % Generate impedance function
            R_Sign = 1;
            [Z_num, Z_den, R_num, R_den] = EE456_Z_Function(sz, sp, R_Sign);
            
            %% -------------------- Call the GPU Optimized Solution Finder --------------------
            [Parts, Parts_ID, Parts_unad, R_values] = Find_All_Solns_wt_Transformer_gpu_Placzek(...
                Z_num, Z_den, NE, Z0, Ro, w0, w0, R_Sign);
            
            fprintf('Found %d potential solutions\n', size(Parts, 2));
            
            %% -------------------- Evaluate each solution --------------------
            if ~isempty(Parts)
                for sol_idx = 1:size(Parts, 2)
                    % Extract component values
                    components = Parts(:, sol_idx);
                    component_types = Parts_ID(:, sol_idx);
                    R_term = R_values(sol_idx);
                    
                    % Calculate transformer turns ratio
                    nt_candidate = sqrt(Z0/R_term);
                    
                    % Skip if transformer ratio is unreasonable
                    if nt_candidate > 5 || nt_candidate < 0.2
                        continue;
                    end
                    
                    % Convert to actual components with transistor integration
                    [final_components, component_order] = convert_to_final_components(components, component_types, Co, Lo);
                    
                    % Evaluate S-parameters
                    S_params = evaluate_network_performance(final_components, component_order, freq, Ro, Z0);
                    
                    % Calculate performance metrics at key frequencies
                    perf_metrics = calculate_performance_metrics(S_params, I_fx);
                    
                    % Store this solution
                    all_components{end+1} = final_components;
                    all_performance(end+1,:) = perf_metrics;
                    all_nts(end+1) = nt_candidate;
                end
            end
        end
    end
end

%% -------------------- Select the best solution --------------------
if ~isempty(all_performance)
    % Define weights for different metrics (adjust as needed)
    weights = [0.5, 0.3, 0.2]; % [S21_flatness, S11_at_band, S22_at_band]
    
    % Calculate weighted scores
    weighted_scores = all_performance * weights';
    
    % Find the best solution
    [~, best_idx] = max(weighted_scores);
    
    best_components_OMN = all_components{best_idx};
    nt_OMN = all_nts(best_idx);
    
    % Recalculate S-parameters for the best solution
    [Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7] = deal(best_components_OMN{:});
    store_Post_transform_and_Transitor = [Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7];
    
    %% -------------------- Display Best Results --------------------
    fprintf('\n========== Best OMN Component Values ==========\n');
    fprintf('Co1 = %.4f fF\n', Co1 * 1e15);
    fprintf('Lo2 = %.4f pH\n', Lo2 * 1e12);
    fprintf('Co3 = %.4f fF\n', Co3 * 1e15);
    fprintf('Lo4 = %.4f pH\n', Lo4 * 1e12);
    fprintf('Lo5 = %.4f pH\n', Lo5 * 1e12);
    fprintf('Lo6 = %.4f pH\n', Lo6 * 1e12);
    fprintf('Co7 = %.4f fF\n', Co7 * 1e15);
    fprintf('Transformer ratio nt = %.4f\n', nt_OMN);
    fprintf('========================================\n\n');

    %% -------------------- Calculate ABCD matrices and S-parameters for best solution --------------------
    S_XMN = zeros(N_Freq, 2, 2);
    Tholder_OMN = zeros(N_Freq, 2, 2);

    for kk = 1:N_Freq
        fk = freq(kk);
        Zp1 = Ro + (1 / (1i * 2*pi*fk * Co)) + 1i * 2*pi*fk * Lo;

        T1 = EE456_ABCD_Series_C(Co1, fk);
        T2 = EE456_ABCD_Series_L(Lo2, fk);
        T3 = EE456_ABCD_Shunt_C(Co3, fk);
        T4 = EE456_ABCD_Series_L(Lo4, fk);
        T5 = EE456_ABCD_Shunt_L(Lo5, fk);
        T6 = EE456_ABCD_Series_L(Lo6, fk);
        T7 = EE456_ABCD_Series_C(Co7, fk);

        T = T1 * T2 * T3 * T4 * T5 * T6 * T7;
        S_XMN(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
        Tholder_OMN(kk, :, :) = T;
    end

    %% -------------------- Plot S-Parameters --------------------
    S11_dB = 20 * log10(abs(S_XMN(:, 1, 1)));
    S21_dB = 20 * log10(abs(S_XMN(:, 2, 1)));
    S11_fx_dB = S11_dB(I_fx);
    S21_fx_dB = S21_dB(I_fx);

    IFigure = 200;

    figure(IFigure + 1);
    plot(freq / G, S21_dB, 'r', 'LineWidth', 2.5); hold on;
    plot(fx / G, S21_fx_dB, 'ro', 'LineWidth', 4);
    grid on; grid minor;
    xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{21}| (dB)');
    title('{\itS}_{21} Optimized OMN'); xlim([f_min, f_max] / G);
    set(gca, 'FontSize', NF, 'LineWidth', 1.5);

    figure(IFigure + 2);
    plot(freq / G, S11_dB, 'b', 'LineWidth', 2.5); hold on;
    plot(fx / G, S11_fx_dB, 'bo', 'LineWidth', 4);
    grid on; grid minor;
    xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{11}| (dB)');
    title('{\itS}_{11} Optimized OMN'); xlim([f_min, f_max] / G);
    set(gca, 'FontSize', NF, 'LineWidth', 1.5);
else
    fprintf('No valid solutions found. Try different IL function parameters.\n');
    S_XMN = [];
    nt_OMN = [];
    best_components_OMN = [];
    Tholder_OMN = [];
end

% end

%% -------------------- Helper Functions --------------------
function [final_components, component_order] = convert_to_final_components_OMN(components, component_types, Co, Lo)
    % This function converts the abstract component values to actual values with transistor integration
    % It returns the final component values in the correct order for the OMN

    % Map component types to actual components based on IDs
    % 11: Series C, 12: Shunt C, 13: Series L, 14: Shunt L

    % For this OMN example, we assume a specific topology:
    % Series C - Series L - Shunt C - Series L - Shunt L - Series L - Series C

    % This is a simplified version - in practice, you would create a topology
    % based on the component_types array

    % For demonstration, we'll use a fixed topology and adjust values
    Co1 = ((1/components(1)) - (1/Co))^-1; % Series C (adjusted for Co)
    Lo2 = components(2) - Lo;              % Series L (adjusted for Lo)
    Co3 = components(3);                   % Shunt C
    Lo4 = components(4);                   % Series L
    Lo5 = components(5);                   % Shunt L
    Lo6 = components(6);                   % Series L
    Co7 = components(7);                   % Series C

    final_components = {Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7};
    component_order = {'Series C', 'Series L', 'Shunt C', 'Series L', 'Shunt L', 'Series L', 'Series C'};
end

function S_params = evaluate_network_performance_OMN(components, component_order, freq, Ro, Z0)
    % This function evaluates the S-parameters of the network at all frequencies

    [Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7] = deal(components{:});

    N_Freq = length(freq);
    S_params = zeros(N_Freq, 2, 2);

    for kk = 1:N_Freq
        fk = freq(kk);
        Zp1 = Ro + (1 / (1i * 2*pi*fk * Co)) + 1i * 2*pi*fk * Lo;

        T1 = EE456_ABCD_Series_C(Co1, fk);
        T2 = EE456_ABCD_Series_L(Lo2, fk);
        T3 = EE456_ABCD_Shunt_C(Co3, fk);
        T4 = EE456_ABCD_Series_L(Lo4, fk);
        T5 = EE456_ABCD_Shunt_L(Lo5, fk);
        T6 = EE456_ABCD_Series_L(Lo6, fk);
        T7 = EE456_ABCD_Series_C(Co7, fk);

        T = T1 * T2 * T3 * T4 * T5 * T6 * T7;
        S_params(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
    end
end

function metrics = calculate_performance_metrics_OMN(S_params, I_fx)
    % Calculate performance metrics for the network

    % Extract S-parameters
    S11 = squeeze(S_params(:, 1, 1));
    S21 = squeeze(S_params(:, 2, 1));

    % Calculate S-parameters in dB
    S11_dB = 20 * log10(abs(S11));
    S21_dB = 20 * log10(abs(S21));

    % Calculate metrics at key frequencies
    S21_fx = S21_dB(I_fx);
    S11_fx = S11_dB(I_fx);

    % Calculate flatness of S21 (inverse of standard deviation)
    S21_flatness = 1 / (1 + std(S21_fx));

    % Calculate average S11 at key frequencies (lower is better)
    S11_avg = -mean(S11_fx); % Negative because lower S11 is better

    % Calculate S11 worst case
    S11_worst = -min(S11_fx); % Negative because lower S11 is better

    % Return metrics
    metrics = [S21_flatness, S11_avg, S11_worst];
end


