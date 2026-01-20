function T = EE456_ABCD_Shunt__gpu(C, f)
    %-------------------------------------------------------------------
    % EE456_ABCD_Shunt_C: ABCD matrix for a shunt capacitor (vectorized)
    % Computes T(:,:,k) for each frequency f(k)
    %-------------------------------------------------------------------
    % Inputs:
    %   C - capacitance in Farads (scalar)
    %   f - frequency vector (Hz)
    % Output:
    %   T - 3D ABCD matrix (2x2xN), one per frequency
    %-------------------------------------------------------------------

    f = f(:);  % ensure column vector
    omega = 2 * pi * f;
    Y_C = 1j * omega * C;  % admittance

    N = length(f);
    T = zeros(2, 2, N);

    for k = 1:N
        T(:, :, k) = [1, 0;
                      Y_C(k), 1];
    end
end
