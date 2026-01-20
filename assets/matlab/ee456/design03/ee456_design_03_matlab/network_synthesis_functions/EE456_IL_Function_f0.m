%--------------------------------------------------------------------

function [IL_num, IL_den, R2_num, R2_den] = ...
    EE456_IL_Function_f0(fL, fH, k0, kT, N_Poly, NSi)

%--------------------------------------------------------------------
% 04/29/2012 Written by by John J. Burke, Ph.D., P.E.
% 03/08/2015 Modified by John J. Burke, Ph.D., P.E.
% 02/28/2017 Modified by John J. Burke, Ph.D., P.E.
% 08/11/2017 Modified by John J. Burke, Ph.D., P.E.
% 12/15/2018 Modified by John J. Burke, Ph.D., P.E.
% 03/24/2021 Modified by John J. Burke, Ph.D., P.E.
% 03/12/2023 Modified by John J. Burke, Ph.D., P.E.
% 07/09/2024 Modified by John J. Burke, Ph.D., P.E.
%--------------------------------------------------------------------
% IL = k0 + kT * T_Np(w_bar)^2;
%--------------------------------------------------------------------

BW_f = fH - fL;
f0 = sqrt(fL * fH);
N_LPF = N_Poly;
N_BPF = 2 * N_LPF;
delta = BW_f / f0;

%--------------------------------------------------------------------

I_Sym = (-1)^N_LPF;
X_Sign = zeros(1, 2*N_LPF+1);
X_Sign(end) = 1;
nn = N_LPF : -1 : 1;
X_Sign(1 : 2 : 2*N_LPF) = (-1).^nn;

%--------------------------------------------------------------------

[T_Np] = EE456_Chebyshev_Poly(N_LPF);
IL_num_LPF = kT * conv(T_Np, T_Np) .* X_Sign;
IL_num_LPF(end) = IL_num_LPF(end) + k0;

%--------------------------------------------------------------------

sz_LPF = roots(IL_num_LPF);
sz_BPF = zeros(2*N_BPF, 1);
for kk = 1 : N_BPF
    Poly = [1, -delta*sz_LPF(kk), 1];
    sz_BPF(2*kk-1 : 2*kk) = roots(Poly);
end
sz_BPF = sort(sz_BPF);

%--------------------------------------------------------------------

X_Sign = zeros(1, 2*N_BPF+1);
X_Sign(end) = 1;
nn = N_BPF : -1 : 1;
X_Sign(1 : 2 : 2*N_BPF) = (-1).^nn;

%--------------------------------------------------------------------

X_Scale = k0 + ((I_Sym + 1)/2)*kT;
IL_num = poly(sz_BPF);
IL_num = ...
    abs(X_Scale/polyval(IL_num, 1j)) * IL_num;
I_max = length(IL_num);
IL_num(2 : 2 : I_max) = 0;

%--------------------------------------------------------------------

IL_den = zeros(size(IL_num));
I_Slope = I_max - 2*N_Poly + 2*NSi;
IL_den(I_Slope) = ...
    X_Sign(I_Slope) * (f0/fH)^(2*NSi);
IL_den(2 : 2 : I_max) = 0;

%--------------------------------------------------------------------

R2_num = IL_num - IL_den;
R2_den = IL_num;

%--------------------------------------------------------------------
