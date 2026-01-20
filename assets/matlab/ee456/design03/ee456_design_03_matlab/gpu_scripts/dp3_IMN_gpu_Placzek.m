function [S_XMN, nt, store_Post_transform_and_Transitor, Tholder] = dp3_IMN_gpu_Placzek()

%% -------------------- Constants --------------------
G = 1e9; M = 1e6; K = 1e3;
m = 1e-3; u = 1e-6; n = 1e-9;
p = 1e-12; f = 1e-15;

NF = 32;
Z0 = 50;

%% -------------------- Transistor Model --------------------
Li = 347.8189 * p;
Ci = 245.2104 * f;
Ri = 23.0767;

%% -------------------- Frequency Sweep --------------------
%------------------------------------------------------------------
NE = 7;
NS_I = 1;
IL_min_dB_I = 0.0;
Ripple_I = 0.1;
IL_max_dB_I = IL_min_dB_I + Ripple_I;
fL = 9*G;
fH = 20*G;
f0 = sqrt(fL*fH);
BW_f = fH - fL;
f_min = 8*G;
f_max = 22*G;
df = 25*M;
Ro = 44.0222;
Co = 283.0342*f;
Lo = 202.0340*p;

%------------------------------------------------------------------
w0 = 2*pi*f0;
wH = 2*pi*fH;
wL = 2*pi*fL;
BW_w = 2*pi*BW_f;
Delta = BW_f/f0;

%-------------------------------------------------------------------
freq = f_min:df:f_max;
fx = [fL, f0, fH];
freq = union(freq, fx);
freq = sort(freq);
I_fx = ismember(freq, fx);
N_Freq = length(freq);
w = 2 * pi * freq;

%% -------------------- IL Function --------------------
N_Poly = (1/2)*(NE-1);
IL_max_I = 10^(IL_max_dB_I/10);
IL_min_I = 10^(IL_min_dB_I/10);
k0_I = IL_min_I;
kT_I = IL_max_I - k0_I;

fprintf('Using direct synthesis approach for IMN...\n');
%% -------------------- Direct Synthesis (Sequential) --------------------
% Use the classical polynomial approach similar to DP3_Ryan_Total.m
[IL_num, IL_den, R2_num, R2_den] = EE456_IL_Function_f0(fL, fH, k0_I, kT_I, N_Poly, NS_I);

sz2 = roots(R2_num); sz = sz2(real(sz2) < 0);
sp2 = roots(R2_den); sp = sp2(real(sp2) < 0);

R_Sign = 1;
[Z_num, Z_den, R_num, R_den] = EE456_Z_Function(sz, sp, R_Sign);

% Direct synthesis, element by element
[C1_I, Z_num, Z_den] = EE456_Series_C_Synthesis_gpu(Z_num, Z_den, 0);
[L2_I, Z_num, Z_den] = EE456_Series_L_Synthesis_gpu(Z_num, Z_den, 0);
[L3_I, Z_num, Z_den] = EE456_Shunt_L_Synthesis_gpu(Z_num, Z_den, 0);
[C4_I, Z_num, Z_den] = EE456_Shunt_C_Synthesis_gpu(Z_num, Z_den, 0);
[C5_I, Z_num, Z_den] = EE456_Series_C_Synthesis_gpu(Z_num, Z_den, 0);
[L6_I, Z_num, Z_den] = EE456_Shunt_L_Synthesis_gpu(Z_num, Z_den, 0);
R7_I = Z_num / Z_den;

% Denormalize components
C1_I = C1_I/(w0*Ri);
L2_I = (L2_I/w0)*Ri;
L3_I = (L3_I/w0)*Ri;
C4_I = C4_I/(w0*Ri);
C5_I = C5_I/(w0*Ri);
L6_I = (L6_I/w0)*Ri;
RTp_I = R7_I*Ri;

% Calculate transformer ratio and apply transformer
nt = sqrt(Z0/RTp_I);
NT = nt^2;

% Apply transformer
CP = C4_I;
CS = C5_I;
CC = (1/nt)*((nt-1)*CS+(nt*CP));
CB = (1/nt)*CS;
CA = (1/nt^2)*((1-nt)*CS);
LZ = (nt^2)*L6_I;

% Final component values
C1 = C1_I;
L2 = L2_I;
L3 = L3_I;
C4 = CC;
C5 = CB;
C6 = CA;
L7 = LZ;

% Store pre-transistor integration values
store_Pre_transform = [C1, L2, L3, C4, C5, C6, L7];

% Adjust for transistor integration
Ci1 = ((1/C1) - (1/Ci))^-1;
Li2 = L2 - Li;
Li3 = L3;
Ci4 = C4;
Ci5 = C5;
Ci6 = C6;
Li7 = L7;

% Store post-transistor integration values for output
store_Post_transform_and_Transitor = [Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7];

%% -------------------- ABCD Chain & S-Parameter Evaluation --------------------
S_XMN = zeros(N_Freq, 2, 2);
Tholder = zeros(N_Freq, 2, 2);

for kk = 1:N_Freq
    fk = freq(kk);
    sk = 1i * 2 * pi * fk;
    Zp1 = Ri + (1 / (Ci * sk)) + Li * sk;

    T1 = EE456_ABCD_Series_C(Ci1, fk);
    T2 = EE456_ABCD_Series_L(Li2, fk);
    T3 = EE456_ABCD_Shunt_L(Li3, fk);
    T4 = EE456_ABCD_Shunt_C(Ci4, fk);
    T5 = EE456_ABCD_Series_C(Ci5, fk);
    T6 = EE456_ABCD_Shunt_C(Ci6, fk);
    T7 = EE456_ABCD_Shunt_L(Li7, fk);

    T = T1 * T2 * T3 * T4 * T5 * T6 * T7;
    S_XMN(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
    Tholder(kk, :, :) = T;
end

%% -------------------- Results Display --------------------
fprintf('\n========== IMN Component Values ==========\n');
fprintf('Ci1 = %.4f fF\n', Ci1 * 1e15);
fprintf('Li2 = %.4f pH\n', Li2 * 1e12);
fprintf('Li3 = %.4f pH\n', Li3 * 1e12);
fprintf('Ci4 = %.4f fF\n', Ci4 * 1e15);
fprintf('Ci5 = %.4f fF\n', Ci5 * 1e15);
fprintf('Ci6 = %.4f fF\n', Ci6 * 1e15);
fprintf('Li7 = %.4f pH\n', Li7 * 1e12);
fprintf('========================================\n\n');

%% -------------------- Plot S-Parameters --------------------
S11_dB = 20 * log10(abs(S_XMN(:, 1, 1)));
S21_dB = 20 * log10(abs(S_XMN(:, 2, 1)));
S11_fx_dB = S11_dB(I_fx);
S21_fx_dB = S21_dB(I_fx);

IFigure = 100;

figure(IFigure + 1);
plot(freq / G, S21_dB, 'r', 'LineWidth', 2.5); hold on;
plot(fx / G, S21_fx_dB, 'ro', 'LineWidth', 4);
grid on; grid minor;
xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{21}| (dB)');
title('{\itS}_{21} IMN'); xlim([f_min, f_max] / G);
set(gca, 'FontSize', NF, 'LineWidth', 1.5);

figure(IFigure + 2);
plot(freq / G, S11_dB, 'b', 'LineWidth', 2.5); hold on;
plot(fx / G, S11_fx_dB, 'bo', 'LineWidth', 4);
grid on; grid minor;
xlabel('{\itf} (GHz)'); ylabel('|{\itS}_{11}| (dB)');
title('{\itS}_{11} IMN'); xlim([f_min, f_max] / G);
set(gca, 'FontSize', NF, 'LineWidth', 1.5);

%% -------------------- IL Plot --------------------
f_f0 = freq / f0;
s = 1j * f_f0;
IL = polyval(IL_num, s) ./ polyval(IL_den, s);
IL_dB = 10 * log10(abs(IL));

figure(IFigure + 3);
plot(freq / G, IL_dB, 'k', 'LineWidth', 2.5); hold on;
plot(fx / G, IL_dB(I_fx), 'ko', 'LineWidth', 4);
grid on; grid minor;
xlabel('{\itf} / {\itf}_0'); ylabel('{\itIL} (dB)');
title('{\itIL} of Synthesized Network');
set(gca, 'FontSize', NF, 'LineWidth', 1.5);

end
