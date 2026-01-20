function [L, Z_num, Z_den] = ...
    EE456_Series_L_Synthesis_gpu(Z_num, Z_den, Iprint, Error, useGPU)

% % % if isempty(gcp('nocreate'))
% % %     parpool("threads");
% % % end

%--------------------------------------------------------------------
% GPU-enabled Series L Synthesis
%--------------------------------------------------------------------
% 04/28/2012 By John J. Burke, Ph.D., P.E.
% 03/04/2015 By John J. Burke, Ph.D., P.E.
% 03/06/2015 By John J. Burke, Ph.D., P.E.
% 03/09/2015 By John J. Burke, Ph.D., P.E.
% 07/31/2017 By John J. Burke, Ph.D., P.E.
% 02/15/2019 By John J. Burke, Ph.D., P.E.
% 03/22/2021 By John J. Burke, Ph.D., P.E.
% 03/12/2023 By John J. Burke, Ph.D., P.E.
%--------------------------------------------------------------------
% Modified 04/2025 for GPU by steve
%--------------------------------------------------------------------

if nargin < 3, Iprint = 0; end
if nargin < 4, Error = 10^-5; end
if nargin < 5, useGPU = false; end

%--------------------------------------------------------------------
% Move data to GPU if requested
if useGPU
    Z_num = gpuArray(Z_num);
    Z_den = gpuArray(Z_den);
end

Z_max = max(max(abs(Z_num)), max(abs(Z_den)));
delta = Error * Z_max;
Z_num_old = Z_num;
Z_den_old = Z_den;
L = Z_num(1) / Z_den(1);

%--------------------------------------------------------------------
Zc = conv(Z_den, [1, 0]);
len_diff = length(Zc) - length(Z_num);

if len_diff > 0
    Z_num = [Z_num, zeros(1, len_diff, 'like', Z_num)];
elseif len_diff < 0
    Zc = [Zc, zeros(1, -len_diff, 'like', Zc)];
end

Z_num = Z_num - L * Zc;

% Z_num = Z_num - L * conv(Z_den, [1, 0]);

if abs(Z_num(1)) <= delta
    Z_num = Z_num(2:end);
end
if abs(Z_num(1)) <= delta
    Z_num = Z_num(2:end);
end

Z_num = Z_num .* (abs(Z_num) > delta);
Z_den = Z_den .* (abs(Z_den) > delta);

% Bring back from GPU if needed
if useGPU
    L = gather(L);
    Z_num = gather(Z_num);
    Z_den = gather(Z_den);
end

%--------------------------------------------------------------------
if Iprint == 0, return, end
Print_Break
EE456_Print_Poly('Z_num', 'Z_den', Z_num_old, Z_den_old)
Print_Break
Print_Text('Series L Synthesis')
Print_Real('L', L, 'H')
Print_Break
EE456_Print_Poly('Z_num', 'Z_den', Z_num, Z_den)
Print_Break

%--------------------------------------------------------------------
end
