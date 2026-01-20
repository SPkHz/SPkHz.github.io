%--------------------------------------------------------------------
% 04/28/2012 By John J. Burke, Ph.D., P.E.
% 03/04/2015 By John J. Burke, Ph.D., P.E.
% 03/06/2015 By John J. Burke, Ph.D., P.E.
% 03/09/2015 By John J. Burke, Ph.D., P.E.
% 07/31/2017 By John J. Burke, Ph.D., P.E.
% 08/14/2017 By John J. Burke, Ph.D., P.E.
% 02/15/2019 By John J. Burke, Ph.D., P.E.
% 03/22/2021 By John J. Burke, Ph.D., P.E.
% 03/12/2023 By John J. Burke, Ph.D., P.E.
% 04/07/2025 by steve placzek, student.
%--------------------------------------------------------------------
function [L, Z_num, Z_den] = ...
    EE456_Shunt_L_Synthesis_gpu(Z_num, Z_den, Iprint, Error)
% GPU-enabled Shunt L Extraction Function

if nargin < 3, Iprint = 0; end
if nargin < 4, Error = 1e-5; end

useGPU = isa(Z_num, 'gpuArray') || isa(Z_den, 'gpuArray');

% Cast both arrays to GPU if needed
if useGPU
    Z_num = gpuArray(Z_num);
    Z_den = gpuArray(Z_den);
end

Z_max = max(abs([Z_num, Z_den]), [], 'all');
delta = Error * Z_max;

Z_num_old = Z_num;
Z_den_old = Z_den;

N = length(Z_den) - length(Z_num);
L = Z_num(end-1) / Z_den(end);  % Shunt L coefficient

if (N < 0)
    Z_den = Subtract_1(Z_num, Z_den, L, delta, N, useGPU);
else
    Z_den = Subtract_2(Z_num, Z_den, L, delta, N, useGPU);
end

% Prune trailing near-zero terms
if abs(Z_num(end)) <= delta && abs(Z_den(end)) <= delta
    Z_num = Z_num(1:end-1);
    Z_den = Z_den(1:end-1);
end

Z_num = Z_num .* (abs(Z_num) > delta);
Z_den = Z_den .* (abs(Z_den) > delta);

if Iprint == 0, return, end
Print_Break
EE456_Print_Poly('Y_num', 'Y_den', Z_den_old, Z_num_old)
Print_Break
Print_Text('Shunt L Synthesis')
Print_Real('L', L, 'H')
Print_Break
EE456_Print_Poly('Y_num', 'Y_den', Z_den, Z_num)
Print_Break
end
