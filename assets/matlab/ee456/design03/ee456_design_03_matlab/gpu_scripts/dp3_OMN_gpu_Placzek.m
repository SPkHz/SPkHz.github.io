function [S_XMN, nt, best_components, fx, Tholder] = dp3_OMN_gpu_Placzek()

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
NS_values = 0; % Try both non-sloped and sloped IL functions
IL_min_dB_values = 0.0;
IL_max_dB_value = 0.2; % Try different IL min values
Ripple = 0.1;
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
        
        for rip_idx = 1:length(Ripple)
            Ripple = Ripple(rip_idx);
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
    
    best_components = all_components{best_idx};
    nt = all_nts(best_idx);
    
    % Recalculate S-parameters for the best solution
    [Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7] = deal(best_components{:});
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
    fprintf('Transformer ratio nt = %.4f\n', nt);
    fprintf('========================================\n\n');

    %% -------------------- Calculate ABCD matrices and S-parameters for best solution --------------------
    S_XMN = zeros(N_Freq, 2, 2);
    Tholder = zeros(N_Freq, 2, 2);

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
        Tholder(kk, :, :) = T;
    end

    %% -------------------- Plot S-Parameters --------------------
    S11_dB = 20 * log10(abs(S_XMN(:, 1, 1)));
    S21_dB = 20 * log10(abs(S_XMN(:, 2, 1)));
    S11_fx_dB = S11_dB(I_fx);
    S21_fx_dB = S21_dB(I_fx);

    IFigure = 200;

    % figure(IFigure + 1);
    figure(1)
    plot(freq / G, S21_dB, 'r', 'LineWidth', 2.5); hold on;
    plot(fx / G, S21_fx_dB, 'ro', 'LineWidth', 4);
    grid on; grid minor;
    xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{21}| (dB)');
    title('{\itS}_{21} Optimized OMN'); xlim([f_min, f_max] / G);
    set(gca, 'FontSize', NF, 'LineWidth', 1.5);

    % figure(IFigure + 2);
    figure(2)
    plot(freq / G, S11_dB, 'b', 'LineWidth', 2.5); hold on;
    plot(fx / G, S11_fx_dB, 'bo', 'LineWidth', 4);
    grid on; grid minor;
    xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{11}| (dB)');
    title('{\itS}_{11} Optimized OMN'); xlim([f_min, f_max] / G);
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
function [final_components, component_order] = convert_to_final_components(components, component_types, Co, Lo)
    % This function converts the abstract component values to actual values with transistor integration
    % It returns the final component values in the correct order for the OMN

    % Map component types to actual components based on IDs
    % 11: Series C, 12: Shunt C, 13: Series L, 14: Shunt L
    
    % For this OMN example, we assume a specific topology:
    % Series C - Series L - Shunt C - Series L - Shunt L - Series L - Series C
    
    % This is a simplified version - in practice, you would create a topology
    % based on the component_types array
    
    % For demonstration, we'll use a fixed topology and adjust values
    Co1 = ((1/components(1)) - (1/Co)).^-1; % Series C (adjusted for Co)
    Lo2 = components(2) - Lo;              % Series L (adjusted for Lo)
    Co3 = components(3);                   % Shunt C
    Lo4 = components(4);                   % Series L
    Lo5 = components(5);                   % Shunt L
    Lo6 = components(6);                   % Series L
    Co7 = components(7);                   % Series C
    
    final_components = {Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7};
    component_order = {'Series C', 'Series L', 'Shunt C', 'Series L', 'Shunt L', 'Series L', 'Series C'};
    component_types = {'Series C', 'Series L', 'Shunt C', 'Series L', 'Shunt L', 'Series L', 'Series C'};
end

function S_params = evaluate_network_performance(components, component_order, freq, Ro, Z0)
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

function metrics = calculate_performance_metrics(S_params, I_fx)
    % Calculate performance metrics for the network
    % Extract component values for penalty
    target_ranges = {
        [100*f, 400*f],   % Co1: C1 Series (fF)
        [500*p, 800*p],   % Lo2: L2 Series (pH)
        [200*f, 350*f],   % Co3: C4 Shunt (fF)
        [400*p, 600*p],   % Lo4: L3 Shunt (pH)
        [400*p, 600*p],   % Lo5: (pH)
        [400*p, 600*p],   % Lo6: (pH)
        [10*f, 30*f]      % Co7: C6 Series (fF)
    };
    
    penalty = 0;
    for i = 1:length(components)
        val = components{i};
        range = target_ranges{i};
        if val < range(1)
            penalty = penalty + (range(1) - val) / range(1);
        elseif val > range(2)
            penalty = penalty + (val - range(2)) / range(2);
        end
    end

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
    
    %  S11 at key frequencies (lower is better)
    S11_avg = -mean(S11_fx); % negative because lower S11 is better
    
    % Calculate S11 worst case
    S11_worst = -min(S11_fx); % Negative because lower S11 is better
    
    % Return metrics
    metrics = [S21_flatness, S11_avg, S11_worst];
end
