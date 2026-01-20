function T = EE456_ABCD_Series_L_gpu(L, f)
    %-------------------------------------------------------------------
    % EE456_ABCD_Series_L: Compute ABCD matrix for a series inductor
    % Vectorized to return T(:,:,k) for each frequency f(k)
    %-------------------------------------------------------------------
    % Inputs:
    %   L - inductance in Henrys (scalar)
    %   f - frequency vector (Hz)
    %
    % Output:
    %   T - 3D ABCD matrix: size 2x2xN where N = length(f)
    %-------------------------------------------------------------------

    f = f(:);  % ensure column vector
    omega = 2 * pi * f;
    Z = 1j * omega * L;

    N = length(f);
    T = zeros(2, 2, N);

    for k = 1:N
        T(:, :, k) = [1, Z(k);
                      0, 1];
    end
end
