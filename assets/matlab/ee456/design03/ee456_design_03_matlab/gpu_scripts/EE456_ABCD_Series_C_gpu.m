function T = EE456_ABCD_Series_C_gpu(C, f)
    % Vectorized ABCD for a series capacitor over f(:)
    f = f(:);  % ensure column vector
    omega = 2 * pi * f;
    Z_C = 1 ./ (1j * omega * C);

    N = length(f);
    T = zeros(2, 2, N);  % preallocate 3D matrix

    for k = 1:N
        T(:, :, k) = [1, Z_C(k);
                      0, 1];
    end
end
