function Z_den = Subtract_2(Z_num, Z_den, L, delta, N, useGPU)
Temp = zeros(1, length(Z_num) + N + 1, 'like', Z_num);
Temp(N+2:end) = Z_num;
Z_num = Temp;

Zc = conv(Z_den, [1, 0]);

% Pad if needed
len_diff = length(Zc) - length(Z_num);
if len_diff > 0
    Z_num = [Z_num, zeros(1, len_diff, 'like', Z_num)];
elseif len_diff < 0
    Zc = [Zc, zeros(1, -len_diff, 'like', Zc)];
end

Z_den = Zc - Z_num / L;

if abs(Z_den(end)) <= delta
    Z_den = Z_den(1:end-1);
end
end
