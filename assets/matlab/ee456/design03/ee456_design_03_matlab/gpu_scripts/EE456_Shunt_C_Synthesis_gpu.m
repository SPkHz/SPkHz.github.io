function [C, Z_num, Z_den] = ...
    EE456_Shunt_C_Synthesis_gpu(Z_num, Z_den, Iprint, Error)

% % % if isempty(gcp('nocreate'))
% % %     parpool("threads");
% % % end


%--------------------------------------------------------------------
% 04/28/2012 By John J. Burke, Ph.D., P.E.
% 03/04/2015 By John J. Burke, Ph.D., P.E.
% 03/06/2015 By John J. Burke, Ph.D., P.E.
% 03/09/2015 By John J. Burke, Ph.D., P.E.
% 07/31/2017 By John J. Burke, Ph.D., P.E.
% 02/15/2019 By John J. Burke, Ph.D., P.E.
% 03/22/2021 By John J. Burke, Ph.D., P.E.
% 03/12/2023 By John J. Burke, Ph.D., P.E.
% 04/07/2025 By Steve M. Placzek, No Qualifications.
%--------------------------------------------------------------------

if nargin < 3, Iprint = 0; end
if nargin < 4, Error = 1e-5; end

% Ensure compatibility with GPU arrays
if isa(Z_num, 'gpuArray') || isa(Z_den, 'gpuArray')
    Z_num = gpuArray(Z_num);
    Z_den = gpuArray(Z_den);
end

Z_max = max(abs([Z_num, Z_den]), [], 'all');
delta = Error * Z_max;
Z_num_old = Z_num;
Z_den_old = Z_den;
C = Z_den(1) / Z_num(1);

Zc = conv(Z_num, [1, 0]);
len_diff = length(Zc) - length(Z_den);
if len_diff > 0
    Z_den = [Z_den, zeros(1, len_diff)];  % Pad Z_den with zeros
elseif len_diff < 0
    Zc = [Zc, zeros(1, -len_diff)];       % Pad Zc with zeros
end

Z_den = Z_den - C * Zc;

% Z_den = Z_den - C * conv(Z_num, [1, 0]);

% Remove small leading coefficients
if abs(Z_den(1)) <= delta
    Z_den = Z_den(2:end);
end
if abs(Z_den(1)) <= delta
    Z_den = Z_den(2:end);
end

Z_num = Z_num .* (abs(Z_num) > delta);
Z_den = Z_den .* (abs(Z_den) > delta);

if Iprint == 0, return, end

Print_Text('Shunt C Synthesis')
Print_Real('C', C, 'F')
Print_Break
EE456_Print_Poly('Y_num', 'Y_den', Z_den_old, Z_num_old)
Print_Break
Print_Text('Shunt C Synthesis')
Print_Real('C', C, 'F')
Print_Break
EE456_Print_Poly('Y_num', 'Z_den', Z_den, Z_num)
Print_Break
end
