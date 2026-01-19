%-------------------------------------------------------------------------

function EE_319_Lab_01_HPF_Placzek

%-------------------------------------------------------------------------
% EE 319
% Lab 01 HPF
% Matlab Calculations, Simulations, Measurements, & Results
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
    'Lab 03 HPF Results.xlsx';
File_Loc_Excel_Table = ...
    [Folder_Excel, '/', FileName_Excel_Table];
Sheet_Table_1 = 'Table 1';

%-------------------------------------------------------------------------
% LTspice Placeholder

File_LTspice_TF = 'EE 319 Lab 01 HPF TF.raw';
File_Loc_LTspice_TF = ...
    [Folder_LTspice, '/', File_LTspice_TF];

File_LTspice_Bode = 'EE 319 Lab 01 HPF Bode.raw';
File_Loc_LTspice_Bode = ...
    [Folder_LTspice, '/' , File_LTspice_Bode];

%-------------------------------------------------------------------------

FileName_Measured_Data = ...
    'EE 319 Lab 01 HPF Measured Bode.csv';
File_Loc_Measured_Data = ...
    [Folder_Measured, '/HPF/', FileName_Measured_Data];

R1 = 10*k;
R2 = 10*k;
% C1 = 3.3*n;
C2 = 56*n;
f_min = 10;
f_max = 100*k;
NF = 32;
IFigure = 0;

%-------------------------------------------------------------------------

G1 = 1/R1;
G2 = 1/R2;
a1 = G1*C2;
b1 = (G2*C2)*(G1*C2);
b0 = G1*G2;
Num = [a1, 0];
Den = [b1, b0];
wL = G1*G2 / (C2*G1 + C2*G2);
fL = wL / (2*pi);
Av_HF = (G2 /(G1 + G2));
Av_HF_Mag = abs(Av_HF);
Av_HF_dB = 20*log10(Av_HF_Mag);

%-------------------------------------------------------------------------

N_min = floor(log10(f_min));
N_max = ceil(log10(f_max));
N_Dec = N_max - N_min;
NPoints_Dec = 100;
NFreq = NPoints_Dec * N_Dec + 1;
freq = logspace(N_min, N_max, NFreq);
if sum((freq == fL))==0, freq = sort([freq, fL]); end

%-------------------------------------------------------------------------

w = 2 * pi * freq;
s = 1j * w;
Num_f = polyval(Num, s);
Den_f = polyval(Den, s);
Av_f = (1)*(Num_f ./ Den_f);
[Av_f_Mag, Av_f_Ang] = Rect_2_Polar(Av_f);
Av_f_dB = 20*log10(Av_f_Mag);
I_fL = freq == fL;
Av_fL = Av_f(I_fL);
[Av_fL_Mag, Av_fL_Ang] = Rect_2_Polar(Av_fL);
Av_fL_dB = 20*log10(Av_fL_Mag);

%-------------------------------------------------------------------------

[freq_Meas, Av_f_Meas, ~, ~, ~] = ...
    Read_AD_Bode(File_Loc_Measured_Data);
[fL_Meas, Av_fL_Meas, ...
    freq_Meas, ~, ~, ...
    Av_f_Meas_dB, Av_f_Meas_Ang, ...
    Av_HF_Meas, ~, Av_HF_Meas_dB, ...
    Av_fL_Meas_dB, Av_fL_Meas_Ang] = ...
    HPF_Param_AD(freq_Meas, Av_f_Meas);

%-------------------------------------------------------------------------

[freq_Meas, Av_f_Meas, Av_f_Meas_Mag,...
    Av_f_Meas_dB, Av_f_Meas_ang] = ...
    Read_AD_Bode(File_Loc_Measured_Data);

%-------------------------------------------------------------------------
% makes freq_Meas & Av_f_Meas_Ang the same length by truncating or padding

min_length = min(length(freq_Meas), length(Av_f_Meas_Ang));
freq_Meas = freq_Meas(1:min_length);
Av_f_Meas_Ang = Av_f_Meas_Ang(1:min_length);


%-------------------------------------------------------------------------

[freq_LTspice, Av_f_LTspice, ~, ~, ~, ~] = ...
    Read_LTspice_Bode(File_Loc_LTspice_Bode, 'vo');
[fL_LTspice, Av_fL_LTspice, ...
    freq_LTspice, ~, ~, ...
    Av_f_LTspice_dB, Av_f_LTspice_Ang, ...
    Av_HF_LTspice, ~, Av_HF_LTspice_dB, ...
    Av_fL_LTspice_dB, Av_fL_LTspice_Ang] = ...
    HPF_Param_LTspice(freq_LTspice, Av_f_LTspice);


%-------------------------------------------------------------------------

[fL_Meas, Av_fL_Meas, ...
    freq_Meas, Av_f, Av_f_Meas_Mag, ...
    Av_f_Meas_dB, Av_f_Meas_Ang, ...
    Av_HF_Meas, Av_HF_Meas_Mag, Av_HF_Meas_dB, ...
    Av_fL_Meas_dB, Av_fL_Meas_Ang] = ...
    HPF_Param_AD(freq_Meas, Av_f_Meas);

%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
% Figure 1
% Task 2 - Plot Gain Measured
% Range of -30dB to -5 dB for the gain

IFigure = IFigure + 1;
figure_max(IFigure)
% semilogx(freq, Av_f_dB, 'r', 'LineWidth', 9)
hold on
semilogx(freq_LTspice, Av_f_LTspice_dB, 'g', 'LineWidth', 7)
semilogx(freq_Meas, Av_f_Meas_dB, 'b', 'LineWidth', 7)
hold off
grid on
xlabel('Frequency $\it{f}$ (Hz)', 'Interpreter', 'latex')
ylabel('$\tilde{A}_v(f)_\mathrm{dB}$', 'Interpreter', 'latex')
title('High-Pass Filter Response')
legend(' Simulated', ' Measured', ...
    'Location', 'best')

xlim([10, 1e5])  % Domain of 10 Hz to 100 kHz
ylim([-30, -5])  % Range of -30 dB to -5 dB

set(gca, 'XScale', 'log')
set(gca, 'linewidth', 2.5)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)

set(gca, 'YMinorTick', 'on')
grid minor


%-------------------------------------------------------------------------
% Figure 2
% Task 3: Plot Measured Phase
% 10 Hz to 100 kHz for frequency
% 0 degrees to +90 degrees for phase

Av_Ang_min = 0;
Av_Ang_max = +90;

IFigure = IFigure + 1;
figure_max(IFigure)
semilogx(freq_Meas, unwrap(Av_f_Meas_Ang), 'r', 'linewidth', 9)
hold on
semilogx(freq_Meas, unwrap(Av_f_Meas_Ang), 'r', 'linewidth', 9)
semilogx(fL_Meas, Av_fL_Meas_Ang, 'ro', 'linewidth', 13)
hold off
grid on
grid minor
xlabel('$\it{f}$ (Hz)', 'Interpreter', 'latex')
ylabel('{\theta} (°)', 'VerticalAlignment', 'bottom')
title('Bode Phase Plot: Measured Results')
axis([f_min, f_max, Av_Ang_min, Av_Ang_max])

yticks = Av_Ang_min : 15 : Av_Ang_max;
set(gca, 'YTick', yticks)

set(gca, 'YMinorTick', 'off')
set(gca, 'YMinorGrid', 'on')

legend(' Measured', 'Location', 'best')
set(gca, 'linewidth', 2.5)
set(gca, 'FontName', 'times new roman', 'FontSize', NF)

%-------------------------------------------------------------------------

Print_Text('Component Values:')

Print_Real_Unit('R1', R1, 'Ohms')
Print_Real_Unit('R2', R2, 'Ohms')
Print_Real_Unit('C2', C2, 'F')

Print_Break

Print_Text('Calculated Values:')

Print_Break

Print_Rect_Unit('G1', G1, 'S')
Print_Rect_Unit('G2', G2, 'S')

Print_Break

Print_Real_Unit('Av_HF', Av_HF, 'V/V')
Print_Real('Av_HF', Av_HF_dB, 'dB')
Print_Real_Unit('fL', fL, 'Hz')
Print_Polar_Unit('Av_fL', Av_fL, 'V/V')

Print_Break

Print_Real_Unit('fL', fL, 'Hz')
Print_Polar_Unit('Av(fL)', Av_f(freq == fL), 'V/V')
Print_Real('Av(fL)', Av_f_dB(freq == fL), 'dB')

Print_Break

Print_Text('Simulated Values from LTSpice:')

Print_Real_Unit('fL_LTspice', fL_LTspice, 'Hz')
Print_Real_Unit('Av_fL_LTspice', Av_fL_LTspice, 'V/V')
Print_Real_Unit('Av_fL_LTspice_dB', Av_fL_LTspice_dB, 'dB')
Print_Real_Unit('Av_HF_LTspice', Av_HF_LTspice, 'V/V')
Print_Real_Unit('Av_HF_LTspice_dB', Av_HF_LTspice_dB, 'dB')

Print_Break

Print_Break

Print_Text('Analog Discovery Measured Values:')

Print_Real_Unit('Av_HF_Meas', Av_HF_Meas, 'V/V')
Print_Real('Av_HF_Meas', Av_HF_Meas_dB, 'dB')
Print_Real_Unit('fL_Meas', fL_Meas, 'Hz')
Print_Polar_Unit('Av_fL_Meas', Av_fL_Meas, 'V/V')

Print_Break

Print_Real_Unit('fL_Meas', fL_Meas, 'Hz')
Print_Polar_Unit('Av(fL_Meas)', Av_fL_Meas, 'V/V')
Print_Real('Av(fL_Meas', Av_HF_Meas_dB, 'dB')

Print_Break

Print_Real_Unit('fL_Meas', fL_Meas, 'Hz')
Print_Real_Unit('T_Meas', 1/fL_Meas, 's')
Print_Real_Unit('0.3T_Meas', 0.3/fL_Meas, 's/div')

Print_End