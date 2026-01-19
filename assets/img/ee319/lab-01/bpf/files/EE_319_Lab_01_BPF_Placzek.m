%-------------------------------------------------------------------------

% function EE_319_Lab_01_BPF_Placzek

%-------------------------------------------------------------------------
% EE 319 Electronics Lab I
% Lab 01 Bandpass Filter
% Steven Placzek
%-------------------------------------------------------------------------

clear
clc
close all

%-------------------------------------------------------------------------

k = 10^+3;        
m = 10^-3;        
u = 10^-6;        
n = 10^-9;        

%-------------------------------------------------------------------------

R1 = 10*k;
R2 = 10*k;
C1 = 3.3*n;
C2 = 56*n;
f_min = 10;
f_max = 100*k;
Av_dB_min = -30;
Av_dB_max = -5;
Av_Ang_min = -90;
Av_Ang_max = 90;
f_min_2 = 70;
f_max_2 = 17*k;
Av_dB_min_2 = -11;
Av_dB_max_2 = -6;
NF = 32;
IFigure = 0;

%-------------------------------------------------------------------------

Folder_Semester = EE_319_Folder_Semester;
Folder_Main = ...
    [Folder_Semester, '/Lab 01'];
Folder_LTspice = ...
    [Folder_Main, '/LTspice'];
Folder_Measured = ...
    [Folder_Main, '/Measured Data'];

%-------------------------------------------------------------------------

Folder_Excel = Folder_Main;
FileName_Excel_Table = ...
    'EE 319 Lab 01 BPF Results Placzek.xlsx';
File_Loc_Excel_Table = ...
    [Folder_Excel, '/', FileName_Excel_Table];
Sheet_Table_1 = 'Table 1';

%-------------------------------------------------------------------------
% LTspice Placeholder
% File_LTspice_TF = 'EE 319 Lab 01 BPF TF.raw';
% File_Loc_LTspice_TF = ...
%     [Folder_LTspice, '/', File_LTspice_TF];
File_LTspice_Bode = 'EE 319 Lab 01 BPF Bode.raw';
File_Loc_LTspice_Bode = ...
    [Folder_LTspice, '/' , File_LTspice_Bode];

%-------------------------------------------------------------------------

FileName_Measured_Data = ...
    'EE 319 Lab 01 BPF Measured Bode.csv';
File_Loc_Measured_Data = ...
    [Folder_Measured, '/BPF/', FileName_Measured_Data];

%-------------------------------------------------------------------------

G1 = 1/R1;
G2 = 1/R2;
a2 = 0;
a1 = G1*C2;
a0 = 0;
b2 = C1*C2;
b1 = (C2*G1 + C1*G2 + C2*G2);
b0 = G1*G2;
Num = [a2, a1, a0];
Den = [b2, b1, b0];
w0 = sqrt(b0/b2);
f0 = w0 / (2*pi);
Q = (1/w0)*(b0/b1);


Av_mid = (a1/b1);
Av_mid_Mag = abs(Av_mid);
Av_mid_dB = 20*log10(Av_mid_Mag);

%-------------------------------------------------------------------------

sz = roots(Num);
sz = flip(sz);
sz = transpose(sz);
wz = -sz;
fz = wz/(2*pi);
sp = roots(Den);
sp = flip(sp);
sp = transpose(sp);
wp = -sp;
fp = wp/(2*pi);

%-------------------------------------------------------------------------

BW_f = f0 / Q;
fH = roots([1, -BW_f, -f0^2]);
fH = fH(fH>0);
fL = fH - BW_f;
% f0 = sqrt(fL*fH);

%-------------------------------------------------------------------------

N_min = floor(log10(f_min));
N_max = ceil(log10(f_max));
N_Dec = N_max - N_min;
NPoints_Dec = 100;
NFreq = NPoints_Dec*N_Dec + 1;
freq = logspace(N_min, N_max, NFreq);
if sum((freq == fL))==0, freq = sort([freq, fL]); end
if sum((freq == f0))==0, freq = sort([freq, f0]); end
if sum((freq == fH))==0, freq = sort([freq, fH]); end
for kk = 1 : length(fz)
    if sum((freq == fz(kk)))==0, freq = sort([freq, fz(kk)]); end 
end
for kk = 1 : length(fp)
    if sum((freq == fp(kk)))==0, freq = sort([freq, fp(kk)]); end 
end

%-------------------------------------------------------------------------

w = 2 * pi * freq;
s = 1j * w;

Num_f = polyval(Num, s);
Den_f = polyval(Den, s);

Av_f = (+1) * (Num_f ./ Den_f);

[Av_f_Mag, Av_f_Ang] = ...
    Rect_2_Polar(Av_f);

Av_f_dB = 20*log10(Av_f_Mag);

%-------------------------------------------------------------------------

fx = [fL, f0, fH];
I_fx = ismember(freq, fx);
Av_fx = Av_f(I_fx);
[Av_fx_Mag, Av_fx_Ang] = ...
    Rect_2_Polar(Av_fx);
Av_fx_dB = 20*log10(Av_fx_Mag);

%-------------------------------------------------------------------------

I_fz = ismember(freq, fz);
Av_fz = Av_f(I_fz);
[Av_fz_Mag, Av_fz_Ang] = ...
    Rect_2_Polar(Av_fz);
Av_fz_dB = 20*log10(Av_fz_Mag);

%-------------------------------------------------------------------------

I_fp = ismember(freq, fp);
Av_fp = Av_f(I_fp);
[Av_fp_Mag, Av_fp_Ang] = ...
    Rect_2_Polar(Av_fp);
Av_fp_dB = 20*log10(Av_fp_Mag);

%-------------------------------------------------------------------------

[freq_LTspice, Av_f_LTspice, ~, ~, ~, ~] = ...
    Read_LTspice_Bode(File_Loc_LTspice_Bode, 'vo');

%-------------------------------------------------------------------------

[fL_LTspice, f0_LTspice, fH_LTspice, ...
    BW_f_LTspice, Q_LTspice, ...
    freq_LTspice, ~, ~, ...
    Av_f_LTspice_dB, Av_f_LTspice_Ang,...
    Av_mid_LTspice, ~, Av_mid_LTspice_dB, ...
    fx_LTspice, Av_fx_LTspice, ~, ...
    Av_fx_LTspice_dB, Av_fx_LTspice_Ang] = ...
    BPF_Param_LTspice(freq_LTspice, Av_f_LTspice);

%-------------------------------------------------------------------------

[freq_Meas, Av_f_Meas, ~, ~, ~] = ...
    Read_AD_Bode(File_Loc_Measured_Data);
[fL_Meas, f0_Meas, fH_Meas, ...
    BW_f_Meas, Q_Meas, ...
    freq_Meas, ~, ~, ...
    Av_f_Meas_dB, Av_f_Meas_Ang, ...
    Av_mid_Meas, ~, Av_mid_Meas_dB, ...
    fx_Meas, Av_fx_Meas, ~, ...
     Av_fx_Meas_dB, Av_fx_Meas_Ang] = ...
     BPF_Param_AD(freq_Meas, Av_f_Meas);

%------------------------------------------------------------------------
%  dotted-line segments
f_start = f_min;
f_end = f_max;

wpL = wp(1);
wL_freq = wpL ./ (2*pi);

wpH = wp(2);
wH_freq = wpH ./ (2*pi);

pole_low = 140.0096;
pole_high = 9.7899*k;
% slope +20 dB/dec for f < fL
x1 = logspace(log10(f_start), log10(pole_low), 100);
y1 = Av_mid_dB - 20*log10(pole_low./x1);

% 0 dB/dec from fL to fH
x2 = [pole_low, pole_high];
y2 = [Av_mid_dB, Av_mid_dB];

% slope -20 dB/dec for f > fH
x3 = logspace(log10(pole_high), log10(f_end), 100);
y3 = Av_mid_dB - 20*log10(x3./pole_high);

%------------------------------------------------------------------------
% Figure 1: Calculated Gain

IFigure = IFigure + 1;
figure_max(IFigure)
semilogx(freq, Av_f_dB, 'r', 'linewidth', 9)
hold on
semilogx(x1, y1, 'k--', 'LineWidth', 2);
semilogx(x2, y2, 'k--', 'LineWidth', 2);
semilogx(x3, y3, 'k--', 'LineWidth', 2);

hold off
grid on
grid minor
axis([f_min, f_max, Av_dB_min, Av_dB_max])
ax =gca;
ax.YTick = Av_dB_min : 5 : Av_dB_max;
xlabel('{\it{f}} (Hz)')
ylabel('$|\tilde{A}_v(\it{f})|$ (dB)', 'Interpreter', 'latex',...
   'VerticalAlignment', 'bottom')
title('Calculated')
set(gca, 'linewidth', 2.5)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)

%-------------------------------------------------------------------------
% Figure 2: Calc Phase

IFigure = IFigure + 1;
figure_max(IFigure)
semilogx(freq, Av_f_Ang, 'r', 'linewidth', 9)
hold on

hold off
grid on
grid minor
axis([f_min, f_max, Av_Ang_min, Av_Ang_max])
ax =gca;
ax.YTick = Av_Ang_min : 45 : Av_Ang_max;
xlabel('{\it{f}} (Hz)')
ylabel('$|\tilde{A}_v(\theta)|$ ($^\circ$)', 'Interpreter', 'latex',...
 'VerticalAlignment', 'bottom')
title('Calculated')
set(gca, 'linewidth', 2.5)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)

%-------------------------------------------------------------------------
% Figure 3: -30 dB to -5 dB Calc vs Sim vs Meas Gain

IFigure = IFigure + 1;
figure_max(IFigure)
semilogx(freq, Av_f_dB, 'r', 'linewidth', 11)
hold on
semilogx(freq_LTspice, Av_f_LTspice_dB, 'g', 'linewidth', 7)
semilogx(freq_Meas, Av_f_Meas_dB, 'b', 'linewidth', 9)
semilogx(x1, y1, 'k--', 'LineWidth', 2);
semilogx(x2, y2, 'k--', 'LineWidth', 2);
semilogx(x3, y3, 'k--', 'LineWidth', 2);
semilogx(fx, Av_fx_dB, 'ro', 'linewidth', 13)
semilogx(fx_LTspice, Av_fx_LTspice_dB, 'go', 'linewidth', 13)
semilogx(fx_Meas, Av_fx_Meas_dB, 'bo', 'linewidth', 13)


% disp text at fL and fH
% semilogx([fL, fH], [Av_mid_dB, Av_mid_dB], 'r-o');
% text(fL, Av_mid_dB, sprintf('fL = %g Hz', fL), 'VerticalAlignment', 'top');
% text(fH, Av_mid_dB, sprintf('fH = %g Hz', fH), 'VerticalAlignment', 'top');

hold off
grid on
grid minor
axis([f_min, f_max, Av_dB_min, Av_dB_max])
ax = gca;
ax.YTick = Av_dB_min : 5 : Av_dB_max;
xlabel('{\it{ f}} (Hz)')
ylabel('$|\tilde{A}_v(\it{f})|$ (dB)', 'Interpreter', 'latex',...
   'VerticalAlignment', 'bottom')
 legend(...
   ' Calculated Values',...
   ' Simulated Values',...
   ' Measured Values',...
   ' Asymptotic Bode',...
   'location', 'best')
set(gca, 'linewidth', 2.5)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)

%-------------------------------------------------------------------------
% Figure 4: -12 dB to -5 dB - Av(f) Gain Plot zoomed in

IFigure = IFigure + 1;
figure_max(IFigure)
semilogx(freq, Av_f_dB, 'r', 'linewidth', 11)
hold on
semilogx(freq_LTspice, Av_f_LTspice_dB, 'g', 'linewidth', 7)
semilogx(freq_Meas, Av_f_Meas_dB, 'b', 'linewidth', 9)
semilogx(x1, y1, 'k--', 'LineWidth', 2);
semilogx(x2, y2, 'k--', 'LineWidth', 2);
semilogx(x3, y3, 'k--', 'LineWidth', 2);
semilogx(fx, Av_fx_dB, 'ro', 'linewidth', 13)
semilogx(fx_LTspice, Av_fx_LTspice_dB, 'go', 'linewidth', 13)
semilogx(fx_Meas, Av_fx_Meas_dB, 'bo', 'linewidth', 13)

hold off
grid on
grid minor
axis([f_min_2, f_max_2, Av_dB_min_2, Av_dB_max_2])
ax = gca;
ax.YTick = Av_dB_min_2 : 1 : Av_dB_max_2;
xlabel('{\it{f}} (Hz)')
ylabel('$|\tilde{A}_v(\it{f})|$ (dB)', 'Interpreter', 'latex',...
   'VerticalAlignment', 'bottom')
legend(...
  '  Calculated Values',...
  '  Simulated Values',...
  '  Measured Values',...
  '  Asymptotic Bode',...
  'location', 'best')
set(gca, 'linewidth', 2.5)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)

%-------------------------------------------------------------------------
% Figure 5: Calc vs Sim vs Meas - Phase Plot -90deg to +90deg

IFigure = IFigure + 1;
figure_max(IFigure)
semilogx(freq, Av_f_Ang, 'r', 'linewidth', 11)
hold on
semilogx(freq_LTspice, Av_f_LTspice_Ang, 'g', 'linewidth', 7)
semilogx(freq_Meas, Av_f_Meas_Ang, 'b', 'linewidth', 8)
semilogx(fx, Av_fx_Ang, 'ro', 'linewidth', 13)
semilogx(fx_LTspice, Av_fx_LTspice_Ang, 'go', 'linewidth', 13)
semilogx(fx_Meas, Av_fx_Meas_Ang, 'bo', 'linewidth', 13)
hold off
grid on
grid minor
axis([f_min, f_max, Av_Ang_min, Av_Ang_max])
ax =gca;
ax.YTick = Av_Ang_min : 45 : Av_Ang_max;
xlabel('{\it{f}} (Hz)')
ylabel('$|\tilde{A}_v(\theta)|$ ($^\circ$)', 'Interpreter', 'latex',...
 'VerticalAlignment', 'bottom')
legend(...
  'Calculated',...
  'Simulated',...
  'Measured',...
  'location', 'best')
set(gca, 'linewidth', 2.5)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)

%-------------------------------------------------------------------------

Print_Title('EE 319 - Lab 01 - BPF Results - Steven Placzek');

Print_Text('Given Values of Components:')
Print_Real_Unit('R1', R1, 'Ohms');
Print_Real_Unit('R2', R2, 'Ohms');
Print_Real('C1', C1/n, 'nF')
Print_Real('C2', C2/n, 'nF')

Print_Text('Calculated values of Components:')
Print_Rect_Unit('G1', G1, 'Ohms')
Print_Rect_Unit('G2', G2, 'Ohms')

Print_Break

Print_Real_Unit('sp', sp, 'rad/sec')
Print_Real_Unit('wp', wp, 'rad/sec')
Print_Real_Unit('wp', wp, 'rad/s')

Print_Break
Print_Text('Calculated Values found in MATLAB:')

Print_Real_Unit('Av_mid', Av_mid, 'V/V')
Print_Real('Av_mid', Av_mid_dB, 'dB')
Print_Real_Unit('fL', fL, 'Hz')
Print_Real_Unit('f0', f0, 'Hz')
Print_Real_Unit('fH', fH, 'Hz')
% fH_dB = 20*log10(fH)
% Print_Real_Unit('fH_dB', fH_dB, 'Hz')
Print_Real_Unit('BW_f', BW_f/m, 'Hz')
Print_Real('Q', Q, 'Hz/Hz')
Print_Real_Unit('Low Pole', pole_low, 'Hz')
Print_Real_Unit('High Pole', pole_high, 'Hz')

Print_Break
Print_Text('Simulated Values from LTSpice:')

Print_Real_Unit('Av_mid_LTspice', Av_mid_LTspice, 'V/V')
Print_Real('Av_mid_LTspice_dB', Av_mid_LTspice_dB, 'dB')
Print_Real_Unit('fL_LTspice', fL_LTspice, 'Hz')
Print_Real_Unit('f0_LTspice', f0_LTspice, 'Hz')
Print_Real_Unit('fH_LTspice', fH_LTspice, 'Hz')
Print_Real_Unit('BW_f_LTspice', BW_f_LTspice, 'Hz')
Print_Real('Q_LTspice', Q_LTspice, 'Hz')

Print_Break
Print_Text('Measured Values found using Analog Discovery Studio:')
Print_Real_Unit('Av_mid_Meas', Av_mid_Meas, 'V/V')
Print_Real('Av_mid_Meas_dB', Av_mid_Meas_dB, 'dB')
Print_Real_Unit('fL_Meas', fL_Meas, 'Hz')
Print_Real_Unit('f0_Meas', f0_Meas, 'Hz')
Print_Real_Unit('fH_Meas', fH_Meas, 'Hz')
Print_Real_Unit('BW_f_Meas', BW_f_Meas, 'Hz')
Print_Real('Q_Meas', Q_Meas, 'Hz/Hz')

Print_Break

Print_Real_Unit('fH_Meas', fH_Meas, 'Hz')
Print_Real_Unit('T_Meas', 1/fH_Meas, 's')
Print_Real_Unit('0.3T_Meas', 0.3/fH_Meas, 's/div')

Print_End

Print_Break

Print_Real_Unit('f0_Meas', f0_Meas, 'Hz')
Print_Real_Unit('T_Meas', 1/f0_Meas, 's')
Print_Real_Unit('0.3T_Meas', 0.3/f0_Meas, 's/div')

Print_End

Print_Break

Print_Real_Unit('fL_Meas', fL_Meas, 'Hz')
Print_Real_Unit('T_Meas', 1/fL_Meas, 's')
Print_Real_Unit('0.3T_Meas', 0.3/fL_Meas, 's/div')

Print_End

%-------------------------------------------------------------------------
% Excel Stuff

Av_mid_LTspice = Av_mid_LTspice(:);
Av_mid_LTspice_dB = Av_mid_LTspice_dB(:);
fL_LTspice = fL_LTspice(:);
f0_LTspice = f0_LTspice(:);
fH_LTspice = fH_LTspice(:);
BW_f_LTspice = BW_f_LTspice(:);
Q_LTspice = Q_LTspice(:);

M_D_LTspice = [Av_mid_LTspice; Av_mid_LTspice_dB; fL_LTspice;
    f0_LTspice; fH_LTspice; BW_f_LTspice; Q_LTspice];

M_D = [Av_mid; Av_mid_dB; fL; f0; fH; BW_f; Q];
writematrix(M_D, File_Loc_Excel_Table, "Sheet", Sheet_Table_1, "Range", 'B2')
writematrix(M_D_LTspice, File_Loc_Excel_Table, "Sheet", Sheet_Table_1, "Range", 'C2')
M_D_Meas = [Av_mid_Meas; Av_mid_Meas_dB; fL_Meas; f0_Meas; fH_Meas;
    BW_f_Meas; Q_Meas];
writematrix(M_D_Meas, File_Loc_Excel_Table, "Sheet", Sheet_Table_1, "Range", 'D2');

%-------------------------------------------------------------------------

[Diff_LTspice, Percent_Diff_LTspice] = Percent_Difference(M_D, M_D_LTspice);
writematrix(Diff_LTspice, File_Loc_Excel_Table, "Sheet", Sheet_Table_1, "Range", 'G2')
writematrix(Percent_Diff_LTspice, File_Loc_Excel_Table, "Sheet", Sheet_Table_1, "Range", 'H2')

%-------------------------------------------------------------------------

[Diff_Meas, Percent_Diff_Meas] = Percent_Difference(M_D, M_D_Meas);
writematrix(Diff_Meas, File_Loc_Excel_Table, "Sheet", Sheet_Table_1, "Range", 'J2')
writematrix(Percent_Diff_Meas, File_Loc_Excel_Table, "Sheet", Sheet_Table_1, "Range", 'K2')

%-------------------------------------------------------------------------