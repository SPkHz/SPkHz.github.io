clc
clear
close all
%-------------------------------------------------------------------
G = 10^+9;
M = 10^+6;
K = 10^3;
m = 10^-3;
u = 10^-6;
n = 10^-9;
p = 10^-12;
f = 10^-15;
%------------------------------------------------------------------
NE = 7;
NS_I = 1;
IL_min_dB_I = 0.0;
Ripple_I = .1;
IL_max_dB_I = IL_min_dB_I + Ripple_I;
fL = 9*G;
fH = 20*G;
f0 = sqrt(fL*fH);
BW_f = fH - fL;
f_min = 8*G;
f_max = 22*G;
df = 25*M;
Ri = 23.0767;
Ci =  245.2104*f;
Li =  347.8189*p;
Ro = 44.0222;
Co = 283.0342*f;
Lo = 202.0340*p;
Z0 = 50;
NF = 32;
IFigure = 0;
%------------------------------------------------------------------
w0 = 2*pi*f0;
wH = 2*pi*fH;
wL = 2*pi*fL;
BW_w = 2*pi*BW_f;
Delta = BW_f/f0;
%-------------------------------------------------------------------
freq = f_min  : df : f_max;
fx = [fL, f0, fH];
freq = union(freq, fx);
freq = sort(freq);
I_fx = ismember(freq, fx);
N_Freq = length(freq);
S_IMN = zeros(N_Freq, 2, 2);
%-------------------------------------------------------------------
N_Poly = (1/2)*(NE-1);
IL_max_I = 10^(IL_max_dB_I/10);
IL_min_I = 10^(IL_min_dB_I/10);
k0_I = IL_min_I;
kT_I = IL_max_I - k0_I;
%-------------------------------------------------------------------
Print_Title('Network Synthesis - Design 3')
Print_Real_Unit('f0', f0, 'Hz')
Print_Real_Unit('BW_f', BW_f, 'Hz')
Print_Real_Unit('Ri', Ri, 'Ohms')
Print_Real_Unit('Ci', Ci, 'F')
Print_Real_Unit('Li', Li, 'H')
Print_Real_Unit('Ro', Ro, 'Ohms')
Print_Real_Unit('Co', Co, 'F')
Print_Real_Unit('Lo', Lo, 'H')
Print_Real('NE', NE, 'Reactive Elements')
Print_Real('N_Poly', N_Poly, 'Order Chebyshev')
Print_Real('NS', NS_I, 'Slope Parameter')
Print_Real_Unit('fL', fL, 'Hz')
Print_Real_Unit('fH', fH, 'Hz')
Print_Break
Print_Real2('w0', w0, 'rad/s')
Print_Real('w0', w0/w0, 'w0')
Print_Real2('BW_w', BW_w, 'rad/s')
Print_Real('BW_w', BW_w/w0, 'w0')
Print_Real2('wL', wL, 'rad/s')
Print_Real('wL', wL/w0, 'w0')
Print_Real2('wH', wH, 'rad/s')
Print_Real('wH', wH/w0, 'w0')
Print_Break
Print_Real('IL_min', IL_min_dB_I, 'dB')
Print_Real('Ripple', Ripple_I, 'dB')
Print_Real('IL_max', IL_max_dB_I, 'dB')
Print_Real('k0', k0_I)
Print_Real_Unit('kT', kT_I, 'W/W')
Print_Break
%-------------------------------------------------------------------
[IL_num_I, IL_den_I, R2_num_I, R2_den_I] = ...
 EE456_IL_Function_f0(fL, fH, k0_I, kT_I, N_Poly, NS_I);
sz2_I = roots(R2_num_I);
sz_I = sz2_I(real(sz2_I) < 0);
sp2_I = roots(R2_den_I);
sp_I = sp2_I(real(sp2_I) < 0 );
%-------------------------------------------------------------------
Print_Break
EE456_Print_Poly('IL_num', 'IL_den',...
 IL_num_I, IL_den_I)
Print_Break
EE456_Print_Poly('R2_num', 'R2_den',...
 R2_num_I, R2_den_I)
Print_Break
%-------------------------------------------------------------------
Print_Rect('sz2', sz2_I, 'rad/s')
Print_Rect('sp2', sp2_I, 'rad/s')
Print_Break
Print_Rect('sz', sz_I, 'rad/s')
Print_Rect('sp', sp_I, 'rad/s')
%-------------------------------------------------------------------
f_f0 = freq/f0;
w_w0 = f_f0;
s = 1j*w_w0;
IL_I = polyval(IL_num_I, s) ./ polyval(IL_den_I, s);
IL_dB_I = 10*log10( abs(IL_I) );
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq/f0, IL_dB_I, 'r', 'linewidth', 9)
hold on
plot(fx/f0, IL_dB_I(I_fx), 'ro', 'linewidth', 15)
hold off
grid on
grid minor
axis([0.6, 1.6, -.5, 8])
ax = gca;
ax.XTick = 0.6 : 0.1 : 1.6;
ax.XAxis.MinorTickValues = ...
0.6 : 0.05 : 1.6;
ax.YTick = -.5 : 0.5 : 8;
ax.YAxis.MinorTickValues = ...
-.5 : 0.25 : 8;
xlabel('{\itf} / {\itf}_{0}   ')
ylabel('{\itIL}    ( dB ) ',...
'VerticalAlignment', 'bottom')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
IFigure = IFigure + 1;
figure_max(IFigure)
zplane(sz2_I, sp2_I)
hold on
plot(real(sz2_I), imag(sz2_I), 'rd', 'linewidth', 9)
plot(real(sp2_I), imag(sp2_I), 'ro', 'linewidth', 9)
hold off
grid on
grid minor
axis([-2, 2, -2, 2])
axis square
set(gca, 'linewidth', 2)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
zplane(sz_I, sp_I)
hold on
plot(real(sz_I), imag(sz_I), 'rd', 'linewidth', 9)
plot(real(sp_I), imag(sp_I), 'ro', 'linewidth', 9)
hold off
grid on
grid minor
axis([-2, 2, -2, 2])
axis square
set(gca, 'linewidth', 2)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
%-------------------------------------------------------------------
R_Sign = 1;
[Z_num, Z_den, R_num_I, R_den_I] = ...
 EE456_Z_Function(sz_I, sp_I, R_Sign);
%-------------------------------------------------------------------
[C1_I, Z_num, Z_den] = ...
 EE456_Series_C_Synthesis(Z_num, Z_den, 1);
Print_Break
[L2_I, Z_num, Z_den] = ....
 EE456_Series_L_Synthesis(Z_num, Z_den, 1);
Print_Break
[L3_I, Z_num, Z_den] = ...
 EE456_Shunt_L_Synthesis(Z_num, Z_den, 1);
Print_Break
[C4_I, Z_num, Z_den] = ...
 EE456_Shunt_C_Synthesis(Z_num, Z_den, 1);
Print_Break
[C5_I, Z_num, Z_den] = ...
 EE456_Series_C_Synthesis(Z_num, Z_den, 1);
Print_Break
[L6_I, Z_num, Z_den] = ....
 EE456_Shunt_L_Synthesis(Z_num, Z_den, 1);
Print_Break
R7_I = Z_num / Z_den;
%-------------------------------------------------------------------
Print_Break
Print_Real_Unit('C1', C1_I, 'F')
Print_Real_Unit('L2', L2_I, 'H')
Print_Real_Unit('L3', L3_I, 'H')
Print_Real_Unit('C4', C4_I, 'F')
Print_Real_Unit('C5', C5_I, 'F')
Print_Real_Unit('L6', L6_I, 'H')
Print_Real_Unit('R7', R7_I, 'Ohms')
Print_Break
%-------------------------------------------------------------------
C1_I = C1_I/(w0*Ri);
L2_I = (L2_I/w0)*Ri;
L3_I = (L3_I/w0)*Ri;
C4_I = C4_I/(w0*Ri);
C5_I = C5_I/(w0*Ri);
L6_I = (L6_I/w0)*Ri;
RTp_I = R7_I*Ri;
%-------------------------------------------------------------------
Print_Break
Print_Real_Unit('Ri', Ri, 'Ohms')
Print_Real_Unit('Ci', Ci, 'F')
Print_Real_Unit('fH', fH, 'Hz')
Print_Real_Unit('f0', f0, 'Hz')
Print_Real_Unit('fL', fL, 'Hz')
Print_Real_Unit('BW_f', BW_f, 'Hz')
Print_Break
Print_Real_Unit('C1', C1_I, 'F')
Print_Real_Unit('L2', L2_I, 'H')
Print_Real_Unit('L3', L3_I, 'H')
Print_Real_Unit('C4', C4_I, 'F')
Print_Real_Unit('C5', C5_I, 'F')
Print_Real_Unit('L6', L6_I, 'H')
Print_Real_Unit('RTp', RTp_I, 'Ohms')
Print_Break
%-------------------------------------------------------------------
for kk = 1 : N_Freq
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C(C1_I, fk);
 T2 = EE456_ABCD_Series_L(L2_I, fk);
 T3 = EE456_ABCD_Shunt_L(L3_I, fk);
 T4 = EE456_ABCD_Shunt_C(C4_I, fk);
 T5 = EE456_ABCD_Series_C(C5_I, fk);
 T6 = EE456_ABCD_Shunt_L(L6_I, fk);
 T = T1*T2*T3*T4*T5*T6;
 S_IMN(kk, :, :) = ABCD_to_S(T, [Ri, RTp_I]);
end
%------------------------------------------------------------------
S11_IMN = S_IMN(:, 1, 1);
S11_IMN_Mag = abs(S11_IMN);
S11_IMN_dB = 20*log10(S11_IMN_Mag);
S21_IMN = S_IMN(:, 2, 1);
S21_IMN_Mag = abs(S21_IMN);
S21_IMN_dB = 20*log10(S21_IMN_Mag);
S11_IMN_fx_dB = S11_IMN_dB(I_fx);
S21_IMN_fx_dB = S21_IMN_dB(I_fx);
%-------------------------------------------------------------------
% IFigure = IFigure + 1;
% figure_max(IFigure)
% plot(freq/G,S21_IMN_dB, 'r', 'linewidth', 9)
% hold on
% plot(freq/G, -IL_dB_I, 'g', 'linewidth', 7)
% plot(fx/G, S21_IMN_fx_dB, 'ro', 'linewidth', 15)
% hold off
% grid on
% grid minor
% axis([f_min/G, f_max/G, -8, 0])
% ax = gca;
% ax.XTick = f_min/G : 1 : f_max/G;
% ax.XAxis.MinorTickValues = ...
%  f_min/G : 0.5 : f_max/G;
% ax.YTick = -8 : .5 : 0;
% ax.YAxis.MinorTickValues = ...
%     -8 : 0.25 : 0;
% xlabel('{\itf}   (GHz)  ')
% ylabel(' | {\itS}_{21} |   ( dB ) ',...
%     'VerticalAlignment', 'bottom')
% legend(...
%     ' | {\itS}_{21} |',...
%     ' - {\itIL}',...
%     'location', 'best')
% set(gca, 'FontName', 'times new roman', 'FontSize', NF)
% set(gca, 'linewidth', 2.5)
%------------------------------------------------------------------
% IFigure = IFigure + 1;
% figure_max(IFigure)
% plot(freq/G, S21_IMN_dB, 'r', 'linewidth', 9)
% hold on
% plot(freq/G, S11_IMN_dB, 'b', 'linewidth', 9)
% plot(fx/G, S21_IMN_fx_dB, 'ro', 'linewidth', 15)
% plot(fx/G, S11_IMN_fx_dB, 'bo', 'linewidth', 15)
% hold off
% grid on
% grid minor
% axis([f_min/G, f_max/G, -25, 0])
% ax = gca;
% ax.XTick = f_min/G : 1 : f_max/G;
% ax.XAxis.MinorTickValues = ...
%  f_min/G : 0.25 : f_max/G;
% ax.YTick = -25 : 5 : 0;
% ax.YAxis.MinorTickValues = ...
%      -25. : 2.5 : 2;
% xlabel('{\itf}   (GHz)  ')
% ylabel(' | {\itS}_{\itjk} |   ( dB ) ',...
%     'VerticalAlignment', 'bottom')
% legend(...
%     ' {\itS}_{21}',...
%     ' {\itS}_{11}',...
%     'location', 'best')
% set(gca, 'FontName', 'times new roman', 'FontSize', NF)
% set(gca, 'linewidth', 2.5)
%-------------------------------------------------------------------
for kk = 1 : N_Freq
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C(C1_I, fk);
 T2 = EE456_ABCD_Series_L(L2_I, fk);
 T3 = EE456_ABCD_Shunt_L(L3_I, fk);
 T4 = EE456_ABCD_Shunt_C(C4_I, fk);
 T5 = EE456_ABCD_Series_C(C5_I, fk);
 T6 = EE456_ABCD_Shunt_L(L6_I, fk);
 T = T1*T2*T3*T4*T5*T6;
 S_IMN(kk, :, :) = ABCD_to_S(T, [Ri, Z0]);
end
%------------------------------------------------------------------
S11_IMN = S_IMN(:, 1, 1);
S11_IMN_Mag = abs(S11_IMN);
S11_IMN_dB = 20*log10(S11_IMN_Mag);
S21_IMN = S_IMN(:, 2, 1);
S21_IMN_Mag = abs(S21_IMN);
S21_IMN_dB = 20*log10(S21_IMN_Mag);
S11_IMN_fx_dB = S11_IMN_dB(I_fx);
S21_IMN_fx_dB = S21_IMN_dB(I_fx);
%-------------------------------------------------------------------
nT = sqrt(Z0/RTp_I);
CP = C4_I;
CS = C5_I;
CC = (1/nT)*((nT-1)*CS+(nT*CP));
CB = (1/nT)*CS;
CA = (1/nT^2)*((1-nT)*CS);
LZ =  (nT^2)*L6_I;
%-------------------------------------------------------------------
C6_I = CA;
C5_I = CB;
C4_I = CC;
L7_I = LZ;
%-------------------------------------------------------------------
Print_Break
Print_Real('nT', nT)
Print_Real('CS/(CP+CS)', (CS/(CP+CS)))
Print_Real_Unit('CA', CA, 'F')
Print_Real_Unit('CB', CB, 'F')
Print_Real_Unit('CC', CC, 'F')
Print_Real_Unit('LZ', LZ, 'H')
Print_Break
Print_Real_Unit('Ri', Ri, 'Ohms')
Print_Real_Unit('Ci', Ci, 'F')
Print_Real_Unit('C1', C1_I, 'F')
Print_Real_Unit('L2', L2_I, 'H')
Print_Real_Unit('L3', L3_I, 'H')
Print_Real_Unit('C4', C4_I, 'F')
Print_Real_Unit('C5', C5_I, 'F')
Print_Real_Unit('C6', C6_I, 'F')
Print_Real_Unit('L7', L7_I, 'H')
Print_Real_Unit('Z0', Z0, 'Ohms')
%-------------------------------------------------------------------
Ci1 = ((1/C1_I) - (1/Ci))^-1;
Li2 = L2_I - Li;
Li3 = L3_I;
Ci4 = C4_I;
Ci5 = C5_I;
Ci6 = C6_I;
Li7 = L7_I;
%-------------------------------------------------------------------
j = 1j;
for kk = 1 : N_Freq
 fk = freq(kk);
 sk = j*2*pi*fk;
 Zp1 = Ri+(1/(Ci*sk))+Li*sk;
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C(Ci1, fk);
 T2 = EE456_ABCD_Series_L(Li2, fk);
 T3 = EE456_ABCD_Shunt_L(Li3, fk);
 T4 = EE456_ABCD_Shunt_C(Ci4, fk);
 T5 = EE456_ABCD_Series_C(Ci5, fk);
 T6 = EE456_ABCD_Shunt_C(Ci6, fk);
 T7 = EE456_ABCD_Shunt_L(Li7, fk);
 T = T1*T2*T3*T4*T5*T6*T7;
 S_IMN(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
end
%------------------------------------------------------------------
S11_IMN = S_IMN(:, 1, 1);
S11_IMN_Mag = abs(S11_IMN);
S11_IMN_dB = 20*log10(S11_IMN_Mag);
S21_IMN = S_IMN(:, 2, 1);
S21_IMN_Mag = abs(S21_IMN);
S21_IMN_dB = 20*log10(S21_IMN_Mag);
S11_IMN_fx_dB = S11_IMN_dB(I_fx);
S21_IMN_fx_dB = S21_IMN_dB(I_fx);
%-------------------------------------------------------------------
% IFigure = IFigure + 1;
% figure_max(IFigure)
% plot(freq/G, S21_IMN_dB, 'r', 'linewidth', 9)
% hold on
% plot(freq/G, S11_IMN_dB, 'b', 'linewidth', 9)
% plot(fx/G, S21_IMN_fx_dB, 'ro', 'linewidth', 15)
% plot(fx/G, S11_IMN_fx_dB, 'bo', 'linewidth', 15)
% hold off
% grid on
% grid minor
% axis([f_min/G, f_max/G, -25, 0])
% ax = gca;
% ax.XTick = f_min/G : 1 : f_max/G;
% ax.XAxis.MinorTickValues = ...
%  f_min/G : 0.25 : f_max/G;
% ax.YTick = -25 : 5 : 0;
% ax.YAxis.MinorTickValues = ...
%      -25. : 2.5 : 2;
% xlabel('{\itf}   (GHz)  ')
% ylabel(' | {\itS}_{\itjk} |   ( dB ) ',...
%     'VerticalAlignment', 'bottom')
% legend(...
%     ' {\itS}_{21}',...
%     ' {\itS}_{11}',...
%     'location', 'best')
% set(gca, 'FontName', 'times new roman', 'FontSize', NF)
% set(gca, 'linewidth', 2.5)
%------------------------------------------------------------------
Print_Break
Print_Real_Unit('Ci1', Ci1, 'F')
Print_Real_Unit('Li2', Li2, 'H')
Print_Real_Unit('Li3', Li3, 'H')
Print_Real_Unit('Ci4', Ci4, 'F')
Print_Real_Unit('Ci5', Ci5, 'F')
Print_Real_Unit('Ci6', Ci6, 'F')
Print_Real_Unit('Li7', Li7, 'H')

%------------------------------------------------------------------
NS = 0;
IL_min_dB = 0.1;
Ripple = .1;
IL_max_dB = IL_min_dB + Ripple;
%------------------------------------------------------------------
w0 = 2*pi*f0;
wH = 2*pi*fH;
wL = 2*pi*fL;
BW_w = 2*pi*BW_f;
Delta = BW_f/f0;
%-------------------------------------------------------------------
freq = f_min  : df : f_max;
fx = [fL, f0, fH];
freq = union(freq, fx);
freq = sort(freq);
I_fx = ismember(freq, fx);
N_Freq = length(freq);
S_OMN = zeros(N_Freq, 2, 2);
%-------------------------------------------------------------------
N_Poly = (1/2)*(NE-1);
IL_max = 10^(IL_max_dB/10);
IL_min = 10^(IL_min_dB/10);
k0 = IL_min;
kT = IL_max - k0;
%-------------------------------------------------------------------
Print_Title('Network Synthesis - Design 3')
Print_Real_Unit('f0', f0, 'Hz')
Print_Real_Unit('BW_f', BW_f, 'Hz')
Print_Real_Unit('Ri', Ri, 'Ohms')
Print_Real_Unit('Ci', Ci, 'F')
Print_Real_Unit('Li', Li, 'H')
Print_Real_Unit('Ro', Ro, 'Ohms')
Print_Real_Unit('Co', Co, 'F')
Print_Real_Unit('Lo', Lo, 'H')
Print_Real('NE', NE, 'Reactive Elements')
Print_Real('N_Poly', N_Poly, 'Order Chebyshev')
Print_Real('NS', NS, 'Slope Parameter')
Print_Real_Unit('fL', fL, 'Hz')
Print_Real_Unit('fH', fH, 'Hz')
Print_Break
Print_Real2('w0', w0, 'rad/s')
Print_Real('w0', w0/w0, 'w0')
Print_Real2('BW_w', BW_w, 'rad/s')
Print_Real('BW_w', BW_w/w0, 'w0')
Print_Real2('wL', wL, 'rad/s')
Print_Real('wL', wL/w0, 'w0')
Print_Real2('wH', wH, 'rad/s')
Print_Real('wH', wH/w0, 'w0')
Print_Break
Print_Real('IL_min', IL_min_dB, 'dB')
Print_Real('Ripple', Ripple, 'dB')
Print_Real('IL_max', IL_max_dB, 'dB')
Print_Real('k0', k0)
Print_Real('kT', kT)
Print_Break
%-------------------------------------------------------------------
[IL_num, IL_den, R2_num, R2_den] = ...
 EE456_IL_Function_f0(fL, fH, k0, kT, N_Poly, NS);
sz2 = roots(R2_num);
sz = sz2(real(sz2) < 0);
sp2 = roots(R2_den);
sp = sp2(real(sp2) < 0 );
%-------------------------------------------------------------------
Print_Break
EE456_Print_Poly('IL_num', 'IL_den',...
 IL_num, IL_den)
Print_Break
EE456_Print_Poly('R2_num', 'R2_den',...
 R2_num, R2_den)
Print_Break
%-------------------------------------------------------------------
Print_Rect('sz2', sz2, 'rad/s')
Print_Rect('sp2', sp2, 'rad/s')
Print_Break
Print_Rect('sz', sz, 'rad/s')
Print_Rect('sp', sp, 'rad/s')
%-------------------------------------------------------------------
f_f0 = freq/f0;
w_w0 = f_f0;
s = 1j*w_w0;
IL = polyval(IL_num, s) ./ polyval(IL_den, s);
IL_dB = 10*log10( abs(IL) );
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq/f0, IL_dB, 'r', 'linewidth', 9)
hold on
plot(fx/f0, IL_dB(I_fx), 'ro', 'linewidth', 15)
hold off
grid on
grid minor
axis([0.6, 1.5, -.5, 1.5])
ax = gca;
ax.XTick = 0.6 : 0.1 : 1.5;
ax.XAxis.MinorTickValues = ...
0.6 : 0.05 : 1.5;
ax.YTick = -.5 : 0.2 : 1.5;
ax.YAxis.MinorTickValues = ...
-.5 : 0.1 : 1.5;
xlabel('{\itf} / {\itf}_{0}   ')
ylabel('{\itIL}    ( dB ) ',...
'VerticalAlignment', 'bottom')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
IFigure = IFigure + 1;
figure_max(IFigure)
zplane(sz2, sp2)
hold on
plot(real(sz2), imag(sz2), 'rd', 'linewidth', 9)
plot(real(sp2), imag(sp2), 'ro', 'linewidth', 9)
hold off
grid on
grid minor
axis([-2, 2, -2, 2])
axis square
set(gca, 'linewidth', 2)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
zplane(sz, sp)
hold on
plot(real(sz), imag(sz), 'rd', 'linewidth', 9)
plot(real(sp), imag(sp), 'ro', 'linewidth', 9)
hold off
grid on
grid minor
axis([-2, 2, -2, 2])
axis square
set(gca, 'linewidth', 2)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
%-------------------------------------------------------------------
R_Sign = 1;
[Z_num, Z_den, R_num, R_den] = ...
 EE456_Z_Function(sz, sp, R_Sign);
 %-------------------------------------------------------------------
Print_Break
Print_Real('R_Sign', R_Sign)
EE456_Print_Poly('R_num', 'R_den',...
 abs(R_num), R_den)
Print_Break
EE456_Print_Poly('Z_num', 'Z_den',...
 Z_num, Z_den)
Print_Break
%-------------------------------------------------------------------
[C1, Z_num, Z_den] = ...
 EE456_Series_C_Synthesis(Z_num, Z_den, 1);
Print_Break
[L2, Z_num, Z_den] = ....
 EE456_Series_L_Synthesis(Z_num, Z_den, 1);
Print_Break
[C3, Z_num, Z_den] = ....
 EE456_Shunt_C_Synthesis(Z_num, Z_den, 1);
Print_Break
[L4, Z_num, Z_den] = ...
 EE456_Series_L_Synthesis(Z_num, Z_den, 1);
Print_Break
[L5, Z_num, Z_den] = ...
 EE456_Shunt_L_Synthesis(Z_num, Z_den, 1);
Print_Break
[C6, Z_num, Z_den] = ....
 EE456_Series_C_Synthesis(Z_num, Z_den, 1);
Print_Break
R7 = Z_num / Z_den;
%-------------------------------------------------------------------
Print_Break
Print_Real_Unit('C1', C1, 'F')
Print_Real_Unit('L2', L2, 'H')
Print_Real_Unit('C3', C3, 'F')
Print_Real_Unit('L4', L4, 'H')
Print_Real_Unit('L5', L5, 'H')
Print_Real_Unit('C6', C6, 'F')
Print_Real_Unit('R7', R7, 'Ohms')
Print_Break
%-------------------------------------------------------------------
C1 = C1/(w0*Ro);
L2 = (L2/w0)*Ro;
C3 = C3/(w0*Ro);
L4 = (L4/w0)*Ro;
L5 = (L5/w0)*Ro;
C6 = C6/(w0*Ro);
RTp = R7*Ro;
%-------------------------------------------------------------------
Print_Break
Print_Real_Unit('Ro', Ro, 'Ohms')
Print_Real_Unit('Co', Co, 'F')
Print_Real_Unit('fH', fH, 'Hz')
Print_Real_Unit('f0', f0, 'Hz')
Print_Real_Unit('fL', fL, 'Hz')
Print_Real_Unit('BW_f', BW_f, 'Hz')
Print_Break
Print_Real_Unit('C1', C1, 'F')
Print_Real_Unit('L2', L2, 'H')
Print_Real_Unit('C3', C3, 'F')
Print_Real_Unit('L4', L4, 'H')
Print_Real_Unit('L5', L5, 'H')
Print_Real_Unit('C6', C6, 'F')
Print_Real_Unit('RTp', RTp, 'Ohms')
Print_Break
%-------------------------------------------------------------------
for kk = 1 : N_Freq
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C(C1, fk);
 T2 = EE456_ABCD_Series_L(L2, fk);
 T3 = EE456_ABCD_Shunt_C(C3, fk);
 T4 = EE456_ABCD_Series_L(L4, fk);
 T5 = EE456_ABCD_Shunt_L(L5, fk);
 T6 = EE456_ABCD_Series_C(C6, fk);
 T = T1*T2*T3*T4*T5*T6;
 S_OMN(kk, :, :) = ABCD_to_S(T, [Ro, RTp]);
end
%------------------------------------------------------------------
S11_OMN = S_OMN(:, 1, 1);
S11_OMN_Mag = abs(S11_OMN);
S11_OMN_dB = 20*log10(S11_OMN_Mag);
S21_OMN = S_OMN(:, 2, 1);
S21_OMN_Mag = abs(S21_OMN);
S21_OMN_dB = 20*log10(S21_OMN_Mag);
S11_OMN_fx_dB = S11_OMN_dB(I_fx);
S21_OMN_fx_dB = S21_OMN_dB(I_fx);
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq/G,S21_OMN_dB, 'r', 'linewidth', 9)
hold on
plot(freq/G, -IL_dB, 'g', 'linewidth', 7)
plot(fx/G, S21_OMN_fx_dB, 'ro', 'linewidth', 15)
hold off
grid on
grid minor
axis([f_min/G, f_max/G, -0.3, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
 f_min/G : 0.5 : f_max/G;
ax.YTick = -0.3 : .05 : 0;
ax.YAxis.MinorTickValues = ...
    -0.3 : 0.025 : 0;
xlabel('{\itf}   (GHz)  ')
ylabel(' | {\itS}_{21} |   ( dB ) ',...
    'VerticalAlignment', 'bottom')
legend(...
    ' | {\itS}_{21} |',...
    ' - {\itIL}',...
    'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
%------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq/G, S21_OMN_dB, 'r', 'linewidth', 9)
hold on
plot(freq/G, S11_OMN_dB, 'b', 'linewidth', 9)
plot(fx/G, S21_OMN_fx_dB, 'ro', 'linewidth', 15)
plot(fx/G, S11_OMN_fx_dB, 'bo', 'linewidth', 15)
hold off
grid on
grid minor
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
 f_min/G : 0.25 : f_max/G;
ax.YTick = -25 : 5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 2.5 : 2;
xlabel('{\itf}   (GHz)  ')
ylabel(' | {\itS}_{\itjk} |   ( dB ) ',...
    'VerticalAlignment', 'bottom')
legend(...
    ' {\itS}_{21}',...
    ' {\itS}_{11}',...
    'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
%-------------------------------------------------------------------
for kk = 1 : N_Freq
 fk = freq(kk);
 T1 = EE456_ABCD_Series_C(C1, fk);
 T2 = EE456_ABCD_Series_L(L2, fk);
 T3 = EE456_ABCD_Shunt_C(C3, fk);
 T4 = EE456_ABCD_Series_L(L4, fk);
 T5 = EE456_ABCD_Shunt_L(L5, fk);
 T6 = EE456_ABCD_Series_C(C6, fk);
 T = T1*T2*T3*T4*T5*T6;
 S_OMN(kk, :, :) = ABCD_to_S(T, [Ro, RTp]);
end
%------------------------------------------------------------------
S11_OMN = S_OMN(:, 1, 1);
S11_OMN_Mag = abs(S11_OMN);
S11_OMN_dB = 20*log10(S11_OMN_Mag);
S21_OMN = S_OMN(:, 2, 1);
S21_OMN_Mag = abs(S21_OMN);
S21_OMN_dB = 20*log10(S21_OMN_Mag);
S11_OMN_fx_dB = S11_OMN_dB(I_fx);
S21_OMN_fx_dB = S21_OMN_dB(I_fx);
%-------------------------------------------------------------------
nT = sqrt(Z0/RTp);
LP = L5;
LS = L4;
LA = nT*(nT-1)*LP;
LB = nT*LP;
LC = (1 - nT)*LP + LS;
CZ =  (1/nT^2)*C6;
%-------------------------------------------------------------------
L6 = LA;
L5 = LB;
L4 = LC;
C7 = CZ;
%-------------------------------------------------------------------
Print_Break
Print_Real('nT', nT)
Print_Real('(LP+LS)/LP', (LP+LS)/LP)
Print_Real_Unit('LA', LA, 'H')
Print_Real_Unit('LB', LB, 'H')
Print_Real_Unit('LC', LC, 'H')
Print_Real_Unit('CZ', CZ, 'F')
Print_Break
Print_Real_Unit('Ro', Ro, 'Ohms')
Print_Real_Unit('Co', Co, 'F')
Print_Real_Unit('C1', C1, 'F')
Print_Real_Unit('L2', L2, 'H')
Print_Real_Unit('C3', C3, 'F')
Print_Real_Unit('L4', L4, 'H')
Print_Real_Unit('L5', L5, 'H')
Print_Real_Unit('L6', L6, 'H')
Print_Real_Unit('C7', C7, 'F')
Print_Real_Unit('Z0', Z0, 'Ohms')
%-------------------------------------------------------------------
Co1 = ((1/C1) - (1/Co))^-1;
Lo2 = L2 - Lo;
Co3 = C3;
Lo4 = L4;
Lo5 = L5;
Lo6 = L6;
Co7 = C7;
%-------------------------------------------------------------------
j = 1j;
for kk = 1 : N_Freq
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
 T = T1*T2*T3*T4*T5*T6*T7;
 S_OMN(kk, :, :) = ABCD_to_S_CZ0(T, [Zp1, Z0]);
end
%-------------------------------------------------------------------
S11_OMN = S_OMN(:, 1, 1);
S11_OMN_Mag = abs(S11_OMN);
S11_OMN_dB = 20*log10(S11_OMN_Mag);
S21_OMN = S_OMN(:, 2, 1);
S21_OMN_Mag = abs(S21_OMN);
S21_OMN_dB = 20*log10(S21_OMN_Mag);
S11_OMN_fx_dB = S11_OMN_dB(I_fx);
S21_OMN_fx_dB = S21_OMN_dB(I_fx);
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq/G, S21_OMN_dB, 'r', 'linewidth', 9)
hold on
plot(freq/G, S11_OMN_dB, 'b', 'linewidth', 9)
plot(fx/G, S21_OMN_fx_dB, 'ro', 'linewidth', 15)
plot(fx/G, S11_OMN_fx_dB, 'bo', 'linewidth', 15)
hold off
grid on
grid minor
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
 f_min/G : 0.25 : f_max/G;
ax.YTick = -25 : 5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 2.5 : 2;
xlabel('{\itf}   (GHz)  ')
ylabel(' | {\itS}_{\itjk} |   ( dB ) ',...
    'VerticalAlignment', 'bottom')
legend(...
    ' {\itS}_{21}',...
    ' {\itS}_{11}',...
    'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
%------------------------------------------------------------------
Print_Break
Print_Real_Unit('Co1', Co1, 'F')
Print_Real_Unit('Lo2', Lo2, 'H')
Print_Real_Unit('Co3', Co3, 'F')
Print_Real_Unit('Lo4', Lo4, 'H')
Print_Real_Unit('Lo5', Lo5, 'H')
Print_Real_Unit('Lo6', Lo6, 'H')
Print_Real_Unit('Co7', Co7, 'F')
%-------------------------------------------------------------------

filePath = 'C:\EE456\Design Project 3';

fileNames = {'NE321000.s2p',};

%-------------------------------------------------------------------

[freq_FET, S_FET, Mult] = ...
    Read_SParam_s2p('NE321000.s2p');
freq_FET = freq_FET * Mult;

%-------------------------------------------------------------------

fL_FET = 10*G;
fH_FET = 20*G;
f0_FET = sqrt(fL_FET*fH_FET);
fx_FET = [fL_FET, f0_FET, fH_FET];

%-------------------------------------------------------------------

freq_Amp = f_min  : df : f_max;
freq_Amp = union(freq_Amp, fx_FET);
freq_Amp = sort(freq_Amp);
I_fx_Amp = ismember(freq_Amp, fx_FET);
I_f0_Amp = ismember(freq_Amp, f0_FET);
N_Freq_Amp = length(freq_Amp);
S_Amp = zeros(N_Freq_Amp, 2, 2);

%-------------------------------------------------------------------

for kk = 1 : N_Freq_Amp
 fk = freq_Amp(kk);
 sk = j*2*pi*fk;

 To1 = EE456_ABCD_Series_C(Co1, fk);
 To2 = EE456_ABCD_Series_L(Lo2, fk);
 To3 = EE456_ABCD_Shunt_C(Co3, fk);
 To4 = EE456_ABCD_Series_L(Lo4, fk);
 To5 = EE456_ABCD_Shunt_L(Lo5, fk);
 To6 = EE456_ABCD_Series_L(Lo6, fk);
 To7 = EE456_ABCD_Series_C(Co7, fk);
 T_OMN = To1*To2*To3*To4*To5*To6*To7;

 Ti1 = EE456_ABCD_Series_C(Ci1, fk);
 Ti2 = EE456_ABCD_Series_L(Li2, fk);
 Ti3 = EE456_ABCD_Shunt_L(Li3, fk);
 Ti4 = EE456_ABCD_Shunt_C(Ci4, fk);
 Ti5 = EE456_ABCD_Series_C(Ci5, fk);
 Ti6 = EE456_ABCD_Shunt_C(Ci6, fk);
 Ti7 = EE456_ABCD_Shunt_L(Li7, fk);
 T_IMN = Ti7*Ti6*Ti5*Ti4*Ti3*Ti2*Ti1;

 Sx = S_Param_Interp(S_FET, freq_FET, fk);
 TFET = S_to_ABCD(Sx, Z0);

 T = T_IMN*TFET*T_OMN;
 S_Amp(kk, :, :) = ABCD_to_S(T,Z0);

end

%-------------------------------------------------------------------

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

%-------------------------------------------------------------------

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

%-------------------------------------------------------------------

S11_Amp_fx_dB = S11_Amp_dB(I_fx_Amp);
S12_Amp_fx_dB = S12_Amp_dB(I_fx_Amp);
S21_Amp_fx_dB = S21_Amp_dB(I_fx_Amp);
S22_Amp_fx_dB = S22_Amp_dB(I_fx_Amp);

Print_Polar('S11_Amp',S11_Amp_f0);
Print_Polar('S21_Amp',S21_Amp_f0);
Print_Polar('S12_Amp',S12_Amp_f0);
Print_Polar('S22_Amp',S22_Amp_f0);

%-------------------------------------------------------------------
filePath = 'C:\Users\Adminimal\Documents\MATLAB\WNE\WNE_SP25\EE456\EE456_Design_Projects\EE456_Design_Project_3_v3\';

fileNames = {'NE321000.s2p', 'Design_3_IMN_OMN_Placzek.s2p'};

[freq_ADS, S_ADS, Mult_ADS] = ...
    Read_SParam_s2p('Design_3_IMN_OMN_Placzek.s2p');
freq_ADS = freq_ADS * Mult_ADS;

I_f0_ADS = find(freq_ADS == f0);
% I_f0_ADS = freq_ADS == f0;
I_fH_ADS = freq_ADS == fH;
I_fL_ADS = freq_ADS == fL_FET;

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

%------------------------------------------------------------------
% S_ADS_f0(1:2, 1:2) = S_ADS(I_f0_ADS, :, :);
% S11_ADS_f0 = S11_ADS(I_f0_ADS);
% S11_ADS_f0_dB = S11_ADS_dB(I_f0_ADS);
% S21_ADS_f0 = S21_ADS(I_f0_ADS);
% S21_ADS_f0_dB = S21_ADS_dB(I_f0_ADS);
% S12_ADS_f0 = S12_ADS(I_f0_ADS);
% S12_ADS_f0_dB = S12_ADS_dB(I_f0_ADS);
% S22_ADS_f0 = S22_ADS(I_f0_ADS);
% S22_ADS_f0_dB = S22_ADS_dB(I_f0_ADS);
% 
% Print_Polar('S11_Amp',S11_ADS_f0);
% Print_Polar('S21_Amp',S21_ADS_f0);
% Print_Polar('S12_Amp',S12_ADS_f0);
% Print_Polar('S22_Amp',S22_ADS_f0);

%------------------------------------------------------------------
S_ADS_fH(1:2, 1:2) = S_ADS(I_fH_ADS, :, :);
S11_ADS_fH = S11_ADS(I_fH_ADS);
S11_ADS_fH_dB = S11_ADS_dB(I_fH_ADS);
S21_ADS_fH = S21_ADS(I_fH_ADS);
S21_ADS_fH_dB = S21_ADS_dB(I_fH_ADS);
S12_ADS_fH = S12_ADS(I_fH_ADS);
S12_ADS_fH_dB = S12_ADS_dB(I_fH_ADS);
S22_ADS_fH = S22_ADS(I_fH_ADS);
S22_ADS_fH_dB = S22_ADS_dB(I_fH_ADS);
%------------------------------------------------------------------
S_ADS_fL(1:2, 1:2) = S_ADS(I_fL_ADS, :, :);
S11_ADS_fL = S11_ADS(I_fL_ADS);
S11_ADS_fL_dB = S11_ADS_dB(I_fL_ADS);
S21_ADS_fL = S21_ADS(I_fL_ADS);
S21_ADS_fL_dB = S21_ADS_dB(I_fL_ADS);
S12_ADS_fL = S12_ADS(I_fL_ADS);
S12_ADS_fL_dB = S12_ADS_dB(I_fL_ADS);
S22_ADS_fL = S22_ADS(I_fL_ADS);
S22_ADS_fL_dB = S22_ADS_dB(I_fL_ADS);
%------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_Amp/G, S21_Amp_dB, 'r', 'linewidth', 9)
hold on
plot(fx_FET/G, S21_Amp_fx_dB, 'ro', 'linewidth', 15)
hold off
grid on
grid minor
axis([f_min/G, f_max/G, 6, 9])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
 f_min/G : 0.5 : f_max/G;
ax.YTick = 6 : .5 : 9;
ax.YAxis.MinorTickValues = ...
     6. : .25 : 9;
xlabel('{\itf}   (GHz)  ')
ylabel(' | {\itS}_{21} |   ( dB ) ',...
    'VerticalAlignment', 'bottom')
legend(...
    ' {\itS}_{21}',...
    ' {\itS}_{21}',...
    'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_Amp/G, S11_Amp_dB, 'r', 'linewidth', 9)
hold on
plot(fx_FET/G, S11_Amp_fx_dB, 'ro', 'linewidth', 15)
hold off
grid on
grid minor
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
 f_min/G : 0.5 : f_max/G;
ax.YTick = -25 : 2.5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 1.25 : 0;
xlabel('{\itf}   (GHz)  ')
ylabel(' | {\itS}_{11} |   ( dB ) ',...
    'VerticalAlignment', 'bottom')
legend(...
    ' {\itS}_{11}',...
    ' {\itS}_{11}',...
    'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
%-------------------------------------------------------------------
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_Amp/G, S22_Amp_dB, 'r', 'linewidth', 9)
hold on
plot(fx_FET/G, S22_Amp_fx_dB, 'ro', 'linewidth', 15)
hold off
grid on
grid minor
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
 f_min/G : 0.5 : f_max/G;
ax.YTick = -25 : 2.5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 1.25 : 0;
xlabel('{\itf}   (GHz)  ')
ylabel(' | {\itS}_{22} |   ( dB ) ',...
    'VerticalAlignment', 'bottom')
legend(...
    ' {\itS}_{22}',...
    ' {\itS}_{22}',...
    'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
set(gca, 'linewidth', 2.5)
%------------------------------------------------------------------

% Graph of |S21| in dB
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S21_ADS_dB, 'r', 'linewidth', 8)
hold on
plot(fL_FET/G, S21_ADS_fL_dB, 'bd', 'linewidth', 10)
plot(fH/G, S21_ADS_fH_dB, 'bs', 'linewidth', 10)
hold off
grid on
grid minor
xlabel('{\it f} (GHz)')
ylabel('| {\it S}_{21} | (dB)')
title('|S_{21}| from ADS')
legend('ADS', 'fL', 'fH', 'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, 6, 9])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
f_min/G : 0.5 : f_max/G;
ax.YTick = 6: 0.5 : 9;
ax.YAxis.MinorTickValues = ...
     6. : 0.25 :9;
set(gca, 'linewidth', 2.5)

%-------------------------------------------------------------------

% Graph of |S11| in dB
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S11_ADS_dB, 'r', 'linewidth', 8)
hold on
plot(fH/G, S11_ADS_fH_dB, 'bo', 'linewidth', 10)
plot(fL_FET/G, S11_ADS_fL_dB, 'bs', 'linewidth', 10)
hold off
grid on
grid minor
xlabel('{\it f} (GHz)')
ylabel('| {\it S}_{11} | (dB)')
title('|S_{11}| from ADS')
legend('ADS', 'fL', 'fH', 'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
f_min/G : 0.5 : f_max/G;
ax.YTick = -25 : 2.5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 1.25 : 0;
set(gca, 'linewidth', 2.5)

%-------------------------------------------------------------------

% Graph of |S22| in dB
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S22_ADS_dB, 'r', 'linewidth', 8)
hold on
plot(fL_FET/G, S22_ADS_fL_dB, 'bd', 'linewidth', 10)
plot(fH/G, S22_ADS_fH_dB, 'bs', 'linewidth', 10)
hold off
grid on
grid minor
xlabel('{\it f} (GHz)')
ylabel('| {\it S}_{22} | (dB)')
title('|S_{22}| from ADS')
legend('ADS', 'fL','fH', 'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
f_min/G : 0.5 : f_max/G;
ax.YTick = -25 : 2.5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 1.25 : 0;
set(gca, 'linewidth', 2.5)

%------------------------------------------------------------------

% Graph of |S21| in dB
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S21_ADS_dB, 'r', 'linewidth', 8)
hold on
plot(freq_Amp/G, S21_Amp_dB, 'b', 'linewidth', 4)
plot(fL_FET/G, S21_ADS_fL_dB, 'rd', 'linewidth', 10)
plot(fH/G, S21_ADS_fH_dB, 'rd', 'linewidth', 10)
plot(fx_FET/G, S21_Amp_fx_dB, 'bo', 'linewidth', 7)
hold off
grid on
grid minor
xlabel('{\it f} (GHz)')
ylabel('| {\it S}_{21} | (dB)')
title('Comparison of |S_{21}| from ADS and MATLAB')
legend('ADS', 'MATLAB', 'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, 6, 9])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
f_min/G : 0.5 : f_max/G;
ax.YTick = 6: 0.5 : 9;
ax.YAxis.MinorTickValues = ...
     6. : 0.25 :9;
set(gca, 'linewidth', 2.5)

%-------------------------------------------------------------------

% Graph of |S11| in dB
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S11_ADS_dB, 'r', 'linewidth', 8)
hold on
plot(freq_Amp/G, S11_Amp_dB, 'b', 'linewidth', 4)
plot(fH/G, S11_ADS_fH_dB, 'rd', 'linewidth', 10)
plot(fL_FET/G, S11_ADS_fL_dB, 'rd', 'linewidth', 10)
plot(fx_FET/G, S11_Amp_fx_dB, 'bo', 'linewidth', 7)
hold off
grid on
grid minor
xlabel('{\it f} (GHz)')
ylabel('| {\it S}_{11} | (dB)')
title('Comparison of |S_{11}| from ADS and MATLAB')
legend('ADS', 'MATLAB', 'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
f_min/G : 0.5 : f_max/G;
ax.YTick = -25 : 2.5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 1.25 : 0;
set(gca, 'linewidth', 2.5)

%-------------------------------------------------------------------

% Graph of |S22| in dB
IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S22_ADS_dB, 'r', 'linewidth', 8)
hold on
plot(freq_Amp/G, S22_Amp_dB, 'b', 'linewidth', 4)
plot(fL_FET/G, S22_ADS_fL_dB, 'rd', 'linewidth', 10)
plot(fH/G, S22_ADS_fH_dB, 'rd', 'linewidth', 10)
plot(fx_FET/G, S22_Amp_fx_dB, 'bo', 'linewidth', 7)
hold off
grid on
grid minor
xlabel('{\it f} (GHz)')
ylabel('| {\it S}_{22} | (dB)')
title('Comparison of |S_{22}| from ADS and MATLAB')
legend('ADS', 'MATLAB', 'location', 'best')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 1 : f_max/G;
ax.XAxis.MinorTickValues = ...
f_min/G : 0.5 : f_max/G;
ax.YTick = -25 : 2.5 : 0;
ax.YAxis.MinorTickValues = ...
     -25. : 1.25 : 0;
set(gca, 'linewidth', 2.5)
