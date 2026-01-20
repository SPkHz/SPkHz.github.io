function Z_den = Subtract_1(Z_num, Z_den, L, delta, N, useGPU)
    % Print sizes for debugging
    fprintf('Size of Z_num: %s\n', mat2str(size(Z_num)));
    fprintf('Size of Z_den: %s\n', mat2str(size(Z_den)));
    
    Zc = conv(Z_den, [1, 0]);
    fprintf('Size of Zc after conv: %s\n', mat2str(size(Zc)));
    
    % Ensure both Z_num and Zc are row vectors
    Z_num = Z_num(:)';
    Zc = Zc(:)';
    
    % Pad Z_num to match Zc's length
    len_diff = length(Zc) - length(Z_num);
    if len_diff > 0
        Z_num = [Z_num, zeros(1, len_diff)];
    elseif len_diff < 0
        Zc = [Zc, zeros(1, -len_diff)];
    end
    
    fprintf('Size of Z_num after padding: %s\n', mat2str(size(Z_num)));
    fprintf('Size of Zc after padding: %s\n', mat2str(size(Zc)));
    
    % Perform element-wise division and subtraction
    scaled_Z_num = Z_num ./ L;
    fprintf('Size of scaled_Z_num: %s\n', mat2str(size(scaled_Z_num)));
    
    Z_den = Zc - scaled_Z_num;
    
    % Prune small trailing terms
    for k = 1:abs(N)
        if abs(Z_den(end)) <= delta
            Z_den = Z_den(1:end-1);
        end
    end
end
