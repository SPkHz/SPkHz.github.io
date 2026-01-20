function [S_XMN, nt, best_components, Tholder] = dp3_IMN_gpu_Placzek_Optimized()

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
    
    best_components = all_components{best_idx};
    nt = all_nts(best_idx);
    best_description = all_description{best_idx};
    
    % Extract components for further use
    [Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7] = deal(best_components{:});
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
    fprintf('Transformer ratio nt = %.4f\n', nt);
    fprintf('========================================\n\n');

    %% -------------------- Calculate ABCD matrices and S-parameters for best solution --------------------
    S_XMN = zeros(N_Freq, 2, 2);
    Tholder = zeros(N_Freq, 2, 2);

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
        Tholder(kk, :, :) = T;
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
    nt = [];
    best_components = [];
    Tholder = [];
end

end

%% -------------------- Helper Functions --------------------
function [final_components, component_order] = convert_to_final_components(components, component_types, Ci, Li)
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

function S_params = evaluate_network_performance(components, component_order, freq, Ri, Z0)
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

function metrics = calculate_performance_metrics(S_params, I_fx)
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
end fF\n', Ci1 * 1e15);
    fprintf('Li2 = %.4f');
    
