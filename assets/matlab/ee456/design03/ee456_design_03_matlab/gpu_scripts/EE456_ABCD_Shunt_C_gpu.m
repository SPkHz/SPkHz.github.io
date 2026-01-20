function T = EE456_ABCD_Shunt_C_gpu(C, f)
    % EE456_ABCD_Shunt_C: Vectorized ABCD matrix for a shunt capacitor
    % Inputs:
    %   C - capacitance (scalar, Farads)
    %   f - frequency vector (Hz)
    % Output:
    %   T - 3D ABCD matrix (2x2xN)

    f = f(:);  % ensure column vector
    omega = 2 * pi * f;
    Y_C = 1j * omega * C;  % shunt admittance

    N = length(f);
    T = zeros(2, 2, N);

    for k = 1:N
        T(:, :, k) = [1, 0;
                      Y_C(k), 1];
    end
end
