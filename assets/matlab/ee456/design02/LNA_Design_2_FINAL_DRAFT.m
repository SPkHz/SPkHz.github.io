%% Initialize Environment and Check GPU Availability

clear; clc; close all;

%% Define Constants (SI Prefixes)

Y = 10^24;
Z = 10^21;
E = 10^18;
P = 10^15;
T = 10^12;
G = 10^9;
M = 10^6;
k = 10^3;
m = 10^-3;
u = 10^-6;
n = 10^-9;
p = 10^-12;
f = 10^-15;
a = 10^-18;
z = 10^-21;
y = 10^-24;

j = 1j;

% Check for GPU availability
hasGPU = (gpuDeviceCount > 0);
if hasGPU
    gpu = gpuDevice();
    fprintf('GPU available: %s with %.2f GB memory\n', gpu.Name, gpu.AvailableMemory/1e9);
    
    % Set optimization flags for best GPU performance
    feature('jit', 1);            % Enable Just-In-Time compilation
    feature('accel', 'on');       % Enable dynamic scheduling
    maxNumCompThreads('automatic'); % Enable multithreading
    
    % Warm up the GPU to avoid initial delay
    a = gpuArray(rand(1000));
    b = gpuArray(rand(1000));
    c = a * b;
    wait(gpuDevice);
    clear a b c
    fprintf('GPU warmed up and ready.\n');
    
    % Use hardware acceleration for plots
    set(0, 'DefaultFigureRenderer', 'opengl');
else
    fprintf('No GPU available. Using CPU only.\n');
end

%% Define Fudge Factor Range with GPU Optimization

if hasGPU
    Fudge_Factor = gpuArray(linspace(0, 1, 10000));
else
    Fudge_Factor = linspace(0, 1, 10000);
end

%% Design Parameters

VDS = 2;
IDS = 10 * m;
f0 = 15 * G;

%% Load S-Parameter Data

[freq, S, Mult] = Read_SParam_s2p_MacOS('MGF4941AL.s2p');
freq = freq * Mult;
I_f0 = ismember(freq, f0);

S11 = S(:,1,1); S21 = S(:,2,1);
S12 = S(:,1,2); S22 = S(:,2,2);

S11_dB = 20 * log10(abs(S11));
S21_dB = 20 * log10(abs(S21));
S12_dB = 20 * log10(abs(S12));
S22_dB = 20 * log10(abs(S22));

%% Extract S-Parameters at f0

S11 = S11(I_f0); S21 = S21(I_f0);
S12 = S12(I_f0); S22 = S22(I_f0);

S_f0 = [S11, S12; S21, S22];
S_all = S;  % backup full frequency S
S = S_f0;

% Move core S-parameters to GPU if available
if hasGPU
    S11_gpu = gpuArray(S11);
    S12_gpu = gpuArray(S12);
    S21_gpu = gpuArray(S21);
    S22_gpu = gpuArray(S22);
else
    S11_gpu = S11;
    S12_gpu = S12;
    S21_gpu = S21;
    S22_gpu = S22;
end

%% Noise and Gain Targets

GT_min_dB = 12;
GT_min = 10^(GT_min_dB / 10);

F_min_dB = 0.4450;
F_min = 10^(F_min_dB / 10);
F_Max_dB = 0.6;
F_Max = 10^(F_Max_dB / 10);

Gamma_OPT = Polar_2_Rect(0.324, -165.15);  % OPT Gamma from data
rn = 0.0760;

if hasGPU
    F_min_gpu = gpuArray(F_min);
    Gamma_OPT_gpu = gpuArray(Gamma_OPT);
    rn_gpu = gpuArray(rn);
end

%% Adjusted Specs for Near Max Targets

if hasGPU
    Fudgy = gpuArray(linspace(0.8, 0.9999999, 1000000));
else
    Fudgy = linspace(0.8, 0.9999999, 1000000);
end

VSWR_OMN_Max_Spec = 1.425;
VSWR_IMN_Max_Spec = 1.485;

VSWR_Slack = 0.975;  % 0.5% slack margin (~1.4925 max allowed)
VSWR_OMN_Near_Spec = VSWR_OMN_Max_Spec * VSWR_Slack;
VSWR_IMN_Near_Spec = VSWR_IMN_Max_Spec * VSWR_Slack;

F_Max_Near_Spec = F_Max * (1.1950 / 1.2);

%% Stability and Small-Signal Parameters

% Start timer to measure speedup
tic;

if hasGPU
    fprintf('Computing stability parameters with GPU acceleration...\n');
    [Delta, Delta_Mag, k, u_in, u_out] = stability_parameters_gpu(S11_gpu, S12_gpu, S21_gpu, S22_gpu);
    Delta = gather(Delta);
    Delta_Mag = gather(Delta_Mag);
    k = gather(k);
    u_in = gather(u_in);
    u_out = gather(u_out);
else
    [Delta, Delta_Mag, k, u_in, u_out] = stability_parameters(S11, S12, S21, S22);
end
Print_Polar("Delta", Delta);

Power_Gain = abs(S21).^2;
Power_Gain_dB = 10 * log10(Power_Gain);

if hasGPU
    [B1_gpu, C1_gpu, Gamma_MS, Gamma_S, B2, C2, Gamma_ML, Gamma_L, MAG, MAG_dB, ...
     GT, GT_dB, Gamma_in, Gamma_out, Gamma_IMN_Mag, VSWR_IMN, ...
     ML_IMN, ML_IMN_dB, Gamma_OMN_Mag, VSWR_OMN, ML_OMN, ...
     ML_OMN_dB] = calculate_all_parameters_gpu(S11_gpu, S12_gpu, S21_gpu, S22_gpu);
     
    % Gather results back from GPU
    B1 = gather(B1_gpu); C1 = gather(C1_gpu); Gamma_MS = gather(Gamma_MS); 
    Gamma_S = gather(Gamma_S); B2 = gather(B2); C2 = gather(C2);
    Gamma_ML = gather(Gamma_ML); Gamma_L = gather(Gamma_L);
    MAG = gather(MAG); MAG_dB = gather(MAG_dB); GT = gather(GT);
    GT_dB = gather(GT_dB); Gamma_in = gather(Gamma_in);
    Gamma_out = gather(Gamma_out); Gamma_IMN_Mag = gather(Gamma_IMN_Mag);
    VSWR_IMN = gather(VSWR_IMN); ML_IMN = gather(ML_IMN);
    ML_IMN_dB = gather(ML_IMN_dB); Gamma_OMN_Mag = gather(Gamma_OMN_Mag);
    VSWR_OMN = gather(VSWR_OMN); ML_OMN = gather(ML_OMN);
    ML_OMN_dB = gather(ML_OMN_dB);
    S11_fromGpu = gather(S11_gpu);
    S21_fromGpu = gather(S21_gpu);
    S12_fromGpu = gather(S12_gpu);
    S22_fromGpu = gather(S22_gpu);
    S_fromGpu = [S12_fromGpu, S12_fromGpu;...
        S21_fromGpu, S22_fromGpu];
else
    [B1, C1, Gamma_MS, Gamma_S, B2, C2, Gamma_ML, Gamma_L, MAG, MAG_dB, ...
     GT, GT_dB, Gamma_in, Gamma_out, Gamma_IMN_Mag, VSWR_IMN, ...
     ML_IMN, ML_IMN_dB, Gamma_OMN_Mag, VSWR_OMN, ML_OMN, ...
     ML_OMN_dB] = calculate_all_parameters(S11, S12, S21, S22);
end

if hasGPU
    [F_dB_MAG, F_MAG] = NoiseFinder_gpu(gpuArray(Gamma_S), gpuArray(Gamma_OPT), gpuArray(F_min_dB), gpuArray(rn));
    F_dB_MAG = gather(F_dB_MAG);
    F_MAG = gather(F_MAG);
else
    [F_dB_MAG, F_MAG] = NoiseFinder(Gamma_S, Gamma_OPT, F_min_dB, rn);
end

%% Display Parameters - MAG Design

Print_Title('MAG Design');
Print_Polar('S11', S11);
Print_Polar('S12', S12);
Print_Polar('S21', S21);
Print_Polar('S22', S22);
Print_Polar('Gamma_S', Gamma_S);
Print_Polar('Gamma_L', Gamma_L);
Print_Polar('Gamma_in', Gamma_in);
Print_Polar('Gamma_out', Gamma_out);
Print_Real('Gamma_IMN_Mag', Gamma_IMN_Mag);
Print_Real('Gamma_IMN_Mag_dB', 20 * log10(Gamma_IMN_Mag));
Print_Real('VSWR_IMN', VSWR_IMN);
Print_Real('Gamma_OMN_Mag', Gamma_OMN_Mag);
Print_Real('Gamma_OMN_Mag_dB', 20 * log10(Gamma_OMN_Mag));
Print_Real('VSWR_OMN', VSWR_OMN);
Print_Real_Unit('GT', GT, 'W/W');
Print_Real_Unit('GT_dB', GT_dB, 'dB');
Print_Real('F_dB_MAG', F_dB_MAG, 'dB');

%% Fmin Design Parameters

if hasGPU
    [B1_fmin, C1_fmin, Gamma_MS_fmin, Gamma_S_fmin, B2_fmin, C2_fmin, ...
     Gamma_ML_fmin, Gamma_L_fmin, MAG_fmin, MAG_dB_fmin, GT_fmin, ...
     GT_dB_fmin, Gamma_in_fmin, Gamma_out_fmin, Gamma_IMN_Mag_fmin, ...
     VSWR_IMN_fmin, ML_IMN_fmin, ML_IMN_dB_fmin, Gamma_OMN_Mag_fmin, ...
     VSWR_OMN_fmin, ML_OMN_fmin, ML_OMN_dB_fmin] = calculate_all_parameters_fmin_gpu(...
        S11_gpu, S12_gpu, S21_gpu, S22_gpu, gpuArray(Gamma_OPT));
    
    % Gather results back from GPU
    B1_fmin = gather(B1_fmin); C1_fmin = gather(C1_fmin); 
    Gamma_MS_fmin = gather(Gamma_MS_fmin); Gamma_S_fmin = gather(Gamma_S_fmin);
    B2_fmin = gather(B2_fmin); C2_fmin = gather(C2_fmin);
    Gamma_ML_fmin = gather(Gamma_ML_fmin); Gamma_L_fmin = gather(Gamma_L_fmin);
    MAG_fmin = gather(MAG_fmin); MAG_dB_fmin = gather(MAG_dB_fmin);
    GT_fmin = gather(GT_fmin); GT_dB_fmin = gather(GT_dB_fmin);
    Gamma_in_fmin = gather(Gamma_in_fmin); Gamma_out_fmin = gather(Gamma_out_fmin);
    Gamma_IMN_Mag_fmin = gather(Gamma_IMN_Mag_fmin); VSWR_IMN_fmin = gather(VSWR_IMN_fmin);
    ML_IMN_fmin = gather(ML_IMN_fmin); ML_IMN_dB_fmin = gather(ML_IMN_dB_fmin);
    Gamma_OMN_Mag_fmin = gather(Gamma_OMN_Mag_fmin); VSWR_OMN_fmin = gather(VSWR_OMN_fmin);
    ML_OMN_fmin = gather(ML_OMN_fmin); ML_OMN_dB_fmin = gather(ML_OMN_dB_fmin);
else
    [B1_fmin, C1_fmin, Gamma_MS_fmin, Gamma_S_fmin, B2_fmin, C2_fmin, ...
     Gamma_ML_fmin, Gamma_L_fmin, MAG_fmin, MAG_dB_fmin, GT_fmin, ...
     GT_dB_fmin, Gamma_in_fmin, Gamma_out_fmin, Gamma_IMN_Mag_fmin, ...
     VSWR_IMN_fmin, ML_IMN_fmin, ML_IMN_dB_fmin, Gamma_OMN_Mag_fmin, ...
     VSWR_OMN_fmin, ML_OMN_fmin, ML_OMN_dB_fmin] = calculate_all_parameters_fmin(S, Gamma_OPT);
end

Print_Title('Fmin Design');
% Find index of Gamma_S_fmin
[min_Gamma_S_fmin_value, min_Gamma_S_fmin_idx] = min(Gamma_S_fmin);

% Print just that value
fprintf('Gamma_S_fmin: Gamma_S_fmin(%d) = %.4f\n', min_Gamma_S_fmin_idx, min_Gamma_S_fmin_value);

Print_Polar('Gamma_L_fmin', Gamma_L_fmin);
Print_Polar('Gamma_in_fmin', Gamma_in_fmin);
Print_Polar('Gamma_out_fmin', Gamma_out_fmin);
Print_Real('Gamma_IMN_Mag_fmin', Gamma_IMN_Mag_fmin);
Print_Real('Gamma_IMN_Mag_dB_fmin', 20 * log10(Gamma_IMN_Mag_fmin));
Print_Real('VSWR_IMN_fmin', VSWR_IMN_fmin);
Print_Real('Gamma_OMN_Mag_fmin', Gamma_OMN_Mag_fmin);
Print_Real('Gamma_OMN_Mag_dB_fmin', 20 * log10(Gamma_OMN_Mag_fmin));
Print_Real('VSWR_OMN_fmin', VSWR_OMN_fmin);
Print_Real_Unit('GT_dB_fmin', GT_dB_fmin, 'dB');
Print_Real('F_dB_fmin', F_min_dB, 'dB');

% Find index satisfying all specs in parallel if GPU available
if hasGPU
    valid_conditions = (GT_dB_fmin >= 12) & ...
                       (F_min_dB <= 0.6) & ...
                       (VSWR_IMN_fmin <= 1.5) & ...
                       (VSWR_OMN_fmin <= 1.5);
    valid_idx = find(valid_conditions);
else
    valid_idx = find( ...
        GT_dB_fmin >= 12 & ...
        F_min_dB <= 0.6 & ...
        VSWR_IMN_fmin <= 1.5 & ...
        VSWR_OMN_fmin <= 1.5 ...
    );
end

if isempty(valid_idx)
    fprintf('No single index meets all Fmin design specs.\n');
else
    % Choose one with highest gain
    [~, best_valid_idx] = max(GT_dB_fmin(valid_idx));
    i = valid_idx(best_valid_idx);
    fprintf('Best all-spec Fmin design at index %d:\n', i);
    fprintf('  GT_dB_fmin = %.2f dB\n', GT_dB_fmin(i));
    fprintf('  F_dB_fmin = %.3f dB (static)\n', F_min_dB);
    fprintf('  VSWR_IMN_fmin = %.2f\n', VSWR_IMN_fmin(i));
    fprintf('  VSWR_OMN_fmin = %.2f\n', VSWR_OMN_fmin(i));
end


%% Design 1 - Optimized for Gain and Noise Figure
% Use GPU for intensive vector operations

% fprintf('Computing Design 1 with %s...\n', hasGPU, 'GPU acceleration' : 'CPU');

if hasGPU
    Gamma_MS_fmin_gpu = gpuArray(Gamma_MS_fmin);
    Gamma_OPT_gpu = gpuArray(Gamma_OPT);
    Fudge_Factor_gpu = gpuArray(Fudge_Factor);
    
    % Gamma_S_New = Gamma_OPT_gpu + (Fudge_Factor_gpu .* (Gamma_MS_fmin_gpu - Gamma_OPT_gpu));
    Gamma_S_New = Gamma_OPT + (Fudge_Factor .* (Gamma_MS_fmin - Gamma_OPT));
    Gamma_S_New = arrayfun(@(g) g / max(1, abs(g)), Gamma_S_New);  % Ensure |Gamma| ≤ 1
    
    [F_Design_1_dB, F_Design_1] = NoiseFinder_gpu(Gamma_S_New, Gamma_OPT_gpu, gpuArray(F_min_dB), gpuArray(rn));
    
    [B1_Design_1, C1_Design_1, Gamma_MS_Design_1, Gamma_S_Design_1, ...
     B2_Design_1, C2_Design_1, Gamma_ML_Design_1, Gamma_L_Design_1, ...
     MAG_Design_1, MAG_dB_Design_1, GT_Design_1, GT_dB_Design_1, ...
     Gamma_in_Design_1, Gamma_out_Design_1, Gamma_IMN_Mag_Design_1, ...
     VSWR_IMN_Design_1, ML_IMN_Design_1, ML_IGamma_outMN_dB_Design_1, ...
     Gamma_OMN_Mag_Design_1, VSWR_OMN_Design_1, ML_OMN_Design_1, ...
     ML_OMN_dB_Design_1] = calculate_all_parameters_fmin_gpu(S11_gpu, S12_gpu, S21_gpu, S22_gpu, Gamma_S_New);
    
    % Move data to CPU for processing
    F_Design_1 = gather(F_Design_1);
    F_Design_1_dB = gather(F_Design_1_dB);
    Gamma_S_New = gather(Gamma_S_New);
    GT_Design_1 = gather(GT_Design_1);
    GT_dB_Design_1 = gather(GT_dB_Design_1);
    VSWR_IMN_Design_1 = gather(VSWR_IMN_Design_1);
    VSWR_OMN_Design_1 = gather(VSWR_OMN_Design_1);
    Gamma_IMN_Mag_Design_1 = gather(Gamma_IMN_Mag_Design_1);
    Gamma_OMN_Mag_Design_1 = gather(Gamma_OMN_Mag_Design_1);
else
    Gamma_S_New = Gamma_OPT + (Fudge_Factor .* (Gamma_MS_fmin - Gamma_OPT));

    [F_Design_1_dB, F_Design_1] = NoiseFinder(Gamma_S_New, Gamma_OPT, F_min_dB, rn);

    [B1_Design_1, C1_Design_1, Gamma_MS_Design_1, Gamma_S_Design_1, ...
     B2_Design_1, C2_Design_1, Gamma_ML_Design_1, Gamma_L_Design_1, ...
     MAG_Design_1, MAG_dB_Design_1, GT_Design_1, GT_dB_Design_1, ...
     Gamma_in_Design_1, Gamma_out_Design_1, Gamma_IMN_Mag_Design_1, ...
     VSWR_IMN_Design_1, ML_IMN_Design_1, ML_IGamma_outMN_dB_Design_1, ...
     Gamma_OMN_Mag_Design_1, VSWR_OMN_Design_1, ML_OMN_Design_1, ...
     ML_OMN_dB_Design_1] = calculate_all_parameters_fmin(S, Gamma_S_New);
end

VC = Find_Closest_Value(F_Design_1, F_Max_Near_Spec);
I = find(F_Design_1 == VC);
Fudge_Factor = Fudge_Factor(I(1));  % just in case

if hasGPU
    Gamma_S_Design_1_best = gather(Gamma_OPT_gpu + Fudge_Factor .* (Gamma_MS_fmin_gpu - Gamma_OPT_gpu));
else
    Gamma_S_Design_1_best = Gamma_OPT + Fudge_Factor .* (Gamma_MS_fmin - Gamma_OPT);
end

if hasGPU
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, GT_Design_1, GT_dB_Design_1, ...
     ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = ... 
        calculate_all_parameters_fmin_gpu(S11_gpu, S12_gpu, S21_gpu, S22_gpu, gpuArray(Gamma_S_Design_1_best));
    
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, GT_Design_1, GT_dB_Design_1, ...
     ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = ...
        calculate_all_parameters_fmin_gpu(S11_gpu, S12_gpu, S21_gpu, S22_gpu, gpuArray(Gamma_S_New));
        
    GT_Design_1 = gather(GT_Design_1);
    GT_dB_Design_1 = gather(GT_dB_Design_1);
else
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, GT_Design_1, GT_dB_Design_1, ...
     ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = ... 
        calculate_all_parameters_fmin(S, Gamma_S_Design_1);

    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, GT_Design_1, GT_dB_Design_1, ...
     ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = ...
        calculate_all_parameters_fmin(S, Gamma_S_New);
end

% Constraint thresholds
GT_dB_Target = 12;             % min gain
F_dB_Target = 0.6;             % max noise figure
VSWR_Max = 1.5;

% Find valid indices - run on GPU if available for large arrays
if hasGPU
    valid_conditions = (GT_dB_Design_1 >= GT_dB_Target) & ...
                       (F_Design_1_dB <= F_Max_Near_Spec) & ...
                       (VSWR_IMN_Design_1 <= VSWR_IMN_Near_Spec) & ...
                       (VSWR_OMN_Design_1 <= VSWR_OMN_Near_Spec);
    valid_idx = find(gather(valid_conditions));
else
    valid_idx = find( ...
        GT_dB_Design_1 >= GT_dB_Target & ...
        F_Design_1_dB <= F_Max_Near_Spec & ...
        VSWR_IMN_Design_1 <= VSWR_IMN_Near_Spec & ...
        VSWR_OMN_Design_1 <= VSWR_OMN_Near_Spec ...
    );
end

%% Display - Design 1

Print_Title('Design 1');

if isempty(valid_idx)
    fprintf('No valid design meets all specs ')
else
    [~, best_i] = max(GT_dB_Design_1(valid_idx));
    i = valid_idx(best_i);
    fprintf('\n Best Valid Design Found (Index %d):\n', i);
    
    % Reflection coefficients
    % [mag, ang] = cart2pol(real(Gamma_S_Design_1(i)), imag(Gamma_S_Design_1(i)));
    % fprintf('Gamma_S_MAT = (%.4f < %.4f°)\n', mag, rad2deg(ang));
    Gamma_S_temp_unnorm = Gamma_S_Design_1(i);
    Gamma_S_temp = Gamma_S_temp_unnorm ./ max(1, abs(Gamma_S_temp_unnorm));
    mag = abs(Gamma_S_temp);
    ang = angle(Gamma_S_temp);  % In radians
    fprintf('Gamma_S_MAT = (%.4f < %.4f°)\n', mag, rad2deg(ang));

    fprintf('\nMGamma_IMN_Amp_db = %.4f dB\n', 20 .* log10(Gamma_IMN_Mag_Design_1(i)));
    fprintf('MGamma_IMN_Amp = %.4f\n', Gamma_IMN_Mag_Design_1(i));
    fprintf('VSWR_IMN_Amp = %.4f\n', VSWR_IMN_Design_1(i));
    
    fprintf('\nMGamma_OMN_Amp_db = %.4f dB\n', 20 * log10(Gamma_OMN_Mag_Design_1(i)));
    fprintf('MGamma_OMN_Amp = %.4f\n', Gamma_OMN_Mag_Design_1(i));
    fprintf('VSWR_OMN_Amp = %.4f\n', VSWR_OMN_Design_1(i));
    
    fprintf('\nGTdb_Amp = %.4f dB\n', GT_dB_Design_1(i));
    fprintf('GT_Amp = %.4f W/W\n', GT_Design_1(i));
    
    fprintf('\nF Amp MAT = %.4f dB\n', F_Design_1_dB(i));
end

%% Design 2
Print_Title('Noise Gain Circles - Design 2');

if hasGPU
    % Run calculations on GPU
    F_Design_1_gpu = gpuArray(F_Design_1);
    F_min_gpu = gpuArray(F_min);
    rn_gpu = gpuArray(rn);
    Gamma_OPT_gpu = gpuArray(Gamma_OPT);
    
    Ni = ((F_Design_1_gpu - F_min_gpu) ./ (4 * rn_gpu)) .* abs(1 + Gamma_OPT_gpu).^2;
    Rfi_Design_2 = (1 ./ (1 + Ni)) .* sqrt(Ni.^2 + Ni .* (1 - abs(Gamma_OPT_gpu).^2));
    Cfi = Gamma_OPT_gpu ./ (1 + Ni);
    
    % Gather results back to CPU
    Ni = gather(Ni);
    Rfi_Design_2 = gather(Rfi_Design_2);
    Cfi = gather(Cfi);
else
    Ni = ((F_Design_1 - F_min) ./ (4 * rn)) .* abs(1 + Gamma_OPT).^2;
    Rfi_Design_2 = (1 ./ (1 + Ni)) .* sqrt(Ni.^2 + Ni .* (1 - abs(Gamma_OPT).^2));
    Cfi = Gamma_OPT ./ (1 + Ni);
end

% Print_Polar("Cfi_Design_2", Cfi);
% Print_Real("Rfi_Design_2", Rfi_Design_2);

if hasGPU
    Ga = gpuArray(10.^(GT_dB_Design_1 ./ 10));
    S12_gpu = gpuArray(S12);
    S21_gpu = gpuArray(S21);
    k_gpu = gpuArray(k);
    Delta_gpu = gpuArray(Delta);
    S11_gpu = gpuArray(S11);
    
    ga = Ga ./ abs(S21_gpu).^2;
    
    inroot = 1 - 2 * k_gpu * abs(S12_gpu .* S21_gpu) .* ga + (abs(S12_gpu .* S21_gpu).^2) .* (ga.^2);
    raTop = sqrt(complex(inroot));
    raBot = 1 + ga .* (abs(S11_gpu).^2 - abs(Delta_gpu).^2);
    ra = raTop ./ abs(raBot);
    
    C1_gpu = gpuArray(C1);
    Ca = (ga .* conj(C1_gpu)) ./ raBot;
    
    % Gather results
    ra = gather(ra);
    Ca = gather(Ca);
    Ga = gather(Ga);
    ga = gather(ga);
else
    Ga = 10.^(GT_dB_Design_1 ./ 10);
    ga = Ga ./ abs(S21).^2;
    
    inroot = 1 - 2 * k * abs(S12 .* S21) .* ga + (abs(S12 .* S21).^2) .* (ga.^2);
    raTop = sqrt(inroot);
    raBot = 1 + ga .* (abs(S11).^2 - abs(Delta).^2);
    ra = raTop ./ abs(raBot);
    
    Ca = (ga .* conj(C1)) ./ raBot;
end

Gamma_S_Design_2_unnorm = Gamma_S_Design_1;
Gamma_S_Design_2 = Gamma_S_Design_2_unnorm ./ max(1, abs(Gamma_S_Design_2_unnorm));
% Print_Polar('Gamma_S_Design_2(3785)', Gamma_S_Design_2);

%% Initial Calculation for Output Matching Network

device_str = {'CPU', 'GPU'};
fprintf('Running Initial Output Matching for Design 2 using %s...\n', device_str{hasGPU+1});

if hasGPU
    Gamma_S_Design_2_gpu_unnorm = gpuArray(Gamma_S_Design_2);
    Gamma_S_Design_2_gpu = Gamma_S_Design_2_gpu_unnorm ./ max(1, abs(Gamma_S_Design_2_gpu_unnorm));
    S11_gpu = gpuArray(S11);
    S12_gpu = gpuArray(S12);
    S21_gpu = gpuArray(S21);
    S22_gpu = gpuArray(S22);

    Gamma_out_Design_2_gpu = S22_gpu + (S12_gpu .* S21_gpu .* Gamma_S_Design_2_gpu) ./ ...
                         (1 - S11_gpu .* Gamma_S_Design_2_gpu);
    
    Gamma_OMN_ABS_Design_2_gpu = gpuArray((VSWR_OMN_Near_Spec - 1) ./ (VSWR_OMN_Near_Spec + 1));
    
    rvo_gpu = Gamma_OMN_ABS_Design_2_gpu .* (1 - abs(Gamma_out_Design_2_gpu).^2) ./ ...
          (1 - abs(Gamma_OMN_ABS_Design_2_gpu .* Gamma_out_Design_2_gpu).^2);
    
    Cvo_gpu = conj(Gamma_out_Design_2_gpu) .* (1 - abs(Gamma_OMN_ABS_Design_2_gpu).^2) ./ ...
          (1 - abs(Gamma_OMN_ABS_Design_2_gpu .* Gamma_out_Design_2_gpu).^2);
    
    ML_OMN_Design_2_gpu = 1 - abs(Gamma_OMN_ABS_Design_2_gpu).^2;
    
    % Move data back to CPU for compatibility with non-GPU function
    rvo = gather(rvo_gpu); 
    Cvo = gather(Cvo_gpu); 
    Gamma_out_Design_2 = gather(Gamma_out_Design_2_gpu);
    Gamma_OMN_ABS_Design_2 = gather(Gamma_OMN_ABS_Design_2_gpu);
    ML_OMN_Design_2 = gather(ML_OMN_Design_2_gpu);
    Gamma_S_Design_2_fromGPU_unnorm = gather(Gamma_S_Design_2_gpu);

    % Gather S-parameters if needed for later CPU calculations
    S11 = gather(S11_gpu);
    S12 = gather(S12_gpu);
    S21 = gather(S21_gpu);
    S22 = gather(S22_gpu);
    
else
    Gamma_out_Design_2_cpu = S22 + (S12 .* S21 .* Gamma_S_Design_2) ./ ...
                         (1 - S11 .* Gamma_S_Design_2);

    Gamma_OMN_ABS_Design_2_cpu = (VSWR_OMN_Near_Spec - 1) ./ (VSWR_OMN_Near_Spec + 1);

    rvo_cpu = Gamma_OMN_ABS_Design_2_cpu .* (1 - abs(Gamma_out_Design_2_cpu).^2) ./ ...
          (1 - abs(Gamma_OMN_ABS_Design_2_cpu .* Gamma_out_Design_2_cpu).^2);

    Cvo_cpu = conj(Gamma_out_Design_2_cpu) .* (1 - abs(Gamma_OMN_ABS_Design_2_cpu).^2) ./ ...
          (1 - abs(Gamma_OMN_ABS_Design_2_cpu .* Gamma_out_Design_2_cpu).^2);

    ML_OMN_Design_2_cpu = 1 - abs(Gamma_OMN_ABS_Design_2_cpu).^2;
end

% Gamma Points still CPU-based
% Gamma_S_Design_2_fromGPU = Gamma_S_Design_2_fromGPU_unnorm ./ max(1, abs(Gamma_S_Design_2_fromGPU_unnorm));
Gamma_S_Design_2_fromGPU = conformal_normalize(Gamma_S_Design_2_fromGPU_unnorm);

[Gamma_L_Pn_Design_2, ~, ~, ~, ~] = Gamma_Points_finder(Gamma_ML, rvo, Cvo);
Gamma_L_Pn_Design_2 = Gamma_L_Pn_Design_2 ./ max(1, abs(Gamma_L_Pn_Design_2));

Gamma_L_Pn_Design_2_unnorm = Gamma_L_Pn_Design_2(3);
Gamma_L_Pn_Design_2 = Gamma_L_Pn_Design_2_unnorm ./ max(1, abs(Gamma_L_Pn_Design_2_unnorm));

Gamma_in_Design_2 = S11 + (S12 .* S21 .* Gamma_L_Pn_Design_2) ./ ...
                    (1 - S22 .* Gamma_L_Pn_Design_2);

Gamma_IMN_Mag_Design_2 = abs((Gamma_in_Design_2 - conj(Gamma_S_Design_2_fromGPU)) ./ ...
                             (1 - Gamma_in_Design_2 .* Gamma_S_Design_2_fromGPU));

VSWR_IMN_Design_2 = (1 + abs(Gamma_IMN_Mag_Design_2)) ./ ...
                    (1 - abs(Gamma_IMN_Mag_Design_2));

Gamma_OMN_Mag_Design_2 = abs((Gamma_out_Design_2 - conj(Gamma_L_Pn_Design_2)) ./ ...
                             (1 - Gamma_out_Design_2 .* Gamma_L_Pn_Design_2));

%% Batch Optimization
Print_Title('Batch Optimization - Design 2');

if hasGPU
    Top = gpuArray(4 .* VSWR_OMN_Near_Spec);
    Bot = gpuArray((VSWR_OMN_Near_Spec + 1).^2);
    ML_OMN_dB = -10 .* log10(Top ./ Bot);

    GT_dB_Design_2 = 10 .* log10(Ga) - ML_OMN_dB;
    GP = 10.^(GT_dB_Design_2 ./ 10);
    gp = GP ./ abs(S21).^2;

    C2 = gpuArray(S22 - Delta .* conj(S11));
    inroot = 1 - 2 .* k .* abs(S12 .* S21) .* gp + (abs(S12 .* S21).^2) .* gp.^2;
    raTop = sqrt(inroot);
    raBot = 1 + gp .* (abs(S22).^2 - abs(Delta).^2);
    rp = raTop ./ abs(raBot);
    Cp = (gp .* conj(C2)) ./ abs(raBot);

    rvo = Gamma_OMN_ABS_Design_2 .* (1 - abs(Gamma_out_Design_2).^2) ./ ...
          (1 - abs(Gamma_OMN_ABS_Design_2 .* Gamma_out_Design_2).^2);
    Cvo = conj(Gamma_out_Design_2) .* (1 - abs(Gamma_OMN_ABS_Design_2).^2) ./ ...
          (1 - abs(Gamma_OMN_ABS_Design_2 .* Gamma_out_Design_2).^2);

    rvo = gather(rvo);
    Cvo = gather(Cvo);
    GT_dB_Design_2 = gather(GT_dB_Design_2);
end

% Gamma Points still on CPU
[Gamma_L_Pn_Design_2_all, ~, ~, ~, ~] = Gamma_Points_finder(Gamma_ML, rvo, Cvo);
% Gamma_L_Pn_Design_2_all = Gamma_L_Pn_Design_2_all_unnorm ./ max(1, abs(Gamma_L_Pn_Design_2_all_unnorm));
% Gamma_L_P3_X_Cpu = Gamma_L_P3_X;
% % Print_Polar('Gamma_L_P3_X_Cpu', Gamma_L_P3_X_Cpu);

Gamma_L_Pn_Design_2_all = Gamma_L_Pn_Design_2_all(3,:);

Gamma_in_Design_2_all = S11 + (S12 .* S21 .* Gamma_L_Pn_Design_2_all) ./ ...
                        (1 - S22 .* Gamma_L_Pn_Design_2_all);
Gamma_IMN_Mag_Design_2_all = abs((Gamma_in_Design_2_all - conj(Gamma_S_Design_2_fromGPU)) ./ ...
                                 (1 - Gamma_in_Design_2_all .* Gamma_S_Design_2_fromGPU));
VSWR_IMN_Design_2_all = (1 + Gamma_IMN_Mag_Design_2_all) ./ ...
                        (1 - Gamma_IMN_Mag_Design_2_all);

valid_idx = find( ...
    (GT_dB_Design_2 >= GT_min_dB) & ...
    (F_Design_1_dB <= F_Max_dB) & ...
    (VSWR_IMN_Design_2_all <= VSWR_IMN_Max_Spec) & ...
    (VSWR_OMN_Near_Spec <= VSWR_OMN_Max_Spec) ...
);

if isempty(valid_idx)
    error('No valid Design 2 candidates meet all specifications.');
end

[~, best_idx] = max(GT_dB_Design_2(valid_idx));
I = valid_idx(best_idx);

Fudgy = Fudgy(I);
% GT_dB_Design_2_Selected = GT_dB_Design_2_Selected(I);
Gamma_L_Pn_Design_2_unnorm = Gamma_L_Pn_Design_2_all(I);
Gamma_L_Pn_Design_2 = Gamma_L_Pn_Design_2_unnorm ./ max(1, abs(Gamma_L_Pn_Design_2_unnorm));


Gamma_in_Design_2 = S11 + (S12 .* S21 .* Gamma_L_Pn_Design_2) ./ ...
                    (1 - S22 .* Gamma_L_Pn_Design_2);
Gamma_IMN_Mag_Design_2 = abs((Gamma_in_Design_2 - conj(Gamma_S_Design_2_fromGPU)) ./ ...
                             (1 - Gamma_in_Design_2 .* Gamma_S_Design_2_fromGPU));
VSWR_IMN_Design_2 = (1 + Gamma_IMN_Mag_Design_2) ./ ...
                    (1 - Gamma_IMN_Mag_Design_2);
Gamma_OMN_Mag_Design_2 = abs((Gamma_out_Design_2 - conj(Gamma_L_Pn_Design_2)) ./ ...
                             (1 - Gamma_out_Design_2 .* Gamma_L_Pn_Design_2));


%% Final Design 2 Recalculation

assert(isscalar(Fudgy), 'Fudgy is not scalar as expected.');
Fudgy_Selected = Fudgy;
I = valid_idx(best_idx);
GT_dB_Design_2_Selected = GT_dB_Design_2(I);

VSWR_OMN_Near_Spec = VSWR_OMN_Max_Spec .* Fudgy_Selected;
VSWR_IMN_Near_Spec = VSWR_IMN_Max_Spec .* Fudgy_Selected;

% GT_dB_Design_2_Selected = GT_dB_Design_2_Selected;

Gamma_out_Design_2 = S22 + (S12 .* S21 .* Gamma_S_Design_2_fromGPU) ./ (1 - S11 .* Gamma_S_Design_2_fromGPU);

Top = 4 .* VSWR_OMN_Near_Spec;
Bot = (VSWR_OMN_Near_Spec + 1).^2;
ML_OMN_dB = -10 * log10(Top ./ Bot);
GT_dB_Design_2_Selected = 10 * log10(Ga) - ML_OMN_dB;

GP = 10.^(GT_dB_Design_2_Selected ./ 10);
gp = GP ./ abs(S21).^2;
C2 = S22 - Delta .* conj(S11);

inroot = 1 - 2 * k * abs(S12 .* S21) .* gp + (abs(S12 .* S21).^2) .* gp.^2;
raTop = sqrt(inroot);
raBot = 1 + gp .* (abs(S22).^2 - abs(Delta).^2);
rp = raTop ./ abs(raBot);
Cp = (gp .* conj(C2)) ./ abs(raBot);

rvo = Gamma_OMN_ABS_Design_2 .* (1 - abs(Gamma_out_Design_2).^2) ./ ...
      (1 - abs(Gamma_OMN_ABS_Design_2 .* Gamma_out_Design_2).^2);

Cvo = conj(Gamma_out_Design_2) .* (1 - abs(Gamma_OMN_ABS_Design_2).^2) ./ ...
      (1 - abs(Gamma_OMN_ABS_Design_2 .* Gamma_out_Design_2).^2);

[Gamma_L_Pn_Design_2_unnorm, ~, ~, ~, Gamma_L_P3_Design_2] = ...
    Gamma_Points_finder(Gamma_ML, rvo, Cvo);

Gamma_L_Pn_Design_2_array = Gamma_L_Pn_Design_2_unnorm ./ max(1, abs(Gamma_L_Pn_Design_2_unnorm));
Gamma_L_Pn_Design_2 = Gamma_L_Pn_Design_2_array(3);

Gamma_in_Design_2 = ...
    S11 + (S12 .* S21 .* Gamma_L_Pn_Design_2) ./ ...
    (1 - S22 .* Gamma_L_Pn_Design_2);

Gamma_IMN_Mag_Design_2 = ...
    abs((Gamma_in_Design_2 - conj(Gamma_S_Design_2_fromGPU)) ...
    ./ (1 - Gamma_in_Design_2 .* Gamma_S_Design_2_fromGPU));

VSWR_IMN_Design_2 = ...
    (1 + abs(Gamma_IMN_Mag_Design_2)) ...
    ./ (1 - abs(Gamma_IMN_Mag_Design_2));

Gamma_OMN_Mag_Design_2 = ...
    abs((Gamma_out_Design_2 - conj(Gamma_L_Pn_Design_2)) ...
    ./ (1 - Gamma_out_Design_2 .* Gamma_L_Pn_Design_2));

%% Display Final Results - Design 2

Print_Title('Design 2');

% % % % Print_Polar('Gamma_S_Design_2', Gamma_S_Design_2);
% % % % Print_Polar('Gamma_L_Design_Pn_2', Gamma_L_Pn_Design_2);
% % % % Print_Polar('Gamma_L_Design_P3_2', Gamma_L_P3_Design_2);
% % % % Print_Polar('Gamma_in_Design_2', Gamma_in_Design_2);
% % % % Print_Polar('Gamma_out_Design_2', Gamma_out_Design_2);
% % % % 
% % % % Print_Real('Gamma_IMN_Mag_Design_2', Gamma_IMN_Mag_Design_2);
% % % % Print_Real('Gamma_IMN_Mag_dB_Design_2', 20.*log10(Gamma_IMN_Mag_Design_2));
% % % % Print_Real('VSWR_IMN_Design_2', VSWR_IMN_Design_2);
% % % % 
% % % % Print_Real('Gamma_OMN_Design_2', Gamma_OMN_Mag_Design_2);
% % % % Print_Real('Gamma_OMN_dB_Design_2', 20.*log10(Gamma_OMN_Mag_Design_2));
% % % % Print_Real('VSWR_OMN_Design_2', VSWR_OMN_Design_2);
% % % Print_Real_Unit('GT_dB_Design_2_Selected', GT_dB_Design_2_Selected, 'dB');
% % % 
% % % % [min_rfi_value1, min_rfi_idx1] = min(rfi_Design_1);
% % % % fprintf('Best RFI for Design 1: rfi_Design_1(%d) = %.4f\n', min_rfi_idx1, min_rfi_value1);
% % % 
% % % 
% % % % Find index of minimum RFI
% % % [min_rfi_value, min_rfi_idx] = min(Rfi_Design_2);
% % % 
% % % % Print just that value
% % % fprintf('Best RFI for Design 2: rfi_Design_2(%d) = %.4f\n', min_rfi_idx, min_rfi_value);
% % % % fprintf('Gamma_L_Design_2(%d) = (%.4f < %.4f°)\n', min_rfi_idx, abs(Gamma_L_Design_P3_2(min_rfi_idx)), angle(Gamma_L_Design_P3_2(min_rfi_idx)) * 180/pi);
% % % 
% % % 
% % % [F_Design_2_dB, ~] = ...
% % %     NoiseFinder(Gamma_S_Design_2, Gamma_OPT, F_min_dB, rn);
% % % % Print_Real('F_dB_Design_2', F_Design_2_dB, 'dB');
% Define spec thresholds
g = gpuDevice();
disp(['Used GPU Memory: ', num2str(g.FreeMemory / 1e9), ' GB free of ', num2str(g.TotalMemory / 1e9), ' GB'])

GT_dB_min = 12;
F_dB_max = 0.6;
VSWR_Max = 1.53675;
VSWR_OMN_Max_Near_Spec = VSWR_Max * VSWR_Slack;
VSWR_IMN_Max_Near_Spec = VSWR_Max .* VSWR_Slack;

Gamma_OMN_Mag_Design_2_all = abs((Gamma_out_Design_2 - conj(Gamma_L_Pn_Design_2_all)) ./ ...
                                 (1 - Gamma_out_Design_2 .* Gamma_L_Pn_Design_2_all));

VSWR_OMN_Design_2_all = (1 + Gamma_OMN_Mag_Design_2_all) ./ ...
                        (1 - Gamma_OMN_Mag_Design_2_all);

% Compute noise figure for Design 2
[F_Design_2_dB, ~] = NoiseFinder(Gamma_S_Design_2_fromGPU, Gamma_OPT, F_min_dB, rn);

% Find all valid solutions meeting spec
valid_idx = find( ...
    GT_dB_Design_2_Selected >= GT_dB_min & ...
    F_Design_2_dB <= F_dB_max & ...
    VSWR_IMN_Design_2_all <= VSWR_IMN_Max_Near_Spec & ...
    VSWR_OMN_Design_2_all <= VSWR_OMN_Max_Near_Spec ...
);

if isempty(valid_idx)
    fprintf('\n No solutions found that meet all Design 2 specs.\n');
else
    % Filter RFI to valid indices only
    RFI_valid = Rfi_Design_2(valid_idx);

    % Find index of min RFI within valid ones
    [min_rfi_value, min_rfi_sub_idx] = min(RFI_valid);
    best_idx = valid_idx(min_rfi_sub_idx);

    fprintf('\n Best Valid Design 2 Match (Index %d):\n', best_idx);
    fprintf('GT_dB = %.4f dB\n', GT_dB_Design_2_Selected(best_idx));
    fprintf('F_dB = %.4f dB\n', F_Design_2_dB(best_idx));
    fprintf('VSWR_IMN = %.4f\n', VSWR_IMN_Design_2_all(best_idx));
    fprintf('VSWR_OMN = %.4f\n', VSWR_OMN_Design_2_all(best_idx));
    fprintf('RFI = %.4f\n', Rfi_Design_2(best_idx));

    % Optional: print Gamma values
    Print_Polar('Gamma_S_Design_2_fromGPU', Gamma_S_Design_2_fromGPU(best_idx));
    % Gamma_S_Design_2_unnorm = Gamma_S_Design_2_fromGPU;
    % Gamma_S_Design_2_norm = Gamma_S_Design_2_unnorm ./ max(1, abs(Gamma_S_Design_2_unnorm));
    % [magS, angS] = cart2pol(real(Gamma_S_Design_2_norm(best_idx)), imag(Gamma_S_Design_2_norm(best_idx)));
    % fprintf('Gamma_S = (%.4f < %.2f°)\n', magS, rad2deg(angS));

    Print_Polar('Gamma_L_P3_Design_2', Gamma_L_P3_Design_2(best_idx));
    % Gamma_L_P3_Design_2_unnorm = Gamma_L_P3_Design_2;
    % Gamma_L_P3_Design_2_norm = Gamma_L_P3_Design_2_unnorm ./ max(1, abs(Gamma_L_P3_Design_2_unnorm));
    % [magL, angL] = cart2pol(real(Gamma_L_P3_Design_2_norm(best_idx)), imag(Gamma_L_P3_Design_2_norm(best_idx)));
    % fprintf('Gamma_L = (%.4f < %.2f°)\n', magL, rad2deg(angL));
    % 

end

fprintf('GT_dB passes: %d\n', sum(GT_dB_Design_2_Selected >= GT_dB_min));
fprintf('F_dB passes: %d\n', sum(F_Design_2_dB <= F_dB_max));
fprintf('VSWR_IMN passes: %d\n', sum(VSWR_IMN_Design_2_all <= VSWR_IMN_Max_Near_Spec));
fprintf('VSWR_OMN passes: %d\n', sum(VSWR_OMN_Design_2_all <= VSWR_OMN_Max_Near_Spec));

fprintf('Spec limits - GT ≥ %.2f dB, F ≤ %.2f dB, VSWR ≤ %.4f\n', ...
    GT_dB_min, F_dB_max, VSWR_IMN_Max_Near_Spec);

score = GT_dB_Design_2_Selected - ...
        10 * (F_Design_2_dB ./ F_dB_max).^2 - ...
        5 * (VSWR_IMN_Design_2_all ./ VSWR_IMN_Max_Near_Spec).^2 - ...
        5 * (VSWR_OMN_Design_2_all ./ VSWR_OMN_Max_Near_Spec).^2;

score_valid = score(valid_idx);
[~, best_idx_local] = max(score_valid);
best_idx = valid_idx(best_idx_local);

fprintf('--- Best Candidate Based on Score ---\n');
fprintf('Score = %.4f\n', score(best_idx));
fprintf('GT_dB = %.4f dB\n', GT_dB_Design_2_Selected(best_idx));
fprintf('F_dB = %.4f dB\n', F_Design_2_dB(best_idx));
fprintf('VSWR_IMN = %.4f\n', VSWR_IMN_Design_2_all(best_idx));
fprintf('VSWR_OMN = %.4f\n', VSWR_OMN_Design_2_all(best_idx));

%% Create rfckt.amplifier Object & Examine Amp Power Gains & Noise Figure

% clear; close all; clc;

Y = 10^+24;
Z = 10^+21;
E = 10^+18;
P = 10^+15;
T = 10^+12;
G = 10^+9;
M = 10^+6;
k = 10^+3;
m = 10^-3;
u = 10^-6;
n = 10^-9;
p = 10^-12;
f = 10^-15;
a = 10^-18;
z = 10^-21;
y = 10^-24;

j = 1j;
IFigure = 0;

%-------------------------------------------------------------------------

unmatched_amp = read(rfckt.amplifier, 'MGF4941AL.s2p');
analyze(unmatched_amp, 14e9:50e6:16e9);

IFigure = IFigure + 1;
figure_max(IFigure)
plot(unmatched_amp,'Gmag','Ga','Gt','dB')

%% Examine Gains at 15 GHz

IFigure = IFigure + 1;
figure_max(IFigure)
plot(unmatched_amp,'Fmin','NF','dB')
axis([14 16 0 4])
legend('Location','NorthWest')

% Unmatched_NF = 0.65234 dB
% Fmin = 0.4450 dB

%% Define Fudge Factor Range

Fudge_Factor = linspace(0, 1, 10000);

%% Design Parameters

VDS = 2;
IDS = 10 * m;
f0 = 15 * G;

%% Load S-Parameter Data

[freq, S, Mult] = Read_SParam_s2p('MGF4941AL.s2p');
freq = freq * Mult;
I_f0 = ismember(freq, f0);

S11 = S(:,1,1); S21 = S(:,2,1);
S12 = S(:,1,2); S22 = S(:,2,2);

S11_dB = 20 * log10(abs(S11));
S21_dB = 20 * log10(abs(S21));
S12_dB = 20 * log10(abs(S12));
S22_dB = 20 * log10(abs(S22));

%% Extract S-Parameters at f0

S11 = S11(I_f0); S21 = S21(I_f0);
S12 = S12(I_f0); S22 = S22(I_f0);

S_f0 = [S11, S12; S21, S22];
S_all = S;  % backup full frequency S
S = S_f0;

%% Noise and Gain Targets

GT_min_dB = 12;
GT_min = 10^(GT_min_dB / 10);

F_min_dB = 0.4450;
F_min = 10^(F_min_dB / 10);
F_Max_dB = 0.6;
F_Max = 10^(F_Max_dB / 10);

Gamma_OPT = Polar_2_Rect(0.324, -165.15);  % OPT Gamma from data
rn = 0.0760;
%% Plot Gain, Noise Figure, and Stability Circles

fc = 15e9;
IFigure = IFigure + 1;
figure_max(IFigure)
hsm = smithplot;
circle(unmatched_amp,fc,'Stab','In','Stab','Out','Ga',10:0.5:12.5, ...
    'NF',0.4450:0.01:0.5450,hsm);
legend('Location','SouthEast')
axis([-15 15 -15 15])

IFigure = IFigure + 1;
figure_max(IFigure)
hsm = smithplot;
circle(unmatched_amp, f0, 'Ga', 10:0.5:12.228, 'NF', 0.4450:0.01:0.5450, hsm);
title('Unmatched Amplifier: Gain & NF Circles at 15 GHz');


%% Stability and Small-Signal Parameters

[Delta, Delta_Mag, k, u_in, u_out] = stability_parameters_byram(S);
Print_Polar("Delta", Delta);

Power_Gain = abs(S21).^2;
Power_Gain_dB = 10 * log10(Power_Gain);

[B1, C1, Gamma_MS, Gamma_S, B2, C2, Gamma_ML, Gamma_L, MAG, MAG_dB, ...
 GT, GT_dB, Gamma_in, Gamma_out, Gamma_IMN_Mag, VSWR_IMN, ...
 ML_IMN, ML_IMN_dB, Gamma_OMN_Mag, VSWR_OMN, ML_OMN, ...
 ML_OMN_dB] = calculate_all_parameters(S);

[F_dB_MAG, F_MAG] = NoiseFinder(Gamma_S, Gamma_OPT, F_min_dB, rn);

%% Find GammaS

GammaS = Polar_2_Rect(0.4256, -136.0227);

%% Compute Normalized Source Impedance
Z0 = 50;

zs = gamma2z(GammaS,1);
ZS = zs*Z0;
Print_Rect('Normalized Source Impedance zs:', zs)
Print_Rect('Source Impedance, ZS:', ZS, 'Ohm')
%% Compute matching GammaL (complex conjugate of GammaOut)

GammaL = Polar_2_Rect(0.2904, +146.0865);

%% Compute normalized Load Impedance

zl = gamma2z(GammaL,1);
ZL = zl*Z0;
Print_Rect('Normalized Source Impedance zl:', zl)
Print_Rect('Source Impedance, ZL:', ZL, 'Ohm')
%% Computer IMN parameters 

GammaS = Polar_2_Rect(0.4256, -136.0227);

[line_len_In, stub_len_InStub, Zin] = match_to_gamma(GammaS, Z0, true);
d_in = line_len_In;
l_in = stub_len_InStub;

fprintf("IMN Series Line Length = %.4f λ (%.4f°)\n", line_len_In, line_len_In*360);
fprintf("IMN Shunt Stub Length = %.4f λ (%.4f°)\n", stub_len_InStub, stub_len_InStub*60);

line_in = rfckt.txline('Z0', Z0, 'LineLength', d_in, 'Freq', 14*G:f0/20:16*G);
stub_in = rfckt.txline('StubMode', 'Shunt', 'Z0', Z0, ...
                         'LineLength', l_in, 'Freq', 14*G:f0/20:16*G, ...
                         'Termination', 'Short');
%% Compute OMN Parameters

GammaL = Polar_2_Rect(0.2904, +146.0865);

[line_len_Out, stub_len_OutStub, Zout] = match_to_gamma(GammaL, 50, true);
d_out = line_len_Out;
l_out = stub_len_OutStub;

fprintf("OMN Series Line Length = %.4f λ (%.4f°)\n", line_len_Out, line_len_Out*360);
fprintf("OMN Shunt Stub Length = %.4f λ (%.4f°)\n", stub_len_OutStub, stub_len_OutStub*360);


line_out = rfckt.txline('Z0', Z0, 'LineLength', d_out, 'Freq', 14*G:f0/20:16*G);
stub_out = rfckt.txline('StubMode', 'Shunt', 'Z0', Z0, ...
                          'LineLength', l_out, 'Freq', 14*G:f0/20:16*G, ...
                          'Termination', 'Short');

%% messed-up code
% [d_line_in, length_line_in, d_stub_in, length_stub_in] = singlestub (Z0, zs, 'open');
% 
% fprintf("OMN Series Line Length = %.4f λ (%.2f°)\n", length_line_in, length_line_in*360);
% fprintf("OMN Shunt Stub Length = %.4f λ (%.2f°)\n", length_stub_in, length_stub_in*360);
% 
% line_in = rfckt.txline('Z0', Z0, 'LineLength', d_line_in, 'Freq', 14*G:f0/20:16*G);
% stub_in = rfckt.txline('StubMode', 'Shunt', 'Z0', Z0, ...
%                           'LineLength', d_stub_in, 'Freq', 14*G:f0/20:16*G, ...
%                           'Termination', 'Short');
% 
% [d_line_out, length_line_out, d_stub_out, length_stub_out] = singlestub(Z0, zl, 'open');
% 
% fprintf("OMN Series Line Length = %.4f λ (%.2f°)\n", length_line_out, length_line_out*360);
% fprintf("OMN Shunt Stub Length = %.4f λ (%.2f°)\n", length_stub_out, length_stub_out*360);
% 
% line_out = rfckt.txline('Z0', Z0, 'LineLength', d_line_out, 'Freq', 14*G:f0/20:16*G);
% stub_out = rfckt.txline('StubMode', 'Shunt', 'Z0', Z0, ...
%                           'LineLength', d_stub_out, 'Freq', 14*G:f0/20:16*G, ...
%                           'Termination', 'Short');

%% Compute Amp Params

amp = read(rfckt.amplifier, 'MGF4941AL.s2p');

freq_IMN = linspace(14*G, 16*G , 1*M);
IMN_net = rfckt.cascade('Ckts', {line_in, stub_in});
analyze(IMN_net, 14*G:50*M:16*G);
% nf_IMN = noisefigure(IMN_net, freq_IMN, zs);

freq_OMN = linspace(14*G, 16*G , 1*M);
OMN_net = rfckt.cascade('Ckts', {stub_out, line_out});
analyze(OMN_net, 14*G:50*M:16*G);
% nf_OMN = noisefigure(transmissionline, freq, zl);

freq_lna_net = 14*G:1*M:16*G;
lna_net = rfckt.cascade('ckts',{IMN_net, unmatched_amp, OMN_net});
analyze(lna_net, freq_lna_net);

% Plot S11, S22, Gain, etc.
IFigure = IFigure + 1;
figure_max(IFigure)
plot(lna_net, 'S11', 'dB');

% IFigure = IFigure + 1;
figure_max(IFigure)
plot(lna_net, 'S21', 'dB');

% IFigure = IFigure + 1;
figure_max(IFigure)
plot(lna_net, 'S22', 'dB');

% % % % VSWR
% % % IFigure = IFigure + 1;
% % % figure_max(IFigure)
% % % plot(lna_net, 'VSWR', 'In', 'Out');

% Smith chart
% IFigure = IFigure + 1;
% figure_max(IFigure)
% [S, freq_S] = extract(lna_net,'S_parameters');
% [~, f_idx] = min(abs(freq_S - f0));
% smithplot(squeeze(S(:,:,f_idx)));
% title(sprintf('Smith Chart at %.2f GHz', f0 / 1e9));


% % Smith chart two
% IFigure = IFigure + 1;
% figure_max(IFigure)
AllGammaL = gammaml(S);
AllGammaS = gammams(S);
hsm = smithplot(figure, [AllGammaL AllGammaS]);
title('GammaL and GammaS 14 to 16 GHz')
hsm.LegendLabels = {'#Gamma ML','#Gamma MS'};
 
% hsm = smithplot;
% circle(lna_net, f0, 'Ga', 10:0.5:12.226) %, 'NF', 0.4450:0.01:0.6, hsm);


%% Find GammaS and GammaL
%% Design 2 Print Statements

Print_Title('Design 2 Summary:')

Print_Polar('Gamma_S_Design_2', Gamma_S_Design_2_fromGPU(best_idx));

Print_Polar('Gamma_L_Design_2 (Point 3)', Gamma_L_P3_Design_2(best_idx));

Print_Polar('Gamma_In_Design_2', Gamma_in_Design_2);

Gamma_Out_Design_2 = Gamma_out_Design_2(best_idx);
Print_Polar('Gamma_Out_Design_2', Gamma_Out_Design_2);

Mag_Gamma_IMN_Design_2 = Gamma_IMN_Mag_Design_2(best_idx);
Print_Real('Mag_Gamma_IMN_Design_2', Mag_Gamma_IMN_Design_2);

Mag_Gamma_IMN_Design_2_dB = 20 .* log10(Mag_Gamma_IMN_Design_2);
Print_Real_Unit('Mag_Gamma_Design_2_IMN_dB', Mag_Gamma_IMN_Design_2_dB, 'dB');

VSWR_IMN_Design_2 = VSWR_IMN_Design_2_all(best_idx);
Print_Real('VSWR_IMN_Design_2', VSWR_IMN_Design_2);


Gamma_OMN_Mag_Design_2_all = abs((Gamma_out_Design_2 - conj(Gamma_L_Pn_Design_2_all)) ./ ...
                                 (1 - Gamma_out_Design_2 .* Gamma_L_Pn_Design_2_all));
Mag_Gamma_OMN_Design_2 = Gamma_OMN_Mag_Design_2_all(best_idx);
Print_Real('MGamma_OMN_Design_2', Mag_Gamma_OMN_Design_2);

Mag_Gamma_OMN_Design_2_dB = 20 .* log10(Gamma_OMN_Mag_Design_2_all(best_idx));
Print_Real('MGamma_Design_2_OMN_dB', Mag_Gamma_OMN_Design_2_dB, 'dB');

VSWR_OMN_Design_2 =  VSWR_OMN_Design_2_all(best_idx);
Print_Real('VSWR_OMN_Design_2', VSWR_OMN_Design_2);

GT_dB_Design_2 = GT_dB_Design_2_Selected(best_idx);
Print_Real_Unit('GT_dB_Design_2', GT_dB_Design_2, 'dB');

F_dB_Design_2 = F_Design_2_dB(best_idx);
Print_Real('F_dB_Design_2', F_dB_Design_2, 'dB');


% shunt_r = rfckt.shuntrlc('R',118);
% analyze(lna_net, fc);
% IFigure = IFigure + 1;
% figure_max(IFigure)
% hsm = smithplot;
% circle(lna_net,fc,'Ga',10:0.5:12.228,'NF',0.4450:0.01:0.6,hsm)
% legend('Location','SouthEast')
% 




% --------------------------------------------------------------------
%  MAG Design 
% --------------------------------------------------------------------
%  Delta = (0.3597 < +145.4747 deg
% 
%  S11 = (0.4350 < +113.6000 deg) 
%  S12 = (0.1210 < -14.6000 deg) 
%  S21 = (3.5140 < -21.3000 deg) 
%  S22 = (0.1520 < -157.0000 deg) 
% 
%  Gamma_S = (0.7088 < -114.5883 deg) 
%  Gamma_L = (0.5871 < +152.4980 deg) 
%  Gamma_in = (0.7088 < +114.5883 deg) 
%  Gamma_out = (0.5871 < -152.4980 deg) 
% 
%  Gamma_IMN_Mag = 0.0000 
%  Gamma_IMN_Mag_dB = -307.0086 
%  VSWR_IMN = 1.0000 
% 
%  Gamma_OMN_Mag = 0.0000 \
%  Gamma_OMN_Mag_dB = -307.4626 
%  VSWR_OMN = 1.0000 
% 
%  GT = 19.5936  W/W
%  GT_dB = 12.9211  dB
%  F_dB_MAG = 1.7920 dB
% --------------------------------------------------------------------
%  Fmin Design 
% --------------------------------------------------------------------
%  Gamma_S_fmin: Gamma_S_fmin(1) = -0.3132
%  Gamma_L_fmin = (0.2726 < -177.7155 deg) 
% 
%  Gamma_in_fmin = (0.5392 < +120.7417 deg) 
%  Gamma_out_fmin = (0.2726 < +177.7155 deg) 
% 
%  Gamma_IMN_Mag_fmin = 0.4325 
%  Gamma_IMN_Mag_dB_fmin = -7.2798 
%  VSWR_IMN_fmin = 2.5244 
% 
%  Gamma_OMN_Mag_fmin = 0.0000 
%  Gamma_OMN_Mag_dB_fmin = -Inf 
%  VSWR_OMN_fmin = 1.0000 
% 
%  GT_dB_fmin = 11.5032  dB
%  F_dB_fmin = 0.4450 dB
%  --------------------------------------------------------------------
%  Design 1 
%  --------------------------------------------------------------------
%  Best Valid Design Found (Index 7837):
%  Gamma_S_MAT = (0.6024 < -119.7433°)
% 
%  MGamma_IMN_Amp_db = -18.6120 dB
%  MGamma_IMN_Amp = 0.1173
%  VSWR_IMN_Amp = 1.2658
% 
%  MGamma_OMN_Amp_db = -Inf dB
%  MGamma_OMN_Amp = 0.0000
%  VSWR_OMN_Amp = 1.0000
% 
%  GTdb_Amp = 12.8123 dB
%  GT_Amp = 19.1085 W/W
% 
%  F Amp MAT = 1.1433 dB

% % % %-------------------------------------------------------------------
% % % % 
% % % %  Design 2 
% % % % 
% % % %-------------------------------------------------------------------
% % % % Used GPU Memory: 5.494 GB free of 6.2043 GB
% % % % 
% % % %  Best Valid Design 2 Match (Index 3785):
% % % % GT_dB = 12.2463 dB
% % % % F_dB = 0.5803 dB
% % % % VSWR_IMN = 1.4983
% % % % VSWR_OMN = 1.3894
% % % % RFI = 0.2170
% % % % 
% % % %  Gamma_S_Design_2_fromGPU = (0.4256 < -136.0227 deg) 
% % % % 
% % % %  Gamma_L_P3_Design_2 = (0.2904 < +146.0865 deg) 
% % % % GT_dB passes: 7564
% % % % F_dB passes: 4035
% % % % VSWR_IMN passes: 6216
% % % % VSWR_OMN passes: 10000
% % % % Spec limits - GT ≥ 12.00 dB, F ≤ 0.60 dB, VSWR ≤ 1.4983
% % % % --- Best Candidate Based on Score ---
% % % % Score = -6.4070
% % % % GT_dB = 12.2463 dB
% % % % F_dB = 0.5803 dB
% % % % VSWR_IMN = 1.4983
% % % % VSWR_OMN = 1.3894




%% Design Input Matching Network using GammaS

% Then, find the intersection points of the constant conductance and the 
% constant resistance circle.
GammaA = 0.4792*exp(1j*(-118.5)*pi/180);
Za = gamma2z(GammaA,1);
Ya = 1/Za;

IFigure = IFigure + 1;
figure_max(IFigure)
hsm = smithplot;
title('Input Matching Network Design Pt 1')
circle(lna_net,fc,'G',1,'R',real(zs),hsm); 
hsm.GridType = 'YZ';
hold on
plot(GammaS,'k.','MarkerSize',16)
plot(GammaA,'k.','MarkerSize',16)
text(real(GammaS)+0.05,imag(GammaS)-0.05,'\Gamma_{S}','FontSize', 12, ...
    'FontUnits','normalized')
plot(0,0,'k.','MarkerSize',16)
hold off

% %% Junk
% 
% Sp = [S11, S12; S21, S22];
% mS = real(Sp); 
% mS11 = abs(Sp(1,1)); mS12 = abs(Sp(1,2)); 
% mS21 = abs(Sp(2,2)); mS22 = abs(Sp(2,2));
% pS = angle(Sp);
% pS11 = pS(1,1); pS21 = pS(2,1); pS12 = pS(1,2); pS22 = pS(2,2);
% 
% Rn = rn;
% F_dB_Design_2_Sel = F_Design_2_dB(best_idx);
% gamma_opt = Gamma_OPT;
% gamma_opt_polar = Rect_2_Polar(Gamma_OPT);
% real_gamma_opt = real(gamma_opt_polar);
% 
% mRHOm = abs(real_gamma_opt);
% pRHOm = angle(gamma_opt_polar);
% 
% spv = [ mS11 pS11 mS21 pS21 mS12 pS12 mS22 pS22 ];
% npv = [ F_min mRHOm pRHOm Rn ];
% 
% [Gp,Gmax,K,F_dB_Design_2_Calc,Zs,Zl] = netmatch(spv,npv,gamma_opt);
% 
% % Print_Real_Unit('Gp', Gp, 'dB')
% % Print_Real_Unit('Gmax', Gmax, 'dB')
% % Print_Real('K', K)
% % Print_Real_Unit('F', F_dB_Design_2_Calc, 'dB')
% % Print_Rect_Unit('Zs', Zs, 'Ohm')
% % Print_Rect_Unit('Zl', Zl, 'Ohm')
% 
% % netmatch_info
% % Gp, Gmax, K and F  are the power gain, maximum avaliable, 
% %          stability factor and noise figure, respectively. All  are
% %          given in  dB,  except K which is adimensional.  ZS and ZL
% %          are the matching impedancies for the source and load net-
% %          works.  Source and load impedancies are equal to 50 Ohms.
% %
% %          SPV = [ mS11 pS11 mS21 pS21 mS12 pS12 mS22 pS22 ]  is the
% %          transistor S parameter vector. mSij is the magnitude  and 
% %          pSij is the angle (in degree) of the Sij parameter.
% %
% %          NPV = [ Fmin mRHOm pRHOm Rn ] is the transistor noise pa-
% %          rameter vector.  Fmin  is the minimum noise figure in dB, 
% %          mRHO and  pRHO are the magnitude and phase of the optimum
% %          reflection coefficient,  and  Rn is  the normalized noise 
% %          resistor.
% %
% %          The OPT parameter is optional.  If  OPT = 'Fmin'  then ZS 
% %          and ZL are calculated for minimum noise figure.
% 
% GT_dB_Des2 = 12.2463;
% % Sp = sp_eval([0.55,0.135;3.1,0.33],[144,-30;-4,-110]); % evaluate S parameter
% Sp = [S11, S12; S21, S22];
% Fmin = 0.4450;
% 
% % gama_opt = [0.41,-150];
% 
% figure(1)
% figure(2)
% plotSmithChart
% title('gamaL plane')
% [rp,Cp] = GainCircle(Sp, GT_dB_Des2,1); % 2,'-b',2.4,-3*pi/8); % Gp=12,11,10dB circle
% GainCircle(Sp,[10,11,12],2,'-b',2.4,pi/4')
% StabCircle(Sp,2,'k') % stability circle
% % a = [0.397,90.3];
% % b = [0.133,152.23]
% a = Cp+rp.*exp(j*0); % select a from Gp circle
% b = Cp+rp.*exp(j*3.*pi./2); % select b from Gp circle
% % Rfi = exp(Rfi_Design_2(best_idx))/20;
% Rfi = rvo(best_idx);
% plotGama(a,'a')
% plotGama(b,'b')
% 
% ap = Utility(Sp,a,1); % calculate gamaS=gamaIn*, according to gamaL=a
% bp = Utility(Sp,b,1);
% 
% % figure_max(figure(1))
% figure(1)
% plotSmithChart
% title('Gamma_S Plane')
% StabCircle(Sp,1,'k')
% mapCircle(Sp,rp(1),Cp(1),2) % map Gp=12dB circle to gamaS plane (blue)
% plotGama(bp,'b''')
% VSWRCircle(Sp,b,1.5,1,'r') % VSWR circle (red)
% plotGama(gamma_opt,'\Gamma_{opt}','.m')
% plotGama(Gamma_L_Pn_Design_2_array(1),'\Gamma_{L_P{1}}','.m')
% plotGama(Gamma_L_Pn_Design_2_array(2),'\Gamma_{L_P{2}}','.m')
% plotGama(Gamma_L_Pn_Design_2_array(3),'\Gamma_{L_P{3}}','.m')
% plotGama(Gamma_L_Pn_Design_2_array(4),'\Gamma_{L_P{4}}','.m')
% % NoiseCircle(F_min_dB,gama_opt,rn,Rfi,'--m',2.4,4*pi/9) % noise circle Fi=1.3,1.5,2dB (dash magenta)
