function [Delta, Delta_Mag, k_stab, ...
          u_in, u_out, B1, C1, B2, C2] = stability_parameters(S11, S12, S21, S22)
% stability_parameters_gpu: Compute stability factors using GPU arrays
%
% Inputs:
%   S11, S12, S21, S22 - GPU-compatible S-parameters (scalars or vectors)
%
% Outputs:
%   Delta, Delta_Mag - Determinant and magnitude
%   k_stab           - Rollet stability factor
%   u_in, u_out      - Stability measures
%   B1, C1, B2, C2    - Stability circle parameters

    % Ensure inputs are gpuArrays (optional if enforced externally)
    % S11 = gpuArray(S11);  etc...

    % Delta and magnitude
    Delta = S11 .* S22 - S12 .* S21;
    Delta_Mag = abs(Delta);

    % Rollet Stability Factor K
    k_stab = (1 - abs(S11).^2 - abs(S22).^2 + abs(Delta).^2) ...
           ./ (2 .* abs(S12 .* S21));

    % Stability Measures
    u_in = (1 - abs(S22).^2) ./ ...
           (abs(S11 - Delta .* conj(S22)) + abs(S12 .* S21));
    u_out = (1 - abs(S11).^2) ./ ...
            (abs(S22 - Delta .* conj(S11)) + abs(S12 .* S21));

    % Stability Circles (Input/Output)
    B1 = 1 + abs(S11).^2 - abs(S22).^2 - abs(Delta).^2;
    C1 = S11 - Delta .* conj(S22);

    B2 = 1 + abs(S22).^2 - abs(S11).^2 - abs(Delta).^2;
    C2 = S22 - Delta .* conj(S11);
end
