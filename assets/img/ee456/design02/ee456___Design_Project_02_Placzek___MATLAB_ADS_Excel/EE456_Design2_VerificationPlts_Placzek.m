 %-------------------------------------------------------------------
clc
close all
clear
%-------------------------------------------------------------------
G = 10^+9;
M = 10^+6;
%-------------------------------------------------------------------
% Problem Values
%-------------------------------------------------------------------
Z0 = 50;
ZT = 50;
f_min = 14*G;
f0 = 15*G;
f_max = 16*G;
df = 5*M;
theta_P = 90;

Input = 1;
theta_I1 = 43.2481;
theta_I2 = 10.4170;
Output = 3;
theta_O1 = 31.2559;
theta_O2 = 53.5158;
%-------------------------------------------------------------------
% Graph Formnating
%-------------------------------------------------------------------
NF = 28;
IFigure = 0;
P1=8;
M1=2*P1;
P2=P1/2;
M2=2*P2;
%-------------------------------------------------------------------
%  ADS DATA IN
%-------------------------------------------------------------------
[freq_MGF, S_MGF, Mult, ~, freq_Noise, Fmin_f_dB, Gamma_OPT_f, rn_f] = Read_SParam_s2p('MGF4941AL.s2p');
freq_MGF = freq_MGF * Mult;
I_f0S_MGF = ismember(freq_MGF, f0);
freq_Noise = freq_Noise * Mult;
In_f0S_MGF = ismember(freq_Noise, f0);

opts = delimitedTextImportOptions("NumVariables", 2);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["freqReferencesnf2DependencyfreqNumPoints401MatrixSizeScalarType", "nf2ReferencesDependencyfreqNumPoints401MatrixSizeScalarTypeReal"];
opts.VariableTypes = ["double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, "freqReferencesnf2DependencyfreqNumPoints401MatrixSizeScalarType", "TrimNonNumeric", true);
opts = setvaropts(opts, "freqReferencesnf2DependencyfreqNumPoints401MatrixSizeScalarType", "ThousandsSeparator", ",");

% Import the data
ADS_Noise_Table = readtable("C:\Users\Adminimal\Documents\MATLAB\WNE_Matlab\bullshizzle\EE456_Dp2_Placzek_Finalrev\Noise_Data_Exported_From_ADS.csv", opts);
clear opts
bits=table2array(ADS_Noise_Table);
N=length(bits);
freq_noise_bs = transpose(bits(1:N,1));
FN_DB=transpose(bits(1:N,2));

% Import the data
% [~, S_IMN_ADS, ~] = Read_SParam_s2p('IMN Plot.s2p');
[~, S_IMN_ADS, ~] = Read_SParam_s2p('EE456_Design_Project_2_Placzek_IMN.s2p');
Gamma_S_ADS = S_IMN_ADS(:, 2, 2);

% Import the data
[freq_ADS, S_ADS, Mult_ADS, S_Type, bs, Fmin_dB_ADS, Gamma_OPT_ADS, rn_ADS] = Read_SParam_s2p('EE456_Design_Project_2_Placzek_Whole_SPout.s2p');
freq_ADS = freq_ADS * Mult_ADS;
I_f0_ADS = find(freq_ADS == f0);

% Import the data
[~, S_IMN_ADS, ~] = Read_SParam_s2p('EE456_Design_Project_2_Placzek_IMN.s2p');
Gamma_S_ADS = S_IMN_ADS(:, 2, 2);

% Import the data
[~, S_OMN_ADS, ~] = Read_SParam_s2p('EE456_Design_Project_2_Placzek_OMN.s2p');
Gamma_L_ADS = S_OMN_ADS(:, 1, 1);

% Import the data
[~, S_In_ADS, ~] = Read_SParam_s2p('EE456_Design_Project_2_Placzek_In.s2p');
Gamma_in_ADS = S_In_ADS(:, 1, 1);

% Import the data
[~, S_Out_ADS, ~] =  Read_SParam_s2p('EE456_Design_Project_2_Placzek_Out.s2p');
Gamma_out_ADS = S_Out_ADS(:, 2, 2);


%-------------------------------------------------------------------

S11 = S_MGF(:, 1, 1);
S11_Mag = abs(S11);
S11_dB = 20*log10(S11_Mag);
S21 = S_MGF(:, 2, 1);
S21_Mag = abs(S21);
S21_dB = 20*log10(S21_Mag);
S22 = S_MGF(:, 2, 2);
S22_Mag = abs(S22);
S22_dB = 20*log10(S22_Mag);
S12 = S_MGF(:, 1, 2);
S12_Mag = abs(S12);
S12_dB = 20*log10(S12_Mag);
%-------------------------------------------------------------------
S_f0(1:2, 1:2) = S_MGF(I_f0S_MGF, :, :);
S11_f0 = S11(I_f0S_MGF);
S11_f0_dB = S11_dB(I_f0S_MGF);
S21_f0 = S21(I_f0S_MGF);
S21_f0_dB = S21_dB(I_f0S_MGF);
S22_f0 = S22(I_f0S_MGF);
S22_f0_dB = S22_dB(I_f0S_MGF);
S12_f0 = S12(I_f0S_MGF);
S12_f0_dB = S12_dB(I_f0S_MGF);
S21_f0_Mag = abs(S21_f0);

%-------------------------------------------------------------------


%-------------------------------------------------------------------
S_MGF_f0(1:2, 1:2) = S_MGF(I_f0S_MGF, :, :);
S21_MGF_f0 = S_MGF_f0(2, 1);
S21_MGF_f0_Mag = abs(S21_MGF_f0);
S21_MGF_f0_dB = 20*log10(S21_MGF_f0_Mag);
Fmin_dB = Fmin_f_dB(In_f0S_MGF);

%-------------------------------------------------------------------
freq_MAT = f_min : df : f_max;
freq_MAT = freq_MAT';
I_f0_MAT = ismember(freq_MAT, f0);
N_Freq = length(freq_MAT);
S_MAT = zeros(N_Freq, 2, 2);
F_MAT_dB = zeros(size(freq_MAT));
Gamma_S_x = F_MAT_dB;

%------------------------------------------------------------------
% Cascading
% Input Matching Network,
% Device
% Output Matching Network
%-------------------------------------------------------------------
for kk = 1 : N_Freq
fk = freq_MAT(kk);
theta_P_fk = (fk / f0) * theta_P;
theta_I1_fk = (fk / f0) * theta_I1;
theta_I2_fk = (fk / f0) * theta_I2;
theta_O1_fx = (fk / f0) * theta_O1;
theta_O2_fx = (fk / f0) * theta_O2;
T0 =  EE456_ABCD_TRL(Z0, theta_P_fk);
TI1 = EE456_ABCD_Shunt_OC_Stub(Z0, theta_I1_fk);
TI2 = EE456_ABCD_TRL(Z0, theta_I2_fk);
TO2 = EE456_ABCD_TRL(Z0, theta_O2_fx);
TO1 = EE456_ABCD_Shunt_OC_Stub(Z0, theta_O1_fx);
T_IMN = T0*T0*TI1*TI2;
T_OMN = TO2*TO1*T0*T0;
Sx = S_Param_Interp(S_MGF, freq_MGF, fk);
Tx = S_to_ABCD(Sx, Z0);
T = T_IMN*Tx*T_OMN;
S_MAT(kk, :, :) = ABCD_to_S(T, [Z0 Z0]);
S_IMN = ABCD_to_S(T_IMN, Z0);
S_OMN = ABCD_to_S(T_OMN, Z0);
Gamma_S_x(kk) = S_IMN(2, 2);
Gamma_L_x(kk) = S_OMN(2, 2);
[Fmin_dB_x, Gamma_OPT_x, rn_x] = NF_Param_Interp(Fmin_f_dB, Gamma_OPT_f, rn_f, freq_Noise, fk);
Temp_Fmin_dB_x(kk)=Fmin_dB_x;
Temp_Gamma_OPT_x(kk)=Gamma_OPT_x;
Temp_rn_x(kk)=rn_x;

F_MAT_dB(kk) = F_Amp_Calc(Fmin_dB_x, rn_x, Gamma_OPT_x, Gamma_S_x(kk));
end
%-------------------------------------------------------------------

S11_MAT = S_MAT(:, 1, 1);
S11_MAT_Mag = abs(S11_MAT);
S11_MAT_dB = 20*log10(S11_MAT_Mag);
S21_MAT = S_MAT(:, 2, 1);
S21_MAT_Mag = abs(S21_MAT);
S21_MAT_dB = 20*log10(S21_MAT_Mag);
S22_MAT = S_MAT(:, 2, 2);
S22_MAT_Mag = abs(S22_MAT);
S22_MAT_dB = 20*log10(S22_MAT_Mag);
S12_MAT = S_MAT(:, 1, 2);
S12_MAT_Mag = abs(S12_MAT);
S12_MAT_dB = 20*log10(S12_MAT_Mag);

A=transpose(Gamma_S_x);
[x_Index, VI, Percent_Diff]=Find_Closest_Value(freq_MAT,f0);
Gamma_S_MAT_f0=A(VI);
A=transpose(Gamma_L_x);
Gamma_L_MAT_f0=A(VI);

%-------------------------------------------------------------------

S_MAT_f0(1:2, 1:2) = S_MAT(I_f0_MAT, :, :);
S11_MAT_f0 = S11_MAT(I_f0_MAT);
S11_MAT_f0_dB = S11_MAT_dB(I_f0_MAT);
S21_MAT_f0 = S21_MAT(I_f0_MAT);
S21_MAT_f0_dB = S21_MAT_dB(I_f0_MAT);
S22_MAT_f0 = S22_MAT(I_f0_MAT);
S22_MAT_f0_dB = S22_MAT_dB(I_f0_MAT);
S12_MAT_f0 = S12_MAT(I_f0_MAT);
S12_MAT_f0_dB = S12_MAT_dB(I_f0_MAT);
S21_MAT_f0_Mag = abs(S21_MAT_f0);
F_MAT_f0_dB = F_MAT_dB(I_f0_MAT);
Gamma_S_MAT = Gamma_S_x(I_f0_MAT);
Gamma_out_MAT_f0 = S22_MAT_f0 + (S12_MAT_f0 .* S21_MAT_f0 .* Gamma_S_MAT_f0) ./ (1 - S11_MAT_f0 .* Gamma_S_MAT_f0);
Gamma_in_MAT_f0 =S11_MAT_f0+(S12_MAT_f0.*S21_MAT_f0.*Gamma_L_MAT_f0)./(1-S22_MAT_f0.*Gamma_L_MAT_f0);

%-------------------------------------------------------------------

MGamma_IMN_MAT = S11_MAT_f0;
MGamma_IMN_MAT_db = 20*log10(MGamma_IMN_MAT);
%-------------------------------------------------------------------
MGamma_OMN_MAT = S22_MAT_f0;
MGamma_OMN_MAT_db = 20*log10(MGamma_OMN_MAT);
%-------------------------------------------------------------------
Num = 1 + S11_MAT_Mag;
Den = 1 - S11_MAT_Mag;
VSWR_IMN_MAT = Num ./ Den;
Num_OMN = 1 + S22_MAT_Mag;
Den_OMN = 1 - S22_MAT_Mag;
VSWR_OMN_MAT = Num_OMN ./ Den_OMN;
%-------------------------------------------------------------------
VSWR_IMN_MAT_f0 = VSWR_IMN_MAT(I_f0_MAT);
VSWR_OMN_MAT_f0 = VSWR_OMN_MAT(I_f0_MAT);
%-------------------------------------------------------------------
GT_MAT = abs(S21_MAT_f0)^2;
GTdb_MAT = 10*log10(GT_MAT);

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

%-------------------------------------------------------------------

S_ADS_f0(1:2, 1:2) = S_ADS(I_f0_ADS, :, :);
S11_ADS_f0 = S11_ADS(I_f0_ADS);
S11_ADS_f0_dB = S11_ADS_dB(I_f0_ADS);
S21_ADS_f0 = S21_ADS(I_f0_ADS);
S21_ADS_f0_dB = S21_ADS_dB(I_f0_ADS);
S22_ADS_f0 = S22_ADS(I_f0_ADS);
S22_ADS_f0_dB = S22_ADS_dB(I_f0_ADS);
S12_ADS_f0 = S12_ADS(I_f0_ADS);
S12_ADS_f0_dB = S12_ADS_dB(I_f0_ADS);
S21_ADS_f0_Mag = abs(S21_ADS_f0);

%-------------------------------------------------------------------
MGamma_IMN_ADS = S11_ADS_f0;
MGamma_IMN_ADS_db = 20*log10(MGamma_IMN_ADS);
%-------------------------------------------------------------------
MGamma_OMN_ADS = S22_ADS_f0;
MGamma_OMN_ADS_db = 20*log10(MGamma_OMN_ADS);
%-------------------------------------------------------------------
Num = 1 + S11_ADS_Mag;
Den = 1 - S11_ADS_Mag;
VSWR_IMN_ADS = Num ./ Den;
Num_OMN_ADS = 1 + S22_ADS_Mag;
Den_OMN_ADS = 1 - S22_ADS_Mag;
VSWR_OMN_ADS = Num_OMN_ADS ./ Den_OMN_ADS;
%-------------------------------------------------------------------
VSWR_IMN_ADS_f0 = VSWR_IMN_ADS(I_f0_ADS);
VSWR_OMN_ADS_f0 = VSWR_OMN_ADS(I_f0_ADS);
%-------------------------------------------------------------------
GT_ADS = abs(S21_ADS_f0)^2;
GTdb_ADS = 10*log10(GT_ADS);
%-------------------------------------------------------------------
% FIGURE 1: |S21|dB

F_ADS_dB = F_Amp_Calc(Fmin_dB_ADS, transpose(Temp_rn_x), transpose(Temp_Gamma_OPT_x), Gamma_S_ADS);

IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S21_ADS_dB, 'r', 'linewidth', P1)
hold on
plot(f0/G, S21_ADS_f0_dB, 'ro', 'linewidth', M1)
hold on
plot(freq_MAT/G, S21_MAT_dB, 'g', 'linewidth', P2)
hold on
plot(f0/G, S21_MAT_f0_dB, 'go', 'linewidth', M2)
hold off
grid on
grid minor
xlabel('{\itf}   (GHz) ')
ylabel('| {\itS}_{21} |    ( dB ) ', ...
   'VerticalAlignment', 'bottom')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, 11.25, 12.5])
ax = gca;
ax.XTick = f_min/G : 0.2 : f_max/G;
ax.YTick = 11.25 : 0.25 : 12.5;
set(gca, 'linewidth', 2.5)
title('S21')
legend('ADS {\itS}_{21}', '', 'MATLAB {\itS}_{21}' , '' , 'location', 'best')

%-------------------------------------------------------------------
% FIGURE 2: |S11|dB

IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S11_ADS_dB, 'r', 'linewidth', P1)
hold on
plot(f0/G, S11_ADS_f0_dB, 'ro', 'linewidth', M1)
hold on
plot(freq_MAT/G, S11_MAT_dB, 'g', 'linewidth', P2)
hold on
plot(f0/G, S11_MAT_f0_dB, 'go', 'linewidth', M2)
hold off
grid on
grid minor
xlabel('{\itf}   (GHz) ')
ylabel('| {\itS}_{11} |    ( dB ) ', ...
   'VerticalAlignment', 'bottom')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 0.2 : f_max/G;
ax.YTick = -25 : 5 : 0;
set(gca, 'linewidth', 2.5)
title('S11')
legend('ADS {\itS}_{11}', '', 'MATLAB {\itS}_{11}' , '' , 'location', 'best')

%-------------------------------------------------------------------
% FIGURE 3: |S22|dB

IFigure = IFigure + 1;
figure_max(IFigure)
plot(freq_ADS/G, S22_ADS_dB, 'r', 'linewidth', P1)
hold on
plot(f0/G, S22_ADS_f0_dB, 'ro', 'linewidth', M1)
hold on
plot(freq_MAT/G, S22_MAT_dB, 'g', 'linewidth', P2)
hold on
plot(f0/G, S22_MAT_f0_dB, 'go', 'linewidth', M2)
hold off
grid on
grid minor
xlabel('{\itf}   (GHz) ')
ylabel('| {\itS}_{22} |    ( dB ) ', ...
   'VerticalAlignment', 'bottom')
set(gca, 'FontName', 'times new roman', 'FontSize', NF)
axis([f_min/G, f_max/G, -25, 0])
ax = gca;
ax.XTick = f_min/G : 0.2 : f_max/G;
ax.YTick = -25 : 5 : 0;
set(gca, 'linewidth', 2.5)
title('S22')
legend('ADS {\itS}_{22}', '', 'MATLAB {\itS}_{22}' , '' , 'location', 'best')

%-------------------------------------------------------------------
% FIGURE 4: IMN VSWR Plot

IFigure = IFigure + 1;
figure_max(IFigure)
% Plot ADS IMN VSWR
plot(freq_ADS/G, VSWR_IMN_ADS, 'r', 'LineWidth', P1)
hold on
plot(f0/G, VSWR_IMN_ADS_f0, 'ro', 'LineWidth', M1, 'MarkerFaceColor', 'r')
% Plot MATLAB IMN VSWR
plot(freq_ADS/G, VSWR_IMN_MAT, 'g', 'LineWidth', P2)
plot(f0/G, VSWR_IMN_MAT_f0, 'go', 'LineWidth', M2, 'MarkerFaceColor', 'g')
grid on
grid minor
xlabel('{\itf} (GHz)')
ylabel('{\itVSWR} (V)')
title('VSWR – Input Matching Network (IMN)')
legend('ADS {\itVSWR}_{IMN}', ...
       'ADS {\itVSWR}_{IMN} @ {\itf} = {\itf}_0', ...
       'MATLAB {\itVSWR}_{IMN}', ...
       'MATLAB {\itVSWR}_{IMN} @ {\itf} = {\itf}_0', ...
       'Location', 'best')

set(gca, 'FontName', 'Times New Roman', 'FontSize', NF)
set(gca, 'LineWidth', 2.5)
axis([14, 16, 1, 2])
ax = gca;
ax.XTick = 14 : 0.25 : 16;
ax.YTick = 1 : 0.25 : 2;

%------------------------------------------------------------------------
% FIGURE 5: OMN VSWR Plot

IFigure = IFigure + 1;
figure_max(IFigure)
% Plot ADS OMN VSWR
plot(freq_ADS/G, VSWR_OMN_ADS, 'm', 'LineWidth', P1)
hold on
plot(f0/G, VSWR_OMN_ADS_f0, 'mo', 'LineWidth', M1, 'MarkerFaceColor', 'm')
% Plot MATLAB OMN VSWR
plot(freq_ADS/G, VSWR_OMN_MAT, 'c', 'LineWidth', P2)
plot(f0/G, VSWR_OMN_MAT_f0, 'co', 'LineWidth', M2, 'MarkerFaceColor', 'c')
grid on
grid minor
xlabel('{\itf} (GHz)')
ylabel('{\itVSWR} (V)')
title('VSWR – Output Matching Network (OMN)')
legend('ADS {\itVSWR}_{OMN}', ...
       'ADS {\itVSWR}_{OMN} @ {\itf} = {\itf}_0', ...
       'MATLAB {\itVSWR}_{OMN}', ...
       'MATLAB {\itVSWR}_{OMN} @ {\itf} = {\itf}_0', ...
       'Location', 'best')
set(gca, 'FontName', 'Times New Roman', 'FontSize', NF)
set(gca, 'LineWidth', 2.5)
axis([14, 16, 1, 2])
ax = gca;
ax.XTick = 14 : 0.25 : 16;
ax.YTick = 1 : 0.25 : 2;

%-------------------------------------------------------------------------
% FIGURE 6: Noise Plot

IFigure = IFigure + 1;
figure_max(IFigure)
hold on
[~, I] = min(abs(freq_noise_bs - f0/G));
% Plot ADS
h1 = plot(freq_noise_bs, FN_DB, 'r', 'linewidth', P1);
h2 = plot(f0/G, FN_DB(I), 'ro', 'MarkerSize', 16, 'MarkerFaceColor', 'r');
% Plot MATLAB
h3 = plot(freq_MAT/G, F_MAT_dB, 'g', 'linewidth', 4);
h4 = plot(f0/G, F_MAT_f0_dB, 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
grid on
grid minor
hold off
xlabel('{\itf}   (GHz)')
ylabel('Noise Figure (dB)')
title('Noise Figure')
set(gca, 'FontName', 'Times New Roman', 'FontSize', NF)
set(gca, 'LineWidth', 2)
MinY = 0.5;
MaxY = ceil(max([F_MAT_dB(:); FN_DB(:)]));
axis([f_min/G, f_max/G, 0.5, 0.7])
ax = gca;
ax.XTick = f_min/G : 0.25 : f_max/G;
ax.YTick = MinY : 0.05 : MaxY;
legend([h1 h2 h3 h4], ...
    'ADS {\itF}_{dB}', ...
    'ADS {\itF}_{dB}, {\itf} = {\itf}_0', ...
    'MATLAB {\itF}_{dB}', ...
    'MATLAB {\itF}_{dB}, {\itf} = {\itf}_0', ...
    'Location', 'best')

%-------------------------------------------------------------------------

Print_Title('EE456 Design Project 2 - ADS vs Matlab Simulated Values')

%-------------------------------------------------------------------------

Print_Text('MAT Lab Values')
Print_Polar('Gamma_in_MAT', Gamma_in_MAT_f0)
Print_Polar('Gamma_out_MAT', Gamma_out_MAT_f0)
Print_Real('MGamma_IMN_MAT_db', MGamma_IMN_MAT_db, 'dB')
Print_Real('MGamma_IMN_MAT', MGamma_IMN_MAT)
Print_Real('VSWR_IMN_MAT', VSWR_IMN_MAT_f0)
Print_Real('MGamma_OMN_MAT_db', MGamma_OMN_MAT_db, 'dB')
Print_Real('MGamma_OMN_MAT', MGamma_OMN_MAT)
Print_Real('VSWR_OMN_MAT', VSWR_OMN_MAT_f0)
Print_Real('GTdb_MAT', GTdb_MAT, 'dB')
Print_Real('GT_MAT', GT_MAT, 'W/W')
Print_Real('F MAT MAT',F_MAT_f0_dB)

%-------------------------------------------------------------------------

Print_Text('ADS Values')
Print_Polar('Gamma_in_ADS', Gamma_in_ADS)
Print_Polar('Gamma_out_ADS', Gamma_out_ADS)
Print_Real('MGamma_IMN_ADS_db', MGamma_IMN_ADS_db, 'dB')
Print_Real('MGamma_IMN_ADS', MGamma_IMN_ADS)
Print_Real('VSWR_IMN_ADS', VSWR_IMN_ADS_f0)
Print_Real('MGamma_OMN_ADS_db', MGamma_OMN_ADS_db, 'dB')
Print_Real('MGamma_OMN_ADS', MGamma_OMN_ADS)
Print_Real('VSWR_OMN_ADS', VSWR_OMN_ADS_f0)
Print_Real('GTdb_ADS', GTdb_ADS, 'dB')
Print_Real('F ADS',FN_DB(I))

%-------------------------------------------------------------------------
