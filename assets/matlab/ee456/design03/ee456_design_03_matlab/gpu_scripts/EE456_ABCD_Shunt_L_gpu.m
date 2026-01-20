function T = EE456_ABCD_Shunt_L_gpu(L, f)
    %-------------------------------------------------------------------
    % EE456_ABCD_Shunt_L: Computes ABCD matrix for a shunt inductor
    % Vectorized version returns T(:,:,k) for each frequency f(k)
    %-------------------------------------------------------------------
    % Inputs:
    %   L - inductance in Henrys (scalar)
    %   f - frequency vector (Hz)
    %
    % Output:
    %   T - 3D ABCD matrix: 2x2xN where N = length(f)
    %-------------------------------------------------------------------

    f = f(:);  % ensure column vector
    omega = 2 * pi * f;
    Y_L = 1j * omega * L;  % admittance

    N = length(f);
    T = zeros(2, 2, N);

    for k = 1:N
        T(:, :, k) = [1, 0;
                      Y_L(k), 1];
    end
end
