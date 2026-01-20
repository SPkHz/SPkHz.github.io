%--------------------------------------------------------------------
function [T_Np, uz, uz_poly] = ...
    EE456_Chebyshev_Poly_gpu(Np)

% % % if isempty(gcp('nocreate'))
% % %     parpool("threads");
% % % end

%--------------------------------------------------------------------
% GPU-accelerated version
% 03/12/2023 By John J. Burke, Ph.D., P.E.
% Updated 04/07/2025 By steve
%--------------------------------------------------------------------
% [T_Np] = EE456_Chebyshev_Poly(Np);
% T_Np = Chebyshev Polynomial of Npth order
% Roots of T_Np(u)
%  T_Np(uz) = 0
%--------------------------------------------------------------------

u = gpuArray([1, 0]);   % GPU array for 'u'
T_N_m1 = gpuArray(1);   % T_{n-1}
T_Np   = gpuArray([1, 0]);  % T_n

%--------------------------------------------------------------------

for kk = 2 : Np
    T_Old = T_Np;
    T_Np = 2 * conv(T_Np, u) - [0, 0, T_N_m1];
    T_N_m1 = T_Old;
end

%--------------------------------------------------------------------
% Roots of Chebyshev polynomial
uz_poly = gather(roots(T_Np));  % Must gather for roots
uz_poly = sort(uz_poly);

%--------------------------------------------------------------------
% Approximate Chebyshev roots (cosine method)
nn = gpuArray(1 : 2 : (2*Np - 1));
uz = cosd(nn * 90 / Np);
uz = sort(uz);
uz = transpose(uz);

%--------------------------------------------------------------------
% Convert final GPU outputs back to CPU for compatibility
T_Np = gather(T_Np);
uz = gather(uz);

%--------------------------------------------------------------------
end

% function a = EE456_Chebyshev_Poly_gpu(N, Ripple)
% 
% % parpool("Threads");
% 
% % Convert inputs to GPU arrays
% N = gpuArray(N);
% Ripple = gpuArray(Ripple);
% 
% % Compute Chebyshev polynomial coefficients
% epsilon = sqrt(10^(Ripple/10) - 1);
% x = cos(pi * (0:N) / N);  % Chebyshev nodes
% 
% % Create Chebyshev matrix
% T = zeros(N+1);
% T(:,1) = 1;
% T(:,2) = x(:);
% 
% for k = 3:N+1
%     T(:,k) = 2 * x(:) .* T(:,k-1) - T(:,k-2);
% end
% 
% % Use alternation theorem to solve for polynomial coefficients
% rhs = zeros(N+1,1,'gpuArray');
% rhs(1:2:end) = (-1).^(0:floor(N/2))';
% a = T \ rhs;
% 
% % Move result back to CPU
% a = gather(a);
% 
% end
