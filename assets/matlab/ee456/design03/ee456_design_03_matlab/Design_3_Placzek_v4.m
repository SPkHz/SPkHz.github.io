%% 7-Element IMN Design for NE321000 Transistor
% Corrected code to match Ryan's implementation
% Network synthesis using insertion loss method with Chebyshev response
% Frequency range: 9-20 GHz with sloped response (NS_I = 1)
clc;
clear all;
close all;

delete(gcp('nocreate'));  % Clean up any existing pool
if isempty(gcp('nocreate'))
    parpool("threads");
end

%% Constants and Unit Conversion
G = 10^+9;
M = 10^+6;
K = 10^3;
m = 10^-3;
u = 10^-6;
n = 10^-9;
p = 10^-12;
f = 10^-15;

%% Project Parameters
NE = 7;                % Number of reactive elements
NS_I = 1;              % Slope parameter (matching Ryan's value)
IL_min_dB_I = 0.0;     % Minimum insertion loss in dB
Ripple_I = 0.1;        % Passband ripple in dB
IL_max_dB_I = IL_min_dB_I + Ripple_I;
NSi = 1;
% Frequency specifications
fL = 9*G;              % Lower band edge frequency (Hz)
fH = 20*G;             % Upper band edge frequency (Hz)
f0 = sqrt(fL*fH);      % Center frequency (Hz)
BW_f = fH - fL;        % Bandwidth (Hz)
f_min = 8*G;           % Minimum frequency for plots (Hz)
f_max = 22*G;          % Maximum frequency for plots (Hz)
df = 25*M;             % Frequency step size (Hz)

% Transistor parameters
Ri = 23.0767;          % Input resistance (ohms)
Ci = 245.2104*f;       % Input capacitance (F)
Li = 347.8189*p;       % Input inductance (H)
Ro = 44.0222;          % Output resistance (ohms)
Co = 283.0342*f;       % Output capacitance (F)
Lo = 202.0340*p;       % Output inductance (H)

% System parameters
Z0 = 50;               % System characteristic impedance (ohms)
NF = 32;               % Font size for plots
IFigure = 0;           % Figure counter

%% Frequency Calculations
w0 = 2*pi*f0;          % Center angular frequency (rad/s)
wH = 2*pi*fH;          % Upper angular frequency (rad/s)
wL = 2*pi*fL;          % Lower angular frequency (rad/s)
BW_w = 2*pi*BW_f;      % Angular bandwidth (rad/s)
Delta = BW_f/f0;       % Fractional bandwidth

% Create frequency vector
freq = f_min:df:f_max;
fx = [fL, f0, fH];     % Key frequencies
freq = union(freq, fx);
freq = sort(freq);
I_fx = ismember(freq, fx);
N_Freq = length(freq);
S_IMN = zeros(N_Freq, 2, 2);  % S-parameter matrix

%% Insertion Loss Function Parameters
N_Poly = (1/2)*(NE-1);  % Polynomial order for Chebyshev
IL_max_I = 10^(IL_max_dB_I/10);  % Linear maximum insertion loss
IL_min_I = 10^(IL_min_dB_I/10);  % Linear minimum insertion loss
k0_I = IL_min_I;        % Minimum loss parameter
kT_I = IL_max_I - k0_I; % Loss range parameter

%% Print Design Parameters
Print_Title('Network Synthesis - IMN Design for NE321000');
Print_Real_Unit('f0', f0, 'Hz');
Print_Real_Unit('BW_f', BW_f, 'Hz');
Print_Real_Unit('Ri', Ri, 'Ohms');
Print_Real_Unit('Ci', Ci, 'F');
Print_Real_Unit('Li', Li, 'H');
Print_Real_Unit('Ro', Ro, 'Ohms');
Print_Real_Unit('Co', Co, 'F');
Print_Real_Unit('Lo', Lo, 'H');
Print_Real('NE', NE, 'Reactive Elements');
Print_Real('N_Poly', N_Poly, 'Order Chebyshev');
Print_Real('NS', NS_I, 'Slope Parameter');
Print_Real_Unit('fL', fL, 'Hz');
Print_Real_Unit('fH', fH, 'Hz');
Print_Break();
Print_Real2('w0', w0, 'rad/s');
Print_Real('w0', w0/w0, 'w0');
Print_Real2('BW_w', BW_w, 'rad/s');
Print_Real('BW_w', BW_w/w0, 'w0');
Print_Real2('wL', wL, 'rad/s');
Print_Real('wL', wL/w0, 'w0');
Print_Real2('wH', wH, 'rad/s');
Print_Real('wH', wH/w0, 'w0');
Print_Break();
Print_Real('IL_min', IL_min_dB_I, 'dB');
Print_Real('Ripple', Ripple_I, 'dB');
Print_Real('IL_max', IL_max_dB_I, 'dB');
Print_Real('k0', k0_I);
Print_Real_Unit('kT', kT_I, 'W/W');
Print_Break();

%% Generate Insertion Loss Function - Using Ryan's approach
[IL_num_I, IL_den_I, R2_num_I, R2_den_I] = EE456_IL_Function_f0(fL, fH, k0_I, kT_I, N_Poly, NS_I);

% Find zeros and poles
sz2_I = roots(R2_num_I);
sz_I = sz2_I(real(sz2_I) < 0);
sp2_I = roots(R2_den_I);
sp_I = sp2_I(real(sp2_I) < 0);

%% Print Polynomials
Print_Break();
EE456_Print_Poly('IL_num', 'IL_den', IL_num_I, IL_den_I);
Print_Break();
EE456_Print_Poly('R2_num', 'R2_den', R2_num_I, R2_den_I);
Print_Break();

%% Print Zeros and Poles
Print_Rect('sz2', sz2_I, 'rad/s');
Print_Rect('sp2', sp2_I, 'rad/s');
Print_Break();
Print_Rect('sz', sz_I, 'rad/s');
Print_Rect('sp', sp_I, 'rad/s');

%% Calculate Insertion Loss Function Values
f_f0 = freq/f0;
w_w0 = f_f0;
s = 1j*w_w0;
IL_I = polyval(IL_num_I, s) ./ polyval(IL_den_I, s);
IL_dB_I = 10*log10(abs(IL_I));

%% Network Synthesis
R_Sign = 1;
[Z_num, Z_den, R_num_I, R_den_I] = EE456_Z_Function_gpu(sz_I, sp_I, R_Sign);

[C1_I, Z_num, Z_den] = EE456_Series_C_Synthesis_gpu(Z_num, Z_den, 1);
Print_Break();
[L2_I, Z_num, Z_den] = EE456_Series_L_Synthesis_gpu(Z_num, Z_den, 1);
Print_Break();
[L3_I, Z_num, Z_den] = EE456_Shunt_L_Synthesis_gpu(Z_num, Z_den, 1);
Print_Break();
[C4_I, Z_num, Z_den] = EE456_Shunt_C_Synthesis_gpu(Z_num, Z_den, 1);
Print_Break();
[C5_I, Z_num, Z_den] = EE456_Series_C_Synthesis_gpu(Z_num, Z_den, 1);
Print_Break();
[L6_I, Z_num, Z_den] = EE456_Shunt_L_Synthesis_gpu(Z_num, Z_den, 1);
Print_Break();
R7_I = R_num_I / R_den_I;

[IL_num_I, IL_den_I, R2_num_I, R2_den_I] = ...
    EE456_IL_Function_f0_gpu(fL, fH, k0_I, kT_I, N_Poly, NSi);



%% Print Polynomials
Print_Break();
EE456_Print_Poly('IL_num', 'IL_den', IL_num_I, IL_den_I);
Print_Break();
EE456_Print_Poly('R2_num', 'R2_den', R2_num_I, R2_den_I);
Print_Break();

%% Print Normalized Component Values
Print_Break();
Print_Real_Unit('C1', C1_I, 'F');
Print_Real_Unit('L2', L2_I, 'H');
Print_Real_Unit('L3', L3_I, 'H');
Print_Real_Unit('C4', C4_I, 'F');
Print_Real_Unit('C5', C5_I, 'F');
Print_Real_Unit('L6', L6_I, 'H');
Print_Real_Unit('R7', R7_I, 'Ohm');
Print_Break();

%% Denormalize Components
C1_I = C1_I/(w0*Ri);
L2_I = (L2_I/w0)*Ri;
L3_I = (L3_I/w0)*Ri;
C4_I = C4_I/(w0*Ri);
C5_I = C5_I/(w0*Ri);
L6_I = (L6_I/w0)*Ri;
RTp_I = R7_I*Ri;

%% Print Denormalized Component Values
Print_Break();
Print_Real_Unit('Ri', Ri, 'Ohms');
Print_Real_Unit('Ci', Ci, 'F');
Print_Real_Unit('fH', fH, 'Hz');
Print_Real_Unit('f0', f0, 'Hz');
Print_Real_Unit('fL', fL, 'Hz');
Print_Real_Unit('BW_f', BW_f, 'Hz');
Print_Break();
Print_Real_Unit('C1', C1_I, 'F');
Print_Real_Unit('L2', L2_I, 'H');
Print_Real_Unit('L3', L3_I, 'H');
Print_Real_Unit('C4', C4_I, 'F');
Print_Real_Unit('C5', C5_I, 'F');
Print_Real_Unit('L6', L6_I, 'H');
Print_Real_Unit('RTp', RTp_I, 'Ohms');
Print_Break();

%% Calculate S-parameters for IMN design
for kk = 1 : N_Freq
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C_gpu(C1_I, fk);
 T2 = EE456_ABCD_Series_L_gpu(L2_I, fk);
 T3 = EE456_ABCD_Shunt_L_gpu(L3_I, fk);
 T4 = EE456_ABCD_Shunt_C_gpu(C4_I, fk);
 T5 = EE456_ABCD_Series_C_gpu(C5_I, fk);
 T6 = EE456_ABCD_Shunt_L_gpu(L6_I, fk);
 T = T1*T2*T3*T4*T5*T6;  % Use proper matrix multiplication
 S_IMN(kk, :, :) = ABCD_to_S(T, [Ri, RTp_I]);
end

%% Extract S-parameters
S11_IMN = S_IMN(:, 1, 1);
S11_IMN_Mag = abs(S11_IMN);
S11_IMN_dB = 20*log10(S11_IMN_Mag);
S21_IMN = S_IMN(:, 2, 1);
S21_IMN_Mag = abs(S21_IMN);
S21_IMN_dB = 20*log10(S21_IMN_Mag);
S11_IMN_fx_dB = S11_IMN_dB(I_fx);
S21_IMN_fx_dB = S21_IMN_dB(I_fx);

%% Recalculate with Z0 termination
for kk = 1 : N_Freq
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C_gpu(C1_I, fk);
 T2 = EE456_ABCD_Series_L_gpu(L2_I, fk);
 T3 = EE456_ABCD_Shunt_L_gpu(L3_I, fk);
 T4 = EE456_ABCD_Shunt_C_gpu(C4_I, fk);
 T5 = EE456_ABCD_Series_C_gpu(C5_I, fk);
 T6 = EE456_ABCD_Shunt_L_gpu(L6_I, fk);
 T = T1*T2*T3*T4*T5*T6;
 S_IMN(kk, :, :) = ABCD_to_S(T, [Ri, Z0]);
end

%% Extract S-parameters with Z0 termination
S11_IMN = S_IMN(:, 1, 1);
S11_IMN_Mag = abs(S11_IMN);
S11_IMN_dB = 20*log10(S11_IMN_Mag);
S21_IMN = S_IMN(:, 2, 1);
S21_IMN_Mag = abs(S21_IMN);
S21_IMN_dB = 20*log10(S21_IMN_Mag);
S11_IMN_fx_dB = S11_IMN_dB(I_fx);
S21_IMN_fx_dB = S21_IMN_dB(I_fx);

%% Implement Capactive Transformer - Using Ryan's approach
nT = sqrt(Z0/RTp_I);
CP = C4_I;
CS = C5_I;
CC = (1/nT)*((nT-1)*CS+(nT*CP));
CB = (1/nT)*CS;
CA = (1/nT^2)*((1-nT)*CS);
LZ = (nT^2)*L6_I;

%% Update components with transformer values
C6_I = CA;
C5_I = CB;
C4_I = CC;
L7_I = LZ;

%% Print transformer values
Print_Break();
Print_Real('nT', nT);
Print_Real('CS/(CP+CS)', (CS/(CP+CS)));
Print_Real_Unit('CA', CA, 'F');
Print_Real_Unit('CB', CB, 'F');
Print_Real_Unit('CC', CC, 'F');
Print_Real_Unit('LZ', LZ, 'H');
Print_Break();
Print_Real_Unit('Ri', Ri, 'Ohms');
Print_Real_Unit('Ci', Ci, 'F');
Print_Real_Unit('C1', C1_I, 'F');
Print_Real_Unit('L2', L2_I, 'H');
Print_Real_Unit('L3', L3_I, 'H');
Print_Real_Unit('C4', C4_I, 'F');
Print_Real_Unit('C5', C5_I, 'F');
Print_Real_Unit('C6', C6_I, 'F');
Print_Real_Unit('L7', L7_I, 'H');
Print_Real_Unit('Z0', Z0, 'Ohms');

%% Account for transistor parasitics - Using Ryan's approach
Ci1 = ((1/C1_I) - (1/Ci))^-1;
Li2 = L2_I - Li;
Li3 = L3_I;
Ci4 = C4_I;
Ci5 = C5_I;
Ci6 = C6_I;
Li7 = L7_I;

%% Evaluate network with parasitics
j = 1j;
for kk = 1 : N_Freq
 fk = freq(kk);
 sk = j*2*pi*fk;
 Zp1 = Ri+(1/(Ci*sk))+Li*sk;
 
 T1 = EE456_ABCD_Series_C_gpu(Ci1, fk);
 T2 = EE456_ABCD_Series_L_gpu(Li2, fk);
 T3 = EE456_ABCD_Shunt_L_gpu(Li3, fk);
 T4 = EE456_ABCD_Shunt_C_gpu(Ci4, fk);
 T5 = EE456_ABCD_Series_C_gpu(Ci5, fk);
 T6 = EE456_ABCD_Shunt_C_gpu(Ci6, fk);
 T7 = EE456_ABCD_Shunt_L_gpu(Li7, fk);
 T = T1*T2*T3*T4*T5*T6*T7;  % Use proper matrix multiplication
 
 S_IMN(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
end

%% Extract S-parameters with parasitics
S11_IMN = S_IMN(:, 1, 1);
S11_IMN_Mag = abs(S11_IMN);
S11_IMN_dB = 20*log10(S11_IMN_Mag);
S21_IMN = S_IMN(:, 2, 1);
S21_IMN_Mag = abs(S21_IMN);
S21_IMN_dB = 20*log10(S21_IMN_Mag);
S11_IMN_fx_dB = S11_IMN_dB(I_fx);
S21_IMN_fx_dB = S21_IMN_dB(I_fx);

%% Print final IMN component values
Print_Break();
Print_Real_Unit('Ci1', Ci1, 'F');
Print_Real_Unit('Li2', Li2, 'H');
Print_Real_Unit('Li3', Li3, 'H');
Print_Real_Unit('Ci4', Ci4, 'F');
Print_Real_Unit('Ci5', Ci5, 'F');
Print_Real_Unit('Ci6', Ci6, 'F');
Print_Real_Unit('Li7', Li7, 'H');
Print_Break();

%% Plot IMN Results
figure(1);
plot(freq/G, S21_IMN_dB, 'r', 'linewidth', 4);
hold on;
plot(freq/G, -IL_dB_I, 'g', 'linewidth', 2);
plot(fx/G, S21_IMN_fx_dB, 'ro', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, -8, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = -8:0.5:0;
ax.YAxis.MinorTickValues = -8:0.25:0;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{21} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' | {\itS}_{21} |', ' - {\itIL}', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('IMN S21 vs Frequency');

figure(2);
plot(freq/G, S21_IMN_dB, 'r', 'linewidth', 4);
hold on;
plot(freq/G, S11_IMN_dB, 'b', 'linewidth', 4);
plot(fx/G, S21_IMN_fx_dB, 'ro', 'linewidth', 6);
plot(fx/G, S11_IMN_fx_dB, 'bo', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, -25, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.25:f_max/G;
ax.YTick = -25:5:0;
ax.YAxis.MinorTickValues = -25:2.5:0;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{\itjk} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' {\itS}_{21}', ' {\itS}_{11}', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('IMN S-Parameters');

%% ========== OUTPUT MATCHING NETWORK (OMN) ==========
%% OMN Parameters
NS_o = 0;              % Flat response for OMN
IL_min_dB_o = 0.1;
Ripple_o = 0.1;
IL_max_dB_o = IL_min_dB_o + Ripple_o;

%% OMN Frequency parameters
w0_o = 2*pi*f0;
wH_o = 2*pi*fH;
wL_o = 2*pi*fL;
BW_w_o = 2*pi*BW_f;
Delta_o = BW_f/f0;

%% OMN Frequency vector
freq_o = f_min:df:f_max;
fx_o = [fL, f0, fH];
freq_o = union(freq_o, fx_o);
freq_o = sort(freq_o);
I_fx_o = ismember(freq_o, fx_o);
N_Freq_o = length(freq_o);
S_OMN_o = zeros(N_Freq_o, 2, 2);

%% OMN Insertion Loss parameters
N_Poly_o = (1/2)*(NE - 1);
IL_max_o = 10^(IL_max_dB_o/10);
IL_min_o = 10^(IL_min_dB_o/10);
k0_o = IL_min_o;
kT_o = IL_max_o - k0_o;

%% Print OMN Design Parameters
Print_Title('Network Synthesis - OMN - Design 3');
Print_Real_Unit('f0', f0, 'Hz');
Print_Real_Unit('BW_f', BW_f, 'Hz');
Print_Real_Unit('Ri', Ri, 'Ohms');
Print_Real_Unit('Ci', Ci, 'F');
Print_Real_Unit('Li', Li, 'H');
Print_Real_Unit('Ro', Ro, 'Ohms');
Print_Real_Unit('Co', Co, 'F');
Print_Real_Unit('Lo', Lo, 'H');
Print_Real('NE', NE, 'Reactive Elements');
Print_Real('N_Poly', N_Poly_o, 'Order Chebyshev');
Print_Real('NS', NS_o, 'Slope Parameter');
Print_Real_Unit('fL', fL, 'Hz');
Print_Real_Unit('fH', fH, 'Hz');
Print_Break();
Print_Real2('w0', w0, 'rad/s');
Print_Real('w0', w0/w0, 'w0');
Print_Real2('BW_w', BW_w, 'rad/s');
Print_Real('BW_w', BW_w/w0, 'w0');
Print_Real2('wL', wL, 'rad/s');
Print_Real('wL', wL/w0, 'w0');
Print_Real2('wH', wH, 'rad/s');
Print_Real('wH', wH/w0, 'w0');
Print_Break();
Print_Real('IL_min', IL_min_dB_o, 'dB');
Print_Real('Ripple', Ripple_o, 'dB');
Print_Real('IL_max', IL_max_dB_o, 'dB');
Print_Real('k0', k0_o);
Print_Real('kT', kT_o);
Print_Break();

%% Generate OMN Insertion Loss Function
[IL_num_o, IL_den_o, R2_num_o, R2_den_o] = EE456_IL_Function_f0(fL, fH, k0_o, kT_o, N_Poly_o, NS_o);
sz2_o = roots(R2_num_o);
sz_o = sz2_o(real(sz2_o) < 0);
sp2_o = roots(R2_den_o);
sp_o = sp2_o(real(sp2_o) < 0);

%% Print OMN Polynomials
Print_Break();
EE456_Print_Poly('IL_num_o', 'IL_den_o', IL_num_o, IL_den_o);
Print_Break();
EE456_Print_Poly('R2_num_o', 'R2_den_o', R2_num_o, R2_den_o);
Print_Break();

%% Print OMN Zeros and Poles
Print_Rect('sz2_o', sz2_o, 'rad/s');
Print_Rect('sp2_o', sp2_o, 'rad/s');
Print_Break();
Print_Rect('sz_o', sz_o, 'rad/s');
Print_Rect('sp_o', sp_o, 'rad/s');
Print_Break();

%% Calculate OMN Insertion Loss Values
f_f0_o = freq_o/f0;
w_w0_o = f_f0_o;
s_o = 1j*w_w0_o;
IL_o = polyval(IL_num_o, s_o) ./ polyval(IL_den_o, s_o);
IL_dB_o = 10*log10(abs(IL_o));

%% Generate OMN Impedance Function
R_Sign_o = 1;
[Z_num_o, Z_den_o, R_num_o, R_den_o] = EE456_Z_Function(sz_o, sp_o, R_Sign_o);

%% OMN Network Synthesis - Following Ryan's order
Print_Break();
Print_Real('R_Sign_o', R_Sign_o);
EE456_Print_Poly('R_num_o', 'R_den_o', abs(R_num_o), R_den_o);
Print_Break();
EE456_Print_Poly('Z_num_o', 'Z_den_o', Z_num_o, Z_den_o);
Print_Break();

[C1_o, Z_num_o, Z_den_o] = EE456_Series_C_Synthesis(Z_num_o, Z_den_o, 1);
Print_Break();
[L2_o, Z_num_o, Z_den_o] = EE456_Series_L_Synthesis(Z_num_o, Z_den_o, 1);
Print_Break();
[C3_o, Z_num_o, Z_den_o] = EE456_Shunt_C_Synthesis(Z_num_o, Z_den_o, 1);
Print_Break();
[L4_o, Z_num_o, Z_den_o] = EE456_Series_L_Synthesis(Z_num_o, Z_den_o, 1);
Print_Break();
[L5_o, Z_num_o, Z_den_o] = EE456_Shunt_L_Synthesis(Z_num_o, Z_den_o, 1);
Print_Break();
[C6_o, Z_num_o, Z_den_o] = EE456_Series_C_Synthesis(Z_num_o, Z_den_o, 1);
Print_Break();
R7_o = Z_num_o / Z_den_o;

%% Print OMN Normalized Component Values
Print_Break();
Print_Real_Unit('C1_o', C1_o, 'F');
Print_Real_Unit('L2_o', L2_o, 'H');
Print_Real_Unit('C3_o', C3_o, 'F');
Print_Real_Unit('L4_o', L4_o, 'H');
Print_Real_Unit('L5_o', L5_o, 'H');
Print_Real_Unit('C6_o', C6_o, 'F');
Print_Real_Unit('RTp', RTp, 'Ohms');
Print_Break();

%% Evaluate OMN S-parameters
for kk_o = 1 : N_Freq_o
    fk_o = freq_o(kk_o);
    T1_o = EE456_ABCD_Series_C(C1_o, fk_o);
    T2_o = EE456_ABCD_Series_L(L2_o, fk_o);
    T3_o = EE456_ABCD_Shunt_C(C3_o, fk_o);
    T4_o = EE456_ABCD_Series_L(L4_o, fk_o);
    T5_o = EE456_ABCD_Shunt_L(L5_o, fk_o);
    T6_o = EE456_ABCD_Series_C(C6_o, fk_o);
    T_o = T1_o*T2_o*T3_o*T4_o*T5_o*T6_o;  % Use proper matrix multiplication
    S_OMN_o(kk_o, :, :) = ABCD_to_S(T_o, [Ro, RTp_o]);
end

%% Extract OMN S-parameters
S11_OMN = S_OMN_o(:, 1, 1);
S11_OMN_Mag = abs(S11_OMN);
S11_OMN_dB = 20*log10(S11_OMN_Mag);
S21_OMN = S_OMN_o(:, 2, 1);
S21_OMN_Mag = abs(S21_OMN);
S21_OMN_dB = 20*log10(S21_OMN_Mag);
S11_OMN_fx_dB = S11_OMN_dB(I_fx_o);
S21_OMN_fx_dB = S21_OMN_dB(I_fx_o);

%% Plot OMN S21 vs -IL
figure(3);
plot(freq_o/G, S21_OMN_dB, 'r', 'linewidth', 4);
hold on;
plot(freq_o/G, -IL_dB_o, 'g', 'linewidth', 2);
plot(fx_o/G, S21_OMN_fx_dB, 'ro', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, -0.3, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = -0.3:0.05:0;
ax.YAxis.MinorTickValues = -0.3:0.025:0;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{21} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' | {\itS}_{21} |', ' - {\itIL}', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('OMN S21 vs Frequency');

%% Plot OMN S-parameters
figure(4);
plot(freq_o/G, S21_OMN_dB, 'r', 'linewidth', 4);
hold on;
plot(freq_o/G, S11_OMN_dB, 'b', 'linewidth', 4);
plot(fx_o/G, S21_OMN_fx_dB, 'ro', 'linewidth', 6);
plot(fx_o/G, S11_OMN_fx_dB, 'bo', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, -25, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.25:f_max/G;
ax.YTick = -25:5:0;
ax.YAxis.MinorTickValues = -25:2.5:2;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{\itjk} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' {\itS}_{21}', ' {\itS}_{11}', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('OMN S-Parameters');

%% Recalculate with Z0 termination
for kk = 1:N_Freq
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C(C1_o, fk);
 T2 = EE456_ABCD_Series_L(L2_o, fk);
 T3 = EE456_ABCD_Shunt_C(C3_o, fk);
 T4 = EE456_ABCD_Series_L(L4_o, fk);
 T5 = EE456_ABCD_Shunt_L(L5_o, fk);
 T6 = EE456_ABCD_Series_C(C6_o, fk);
 T = T1*T2*T3*T4*T5*T6;
 S_OMN_o(kk, :, :) = ABCD_to_S(T, [Ro, Z0]);
end

%% Re-extract S-parameters with Z0 termination
S11_OMN = S_OMN_o(:, 1, 1);
S11_OMN_Mag = abs(S11_OMN);
S11_OMN_dB = 20*log10(S11_OMN_Mag);
S21_OMN = S_OMN_o(:, 2, 1);
S21_OMN_Mag = abs(S21_OMN);
S21_OMN_dB = 20*log10(S21_OMN_Mag);
S11_OMN_fx_dB = S11_OMN_dB(I_fx);
S21_OMN_fx_dB = S21_OMN_dB(I_fx);

%% Implement inductive transformer for OMN - Following Ryan's approach
nT = sqrt(Z0/RTp_o);
LP = L5_o;
LS = L4_o;
LA = nT*(nT-1)*LP;
LB = nT*LP;
LC = (1-nT)*LP + LS;
CZ = (1/nT^2)*C6_o;

%% Update OMN components with transformer values
L6_o = LA;
L5_o = LB;
L4_o = LC;
C7_o = CZ;

%% Print OMN transformer values
Print_Break();
Print_Real('nT', nT);
Print_Real('(LP+LS)/LP', (LP+LS)/LP);
Print_Real_Unit('LA', LA, 'H');
Print_Real_Unit('LB', LB, 'H');
Print_Real_Unit('LC', LC, 'H');
Print_Real_Unit('CZ', CZ, 'F');
Print_Break();
Print_Real_Unit('Ro', Ro, 'Ohms');
Print_Real_Unit('Co', Co, 'F');
Print_Real_Unit('C1', C1_o, 'F');
Print_Real_Unit('L2', L2_o, 'H');
Print_Real_Unit('C3', C3_o, 'F');
Print_Real_Unit('L4', L4_o, 'H');
Print_Real_Unit('L5', L5_o, 'H');
Print_Real_Unit('L6', L6_o, 'H');
Print_Real_Unit('C7', C7_o, 'F');
Print_Real_Unit('Z0', Z0, 'Ohms');

%% Account for transistor parasitics in OMN
Co1 = ((1/C1_o) - (1/Co))^-1;
Lo2 = L2_o - Lo;
Co3 = C3_o;
Lo4 = L4_o;
Lo5 = L5_o;
Lo6 = L6_o;
Co7 = C7_o;

%% Evaluate OMN with parasitics
j = 1j;
for kk = 1:N_Freq
 fk = freq(kk);
 sk = j*2*pi*fk;
 Zp1 = Ro+(1/(Co*sk))+Lo*sk;
 
 T1 = EE456_ABCD_Series_C(Co1, fk);
 T2 = EE456_ABCD_Series_L(Lo2, fk);
 T3 = EE456_ABCD_Shunt_C(Co3, fk);
 T4 = EE456_ABCD_Series_L(Lo4, fk);
 T5 = EE456_ABCD_Shunt_L(Lo5, fk);
 T6 = EE456_ABCD_Series_L(Lo6, fk);
 T7 = EE456_ABCD_Series_C(Co7, fk);
 T = T1*T2*T3*T4*T5*T6*T7;  % Use proper matrix multiplication
 
 S_OMN_o(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
end

%% Extract S-parameters for OMN with parasitics
S11_OMN = S_OMN_o(:, 1, 1);
S11_OMN_Mag = abs(S11_OMN);
S11_OMN_dB = 20*log10(S11_OMN_Mag);
S21_OMN = S_OMN_o(:, 2, 1);
S21_OMN_Mag = abs(S21_OMN);
S21_OMN_dB = 20*log10(S21_OMN_Mag);
S11_OMN_fx_dB = S11_OMN_dB(I_fx);
S21_OMN_fx_dB = S21_OMN_dB(I_fx);

%% Print final OMN component values with parasitics
Print_Break();
Print_Real_Unit('Co1', Co1, 'F');
Print_Real_Unit('Lo2', Lo2, 'H');
Print_Real_Unit('Co3', Co3, 'F');
Print_Real_Unit('Lo4', Lo4, 'H');
Print_Real_Unit('Lo5', Lo5, 'H');
Print_Real_Unit('Lo6', Lo6, 'H');
Print_Real_Unit('Co7', Co7, 'F');
Print_Break();

%% Plot final OMN S-parameters with parasitics
figure(5);
plot(freq/G, S21_OMN_dB, 'r', 'linewidth', 4);
hold on;
plot(freq/G, S11_OMN_dB, 'b', 'linewidth', 4);
plot(fx/G, S21_OMN_fx_dB, 'ro', 'linewidth', 6);
plot(fx/G, S11_OMN_fx_dB, 'bo', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, -25, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.25:f_max/G;
ax.YTick = -25:5:0;
ax.YAxis.MinorTickValues = -25:2.5:2;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{\itjk} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' {\itS}_{21}', ' {\itS}_{11}', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('OMN S-Parameters with Parasitics');

%% ========== COMPLETE AMPLIFIER SIMULATION ==========
%% Read transistor S-parameters
[freq_FET, S_FET, Mult] = Read_SParam_s2p('NE321000.s2p');
freq_FET = freq_FET * Mult;

%% Define key frequencies for FET
fL_FET = 10*G;
fH_FET = 20*G;
f0_FET = sqrt(fL_FET*fH_FET);
fx_FET = [fL_FET, f0_FET, fH_FET];

%% Create frequency vector for amplifier
freq_Amp = f_min:df:f_max;
freq_Amp = union(freq_Amp, fx_FET);
freq_Amp = sort(freq_Amp);
I_fx_Amp = ismember(freq_Amp, fx_FET);
I_f0_Amp = ismember(freq_Amp, f0_FET);
N_Freq_Amp = length(freq_Amp);
S_Amp = zeros(N_Freq_Amp, 2, 2);

%% Cascade IMN + FET + OMN
for kk = 1:N_Freq_Amp
 fk = freq_Amp(kk);
 sk = j*2*pi*fk;

 % OMN ABCD matrices
 To1 = EE456_ABCD_Series_C(Co1, fk);
 To2 = EE456_ABCD_Series_L(Lo2, fk);
 To3 = EE456_ABCD_Shunt_C(Co3, fk);
 To4 = EE456_ABCD_Series_L(Lo4, fk);
 To5 = EE456_ABCD_Shunt_L(Lo5, fk);
 To6 = EE456_ABCD_Series_L(Lo6, fk);
 To7 = EE456_ABCD_Series_C(Co7, fk);
 T_OMN = To1*To2*To3*To4*To5*To6*To7;  % Use proper matrix multiplication

 % IMN ABCD matrices
 Ti1 = EE456_ABCD_Series_C(Ci1, fk);
 Ti2 = EE456_ABCD_Series_L(Li2, fk);
 Ti3 = EE456_ABCD_Shunt_L(Li3, fk);
 Ti4 = EE456_ABCD_Shunt_C(Ci4, fk);
 Ti5 = EE456_ABCD_Series_C(Ci5, fk);
 Ti6 = EE456_ABCD_Shunt_C(Ci6, fk);
 Ti7 = EE456_ABCD_Shunt_L(Li7, fk);
 T_IMN = Ti7*Ti6*Ti5*Ti4*Ti3*Ti2*Ti1;  % Use proper matrix multiplication

 % FET S-parameters interpolated to current frequency
 Sx = S_Param_Interp(S_FET, freq_FET, fk);
 TFET = S_to_ABCD(Sx, Z0);

 % Cascade all networks
 T = T_IMN*TFET*T_OMN;
 S_Amp(kk, :, :) = ABCD_to_S(T, Z0);
end

%% Extract S-parameters for complete amplifier
S11_Amp = S_Amp(:, 1, 1);
S11_Amp_Mag = abs(S11_Amp);
S11_Amp_dB = 20*log10(S11_Amp_Mag);
S21_Amp = S_Amp(:, 2, 1);
S21_Amp_Mag = abs(S21_Amp);
S21_Amp_dB = 20*log10(S21_Amp_Mag);
S22_Amp = S_Amp(:, 2, 2);
S22_Amp_Mag = abs(S22_Amp);
S22_Amp_dB = 20*log10(S22_Amp_Mag);
S12_Amp = S_Amp(:, 1, 2);
S12_Amp_Mag = abs(S12_Amp);
S12_Amp_dB = 20*log10(S12_Amp_Mag);

%% Extract values at center frequency
S_Amp_f0(1:2, 1:2) = S_Amp(I_f0_Amp, :, :);
S11_Amp_f0 = S11_Amp(I_f0_Amp);
S11_Amp_f0_dB = S11_Amp_dB(I_f0_Amp);
S21_Amp_f0 = S21_Amp(I_f0_Amp);
S21_Amp_f0_dB = S21_Amp_dB(I_f0_Amp);
S22_Amp_f0 = S22_Amp(I_f0_Amp);
S22_Amp_f0_dB = S22_Amp_dB(I_f0_Amp);
S12_Amp_f0 = S12_Amp(I_f0_Amp);
S12_Amp_f0_dB = S12_Amp_dB(I_f0_Amp);
S21_Amp_f0_Mag = abs(S21_Amp_f0);

%% Extract values at key frequencies
S11_Amp_fx_dB = S11_Amp_dB(I_fx_Amp);
S12_Amp_fx_dB = S12_Amp_dB(I_fx_Amp);
S21_Amp_fx_dB = S21_Amp_dB(I_fx_Amp);
S22_Amp_fx_dB = S22_Amp_dB(I_fx_Amp);

%% Print S-parameters at center frequency
Print_Polar('S11_Amp', S11_Amp_f0);
Print_Polar('S21_Amp', S21_Amp_f0);
Print_Polar('S12_Amp', S12_Amp_f0);
Print_Polar('S22_Amp', S22_Amp_f0);

%% Plot S21 gain
figure(6);
plot(freq_Amp/G, S21_Amp_dB, 'r', 'linewidth', 4);
hold on;
plot(fx_FET/G, S21_Amp_fx_dB, 'ro', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, 6, 9]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = 6:0.5:9;
ax.YAxis.MinorTickValues = 6:0.25:9;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{21} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' {\itS}_{21}', 'Key Points', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('Amplifier Gain (S21)');

%% Plot S11 return loss
figure(7);
plot(freq_Amp/G, S11_Amp_dB, 'r', 'linewidth', 4);
hold on;
plot(fx_FET/G, S11_Amp_fx_dB, 'ro', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, -25, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = -25:2.5:0;
ax.YAxis.MinorTickValues = -25:1.25:0;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{11} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' {\itS}_{11}', 'Key Points', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('Input Return Loss (S11)');

%% Plot S22 return loss
figure(8);
plot(freq_Amp/G, S22_Amp_dB, 'r', 'linewidth', 4);
hold on;
plot(fx_FET/G, S22_Amp_fx_dB, 'ro', 'linewidth', 6);
hold off;
grid on;
grid minor;
axis([f_min/G, f_max/G, -25, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = -25:2.5:0;
ax.YAxis.MinorTickValues = -25:1.25:0;
xlabel('{\itf}   (GHz)  ');
ylabel(' | {\itS}_{22} |   ( dB ) ', 'VerticalAlignment', 'bottom');
legend(' {\itS}_{22}', 'Key Points', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);
title('Output Return Loss (S22)');

%% ========== COMPARE TO ADS RESULTS ==========
%% Read ADS S-parameters
[freq_ADS, S_ADS, Mult_ADS] = Read_SParam_s2p('NE321000.s2p');
freq_ADS = freq_ADS * Mult_ADS;

%% Find indices for key frequencies
I_f0_ADS = find(freq_ADS == f0_FET);
I_fH_ADS = find(freq_ADS == fH);
I_fL_ADS = find(freq_ADS == fL_FET);

%% Extract ADS S-parameters
S11_ADS = S_ADS(:, 1, 1);
S11_ADS_Mag = abs(S11_ADS);
S11_ADS_dB = 20*log10(S11_ADS_Mag);
S21_ADS = S_ADS(:, 2, 1);
S21_ADS_Mag = abs(S21_ADS);
S21_ADS_dB = 20*log10(S21_ADS_Mag);
S22_ADS = S_ADS(:, 2, 2);
S22_ADS_Mag = abs(S22_ADS);
S22_ADS_dB = 20*log10(S22_ADS_Mag);
S12_ADS = S_ADS(:, 1, 2);
S12_ADS_Mag = abs(S12_ADS);
S12_ADS_dB = 20*log10(S12_ADS_Mag);

%% Extract values at key frequencies
if ~isempty(I_fH_ADS)
    S_ADS_fH(1:2, 1:2) = S_ADS(I_fH_ADS, :, :);
    S11_ADS_fH = S11_ADS(I_fH_ADS);
    S11_ADS_fH_dB = S11_ADS_dB(I_fH_ADS);
    S21_ADS_fH = S21_ADS(I_fH_ADS);
    S21_ADS_fH_dB = S21_ADS_dB(I_fH_ADS);
    S12_ADS_fH = S12_ADS(I_fH_ADS);
    S12_ADS_fH_dB = S12_ADS_dB(I_fH_ADS);
    S22_ADS_fH = S22_ADS(I_fH_ADS);
    S22_ADS_fH_dB = S22_ADS_dB(I_fH_ADS);
end

if ~isempty(I_fL_ADS)
    S_ADS_fL(1:2, 1:2) = S_ADS(I_fL_ADS, :, :);
    S11_ADS_fL = S11_ADS(I_fL_ADS);
    S11_ADS_fL_dB = S11_ADS_dB(I_fL_ADS);
    S21_ADS_fL = S21_ADS(I_fL_ADS);
    S21_ADS_fL_dB = S21_ADS_dB(I_fL_ADS);
    S12_ADS_fL = S12_ADS(I_fL_ADS);
    S12_ADS_fL_dB = S12_ADS_dB(I_fL_ADS);
    S22_ADS_fL = S22_ADS(I_fL_ADS);
    S22_ADS_fL_dB = S22_ADS_dB(I_fL_ADS);
end

%% Plot ADS S21 Comparison
figure(9);
plot(freq_ADS/G, S21_ADS_dB, 'r', 'linewidth', 4);
hold on;
if ~isempty(I_fL_ADS)
    plot(fL_FET/G, S11_ADS_fL_dB, 'rd', 'linewidth', 6);
end
plot(fx_FET/G, S11_Amp_fx_dB, 'bo', 'linewidth', 4);
hold off;
grid on;
grid minor;
xlabel('{\it f} (GHz)');
ylabel('| {\it S}_{11} | (dB)');
title('Comparison of |S_{11}| from ADS and MATLAB');
legend('ADS', 'MATLAB', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
axis([f_min/G, f_max/G, -25, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = -25:2.5:0;
ax.YAxis.MinorTickValues = -25:1.25:0;
set(gca, 'linewidth', 2.5);

%% Plot ADS vs MATLAB S22 Comparison
figure(12);
plot(freq_ADS/G, S22_ADS_dB, 'r', 'linewidth', 4);
hold on;
plot(freq_Amp/G, S22_Amp_dB, 'b', 'linewidth', 2);
if ~isempty(I_fL_ADS)
    plot(fL_FET/G, S22_ADS_fL_dB, 'rd', 'linewidth', 6);
end
if ~isempty(I_fH_ADS)
    plot(fH/G, S22_ADS_fH_dB, 'rd', 'linewidth', 6);
end
plot(fx_FET/G, S22_Amp_fx_dB, 'bo', 'linewidth', 4);
hold off;
grid on;
grid minor;
xlabel('{\it f} (GHz)');
ylabel('| {\it S}_{22} | (dB)');
title('Comparison of |S_{22}| from ADS and MATLAB');
legend('ADS', 'MATLAB', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
axis([f_min/G, f_max/G, -25, 0]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = -25:2.5:0;
ax.YAxis.MinorTickValues = -25:1.25:0;
set(gca, 'linewidth', 2.5);

%% Calculate performance metrics
fprintf('\nPerformance Metrics:\n');
fprintf('---------------------\n');

% Find band indices
band_idx = (freq_Amp >= fL) & (freq_Amp <= fH);
f_band = freq_Amp(band_idx);

% S11 metrics
S11_band = S11_Amp(band_idx);
S11_band_dB = 20*log10(abs(S11_band));
S11_worst = max(S11_band_dB);
S11_best = min(S11_band_dB);
S11_avg = mean(S11_band_dB);

fprintf('S11 worst in band: %.2f dB\n', S11_worst);
fprintf('S11 best in band: %.2f dB\n', S11_best);
fprintf('S11 average in band: %.2f dB\n', S11_avg);

% S21 metrics
S21_band = S21_Amp(band_idx);
S21_band_dB = 20*log10(abs(S21_band));
S21_min = min(S21_band_dB);
S21_max = max(S21_band_dB);
S21_avg = mean(S21_band_dB);
S21_flatness = S21_max - S21_min;

fprintf('S21 min in band: %.2f dB\n', S21_min);
fprintf('S21 max in band: %.2f dB\n', S21_max);
fprintf('S21 average in band: %.2f dB\n', S21_avg);
fprintf('S21 flatness in band: %.2f dB\n', S21_flatness);

% S22 metrics
S22_band = S22_Amp(band_idx);
S22_band_dB = 20*log10(abs(S22_band));
S22_worst = max(S22_band_dB);
S22_best = min(S22_band_dB);
S22_avg = mean(S22_band_dB);

fprintf('S22 worst in band: %.2f dB\n', S22_worst);
fprintf('S22 best in band: %.2f dB\n', S22_best);
fprintf('S22 average in band: %.2f dB\n', S22_avg);

% Check slope requirements
if length(f_band) >= 2
    % Calculate slope at octave points if possible
    f_low_idx = find(f_band >= 9*G, 1);
    f_high_idx = find(f_band <= 18*G, 1, 'last');
    
    if ~isempty(f_low_idx) && ~isempty(f_high_idx)
        S21_9GHz = S21_band_dB(f_low_idx);
        S21_18GHz = S21_band_dB(f_high_idx);
        slope_per_octave = S21_9GHz - S21_18GHz;
        fprintf('S21 slope: %.2f dB/octave (target: 6 dB/octave)\n', slope_per_octave);
    else
        fprintf('Cannot calculate slope - insufficient frequency points\n');
    end
else
    fprintf('Cannot calculate slope - insufficient frequency points\n');
end

% Print main component values for quick reference
fprintf('\nKey Component Values:\n');
fprintf('---------------------\n');
fprintf('IMN Components:\n');
fprintf('C1 = %.2f fF\n', Ci1*1e15);
fprintf('L2 = %.2f pH\n', Li2*1e12);
fprintf('L3 = %.2f pH\n', Li3*1e12);
fprintf('C4 = %.2f fF\n', Ci4*1e15);
fprintf('C5 = %.2f fF\n', Ci5*1e15);
fprintf('C6 = %.2f fF\n', Ci6*1e15);
fprintf('L7 = %.2f pH\n', Li7*1e12);

fprintf('\nOMN Components:\n');
fprintf('C1 = %.2f fF\n', Co1*1e15);
fprintf('L2 = %.2f pH\n', Lo2*1e12);
fprintf('C3 = %.2f fF\n', Co3*1e15);
fprintf('L4 = %.2f pH\n', Lo4*1e12);
fprintf('L5 = %.2f pH\n', Lo5*1e12);
fprintf('L6 = %.2f pH\n', Lo6*1e12);
fprintf('C7 = %.2f fF\n', Co7*1e15);

%% Checking the solution
% Calculate reflection coefficient at key frequencies
G_in = zeros(size(freq_Amp));
G_out = zeros(size(freq_Amp));

% Calculate reflection coefficient at each frequency
for i = 1:length(freq_Amp)
    G_in(i) = abs(S11_Amp(i))^2;
    G_out(i) = abs(S22_Amp(i))^2;
end

% Find minimum VSWR in band
VSWR_in = (1 + sqrt(G_in)) ./ (1 - sqrt(G_in));
VSWR_out = (1 + sqrt(G_out)) ./ (1 - sqrt(G_out));

VSWR_in_band = VSWR_in(band_idx);
VSWR_out_band = VSWR_out(band_idx);

VSWR_in_min = min(VSWR_in_band);
VSWR_in_max = max(VSWR_in_band);
VSWR_out_min = min(VSWR_out_band);
VSWR_out_max = max(VSWR_out_band);

fprintf('\nVSWR Metrics:\n');
fprintf('-------------\n');
fprintf('Input VSWR min: %.2f\n', VSWR_in_min);
fprintf('Input VSWR max: %.2f\n', VSWR_in_max);
fprintf('Output VSWR min: %.2f\n', VSWR_out_min);
fprintf('Output VSWR max: %.2f\n', VSWR_out_max);

% Check for stability
k_factor = zeros(size(freq_Amp));
delta = zeros(size(freq_Amp));

for i = 1:length(freq_Amp)
    S11 = S_Amp(i,1,1);
    S12 = S_Amp(i,1,2);
    S21 = S_Amp(i,2,1);
    S22 = S_Amp(i,2,2);
    
    delta(i) = S11*S22 - S12*S21;
    k_factor(i) = (1 - abs(S11)^2 - abs(S22)^2 + abs(delta(i))^2) / (2*abs(S12*S21));
end

k_min = min(k_factor);
delta_max = max(abs(delta));

fprintf('\nStability Metrics:\n');
fprintf('-----------------\n');
fprintf('Minimum k factor: %.4f (>1 for unconditional stability)\n', k_min);
fprintf('Maximum |delta|: %.4f (<1 for stability)\n', delta_max);
if k_min > 1 && delta_max < 1
    fprintf('Amplifier is UNCONDITIONALLY STABLE across all frequencies\n');
else
    fprintf('Amplifier may be CONDITIONALLY STABLE or UNSTABLE at some frequencies\n');
end

%% Plot stability factors
figure(13);
plot(freq_Amp/G, k_factor, 'b', 'linewidth', 2);
hold on;
plot([f_min/G, f_max/G], [1, 1], 'r--', 'linewidth', 1.5);
plot('S21_ADS_fL_dB', 'bd', 'linewidth', 6);
hold off;
grid on;
grid minor;
xlabel('Frequency (GHz)');
ylabel('Stability Factor (k)');
title('Amplifier Stability Factor');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
set(gca, 'linewidth', 2.5);


if ~isempty(I_fH_ADS)
    plot(fH/G, S21_ADS_fH_dB, 'bs', 'linewidth', 6);
end
hold off;
grid on;
grid minor;
xlabel('{\it f} (GHz)');
ylabel('| {\it S}_{21} | (dB)');
title('|S_{21}| from ADS');
legend('ADS', 'fL', 'fH', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
axis([f_min/G, f_max/G, 6, 9]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = 6:0.5:9;
ax.YAxis.MinorTickValues = 6:0.25:9;
set(gca, 'linewidth', 2.5);

%% Plot ADS vs MATLAB S21 Comparison
figure(10);
plot(freq_ADS/G, S21_ADS_dB, 'r', 'linewidth', 4);
hold on;
plot(freq_Amp/G, S21_Amp_dB, 'b', 'linewidth', 2);
if ~isempty(I_fL_ADS)
    plot(fL_FET/G, S21_ADS_fL_dB, 'rd', 'linewidth', 6);
end
if ~isempty(I_fH_ADS)
    plot(fH/G, S21_ADS_fH_dB, 'rd', 'linewidth', 6);
end
plot(fx_FET/G, S21_Amp_fx_dB, 'bo', 'linewidth', 4);
hold off;
grid on;
grid minor;
xlabel('{\it f} (GHz)');
ylabel('| {\it S}_{21} | (dB)');
title('Comparison of |S_{21}| from ADS and MATLAB');
legend('ADS', 'MATLAB', 'location', 'best');
set(gca, 'FontName', 'times new roman', 'FontSize', 24);
axis([f_min/G, f_max/G, 6, 9]);
ax = gca;
ax.XTick = f_min/G:1:f_max/G;
ax.XAxis.MinorTickValues = f_min/G:0.5:f_max/G;
ax.YTick = 6:0.5:9;
ax.YAxis.MinorTickValues = 6:0.25:9;
set(gca, 'linewidth', 2.5);

%% Plot ADS vs MATLAB S11 Comparison
figure(11);
plot(freq_ADS/G, S11_ADS_dB, 'r', 'linewidth', 4);
hold on;
plot(freq_Amp/G, S11_Amp_dB, 'b', 'linewidth', 2);
if ~isempty(I_fH_ADS)
    plot(fH/G, S11_ADS_fH_dB, 'rd', 'linewidth', 6);
end
if ~isempty(I_fL_ADS)
    plot(fL_FET/G, 'kk', 'linewidth', 8);
end
Print_Real_Unit('L5_o', L5_o, 'H');
Print_Real_Unit('C6_o', C6_o, 'F');
Print_Real_Unit('R7_o', R7_o, 'Ohms');
Print_Break();

%% Denormalize OMN Components
C1_o = C1_o/(w0_o*Ro);
L2_o = (L2_o/w0_o)*Ro;
C3_o = C3_o/(w0_o*Ro);
L4_o = (L4_o/w0_o)*Ro;
L5_o = (L5_o/w0_o)*Ro;
C6_o = C6_o/(w0_o*Ro);
RTp_o = R7_o*Ro;

%% Print OMN Denormalized Component Values
Print_Break();
Print_Real_Unit('Ro', Ro, 'Ohms');
Print_Real_Unit('Co', Co, 'F');
Print_Real_Unit('fH', fH, 'Hz');
Print_Real_Unit('f0', f0, 'Hz');
Print_Real_Unit('fL', fL, 'Hz');
Print_Real_Unit('BW_f', BW_f, 'Hz');
Print_Break();
Print_Real_Unit('C1_o', C1_o, 'F');
Print_Real_Unit('L2_o', L2_o, 'H');
Print_Real_Unit('C3_o', C3_o, 'F');
Print_Real_Unit('L4_o', L4_o, 'H');
