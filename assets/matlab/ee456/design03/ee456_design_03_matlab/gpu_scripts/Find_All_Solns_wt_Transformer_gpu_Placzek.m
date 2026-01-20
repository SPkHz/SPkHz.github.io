function [Parts, Parts_ID, Parts_unad, R] = ...
    Find_All_Solns_wt_Transformer_gpu_Placzek( ...
    Z_num, Z_den, NE, R0_C, Ri, w0_C, w0, R_Sign)

% GPU-Accelerated Matching Network Synthesizer (Partial GPU Support)
% Generates all valid NE-element matching networks with transformer.
% Uses GPU arrays for parts where large matrix manipulation is beneficial.

% -------------------- Initialization --------------------
Z0 = 50;  % System impedance

Z_num_0 = Z_num;
Z_den_0 = Z_den;

N_Components = 7;
N_Tests = 2^16;  % Adjust based on available GPU RAM

% Generate random integer combinations (1:4)
combinations = randi([1, 4], N_Components, N_Tests);
num_comb = size(combinations, 2);

% Check that num_comb is an integer (defensive programming)
if num_comb ~= floor(num_comb)
    warning('num_comb is not an integer. Rounding down.');
    num_comb = floor(num_comb);
    combinations = combinations(:, 1:num_comb);  % Trim excess if needed
end

% Preallocate arrays for results
Parts = zeros(NE - 1, num_comb);
Parts_unad = zeros(NE - 1, num_comb);
Parts_ID = zeros(NE - 1, num_comb);

% Preallocate structures for impedance sets
Z_num_set = repmat(struct('data', []), 1, num_comb);
Z_den_set = Z_num_set;

% Synthesis shifts (used to adjust resonances)
Shift_C = (w0_C / w0) * (R0_C / Ri);
Shift_L = (w0_C / w0) * (Ri / R0_C);

% -------------------- Main Synthesis Loop --------------------
num_comb = size(combinations, 2);
fprintf('Running GPU-accelerated synthesis for %d combinations...\n', num_comb);

parfor x = 1:num_comb  % Parallel loop (not full GPU, but multithreaded)
    Z_num = Z_num_0;
    Z_den = Z_den_0;
    parts_temp = zeros(NE - 1, 1);
    parts_unad_temp = zeros(NE - 1, 1);
    ids_temp = zeros(NE - 1, 1);
    valid = true;

    for y = 1:(NE - 1)
        try
            code = combinations(y, x);
            switch code
                case 1
                    [val, Z_num, Z_den] = EE456_Series_C_Synthesis_gpu(Z_num, Z_den, 0, 1e-5);
                    parts_unad_temp(y) = val;
                    parts_temp(y) = Shift_C * val;
                    ids_temp(y) = 11;
                case 2
                    [val, Z_num, Z_den] = EE456_Shunt_C_Synthesis_gpu(Z_num, Z_den, 0, 1e-5);
                    parts_unad_temp(y) = val;
                    parts_temp(y) = Shift_C * val;
                    ids_temp(y) = 12;
                case 3
                    [val, Z_num, Z_den] = EE456_Series_L_Synthesis_gpu(Z_num, Z_den, 0, 1e-5);
                    parts_unad_temp(y) = val;
                    parts_temp(y) = Shift_L * val;
                    ids_temp(y) = 13;
                case 4
                    [val, Z_num, Z_den] = EE456_Shunt_L_Synthesis_gpu(Z_num, Z_den, 0, 1e-5);
                    parts_unad_temp(y) = val;
                    parts_temp(y) = Shift_L * val;
                    ids_temp(y) = 14;
            end
        catch
            valid = false;
            break;
        end
    end

    if valid && all(~isinf(parts_temp)) && all(parts_temp ~= 0)
        Parts(:, x) = parts_temp;
        Parts_unad(:, x) = parts_unad_temp;
        Parts_ID(:, x) = ids_temp;
        Z_num_set(x).data = Z_num;
        Z_den_set(x).data = Z_den;
    end
end

% -------------------- Clean & Post-Process --------------------
% Remove empty columns
valid_cols = all(Parts ~= 0, 1) & all(~isinf(Parts), 1);
Parts = Parts(:, valid_cols);
Parts_unad = Parts_unad(:, valid_cols);
Parts_ID = Parts_ID(:, valid_cols);
Z_num_set = Z_num_set(valid_cols);
Z_den_set = Z_den_set(valid_cols);

% Remove repeated part types (e.g., Series C + Series C)
bad_cols = false(1, size(Parts_ID, 2));
for x = 1:size(Parts_ID, 2)
    for y = 1:size(Parts_ID, 1) - 1
        if Parts_ID(y, x) == Parts_ID(y + 1, x)
            bad_cols(x) = true;
            break;
        end
    end
end
Parts(:, bad_cols) = [];
Parts_unad(:, bad_cols) = [];
Parts_ID(:, bad_cols) = [];
Z_num_set(bad_cols) = [];
Z_den_set(bad_cols) = [];

% Compute transformer R values
R = nan(1, length(Z_num_set));
for x = 1:length(Z_num_set)
    try
        R(x) = Z_num_set(x).data / Z_den_set(x).data;
    catch
        R(x) = NaN;
    end
end

% Filter undefined
nan_cols = isnan(R);
Parts(:, nan_cols) = [];
Parts_unad(:, nan_cols) = [];
Parts_ID(:, nan_cols) = [];
R(nan_cols) = [];

end
