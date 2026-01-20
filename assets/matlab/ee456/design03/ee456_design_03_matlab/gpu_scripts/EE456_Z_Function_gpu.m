function [Z_num, Z_den, R_num, R_den] = ...
    EE456_Z_Function_gpu(sz, sp, R_Sign, Error)

if nargin < 3, R_Sign = 1; end
if nargin < 4, Error = 10^-5; end

% GPU-compatible polynomials
R_den = gpuArray(poly(sp));
R_num = gpuArray(R_Sign * poly(sz));

Z_num = R_den + R_num;
Z_den = R_den - R_num;

% Clean up small leading coefficients
Z_max = max(max(abs(Z_num)), max(abs(Z_den)));
delta = Error * Z_max;

if abs(Z_num(1)) <= delta
    Z_num = Z_num(2:end);
end
if abs(Z_den(1)) <= delta
    Z_den = Z_den(2:end);
end

Z_num = Z_num .* (abs(Z_num) > delta);
Z_den = Z_den .* (abs(Z_den) > delta);

% Return to CPU
Z_num = gather(Z_num);
Z_den = gather(Z_den);
R_num = gather(R_num);
R_den = gather(R_den);
end


% % % function [Z_num, Z_den, R_num, R_den] = ...
% % %     EE456_Z_Function_gpu(sz, sp, R_Sign, Error)
% % % 
% % % % % % if isempty(gcp('nocreate'))
% % % % % %     parpool("threads");
% % % % % % end
% % % 
% % % %--------------------------------------------------------------------
% % % % 04/28/2012 By John J. Burke, Ph.D., P.E.
% % % % 03/04/2015 By John J. Burke, Ph.D., P.E.
% % % % 03/09/2015 By John J. Burke, Ph.D., P.E.
% % % % 07/31/2017 By John J. Burke, Ph.D., P.E.
% % % % 02/15/2019 By John J. Burke, Ph.D., P.E.
% % % % 03/12/2023 By John J. Burke, Ph.D., P.E.
% % % % 04/07/2025 modified by steve, 0 qualifications
% % % %--------------------------------------------------------------------
% % % 
% % % % GPU-Compatible EE456_Z_Function
% % % % Converts inputs to gpuArrays, performs operations, and gathers results.
% % % 
% % % if nargin < 3, R_Sign = 1; end
% % % if nargin < 4, Error = 10^-5; end
% % % 
% % % % Convert inputs to GPU if available
% % % useGPU = gpuDeviceCount > 0;
% % % if useGPU
% % %     sz = gpuArray(sz);
% % %     sp = gpuArray(sp);
% % % end
% % % 
% % % % Polynomial generation
% % % R_den = poly(sp);
% % % R_num = R_Sign * poly(sz);
% % % 
% % % Z_num = R_den + R_num;
% % % Z_den = R_den - R_num;
% % % 
% % % % Cleanup small coefficients
% % % Z_max = max(max(abs(Z_num)), max(abs(Z_den)));
% % % delta = Error * Z_max;
% % % 
% % % if abs(Z_num(1)) <= delta
% % %     Z_num = Z_num(2:end);
% % % end
% % % if abs(Z_den(1)) <= delta
% % %     Z_den = Z_den(2:end);
% % % end
% % % 
% % % Z_num = Z_num .* (abs(Z_num) > delta);
% % % Z_den = Z_den .* (abs(Z_den) > delta);
% % % 
% % % % Transfer results back to CPU
% % % if useGPU
% % %     Z_num = gather(Z_num);
% % %     Z_den = gather(Z_den);
% % %     R_num = gather(R_num);
% % %     R_den = gather(R_den);
% % % end
