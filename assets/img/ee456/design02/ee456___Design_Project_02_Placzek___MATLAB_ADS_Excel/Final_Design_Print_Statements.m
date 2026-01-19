%% Print Statements

clear; clc; close all;

load('C:\Users\Adminimal\Documents\MATLAB\WNE_Matlab\bullshizzle\EE456_Dp2_Placzek_Finalrev\Design2_GPU_26GbMemory.mat')

%% Display Parameters - MAG Design

Print_Title('MAG Design');
Print_Polar('S11', S11);
Print_Polar('S12', S12);
Print_Polar('S21', S21);
Print_Polar('S22', S22);
Print_Polar('Gamma_S', Gamma_S);
Print_Polar('Gamma_L', Gamma_L);
Print_Polar('Gamma_in', Gamma_in);
Print_Polar('Gamma_out', Gamma_out);
Print_Real('Gamma_IMN_Mag', Gamma_IMN_Mag);
Print_Real('Gamma_IMN_Mag_dB', 20 * log10(Gamma_IMN_Mag));
Print_Real('VSWR_IMN', VSWR_IMN);
Print_Real('Gamma_OMN_Mag', Gamma_OMN_Mag);
Print_Real('Gamma_OMN_Mag_dB', 20 * log10(Gamma_OMN_Mag));
Print_Real('VSWR_OMN', VSWR_OMN);
Print_Real_Unit('GT', GT, 'W/W');
Print_Real_Unit('GT_dB', GT_dB, 'dB');
Print_Real('F_dB_MAG', F_dB_MAG, 'dB');


%% Fmin Design

Print_Title('Fmin Design');
% Find index of Gamma_S_fmin
[min_Gamma_S_fmin_value, min_Gamma_S_fmin_idx] = min(Gamma_S_fmin);

% Print just that value
fprintf('Gamma_S_fmin: Gamma_S_fmin(%d) = %.4f\n', min_Gamma_S_fmin_idx, min_Gamma_S_fmin_value);

Print_Polar('Gamma_L_fmin', Gamma_L_fmin);
Print_Polar('Gamma_in_fmin', Gamma_in_fmin);
Print_Polar('Gamma_out_fmin', Gamma_out_fmin);
Print_Real('Gamma_IMN_Mag_fmin', Gamma_IMN_Mag_fmin);
Print_Real('Gamma_IMN_Mag_dB_fmin', 20 * log10(Gamma_IMN_Mag_fmin));
Print_Real('VSWR_IMN_fmin', VSWR_IMN_fmin);
Print_Real('Gamma_OMN_Mag_fmin', Gamma_OMN_Mag_fmin);
Print_Real('Gamma_OMN_Mag_dB_fmin', 20 * log10(Gamma_OMN_Mag_fmin));
Print_Real('VSWR_OMN_fmin', VSWR_OMN_fmin);
Print_Real_Unit('GT_dB_fmin', GT_dB_fmin, 'dB');
Print_Real('F_dB_fmin', F_min_dB, 'dB');

%% Gamma_L Points
% [~, Gamma_L_Pn_Design_2_Pt_1, Gamma_L_Pn_Design_2_Pt_2, ...
%     Gamma_L_Pn_Design_2_Pt_3, Gamma_L_Pn_Design_2_Pt_4] = ...
%     Gamma_Points_finder(Gamma_ML, rvo, Cvo);
% Print_Polar('Gamma_L_Pt1_Design_2 (Point 1)', Gamma_L_Pn_Design_2_Pt_1(1));
% Print_Polar('Gamma_L_Pt2_Design_2 (Point 2)', Gamma_L_Pn_Design_2_Pt_2(2));
% Print_Polar('Gamma_L_Pt3_Design_2 (Point 3)', Gamma_L_Pn_Design_2_Pt_3(3));
% Print_Polar('Gamma_L_Pt4_Design_2 (Point 4)', Gamma_L_Pn_Design_2_Pt_4(4));
%% Design 1 Print Statements
Print_Title('Design 1 Results:')

S11p = Rect_2_Polar(S11);
S12p = Rect_2_Polar(S12);
S21p = Rect_2_Polar(S21);
S22p = Rect_2_Polar(S22);

Print_Text('S-Parameters:')
Print_Polar('S11', S11p);
Print_Polar('S12', S12p);
Print_Polar('S21', S21p);
Print_Polar('S22', Rect_2_Polar(S22));

Print_Real('S11_dB', S11_dB, 'dB');
Print_Real('S12_dB', S12_dB, 'dB');
Print_Real('S21_dB', S21_dB, 'dB');
Print_Real('S22_dB', S22_dB, 'dB');

Print_Polar('Gamma_S_Design_1', Gamma_S_Design_1_best);
MGamma_IMN_dB = 20 .* log10(Gamma_IMN_Mag_Design_1(i));
Print_Real_Unit('MGamma_IMN_dB', MGamma_IMN_dB, 'dB');

MGamma_IMN_Amp_db = 20 .* log10(Gamma_IMN_Mag_Design_1(i));
Print_Real_Unit('MGamma_IMN_dB', MGamma_IMN_dB, 'dB');

MGamma_IMN_Amp = Gamma_IMN_Mag_Design_1(i);
Print_Real('MGamma_IMN_Amp', MGamma_IMN_Amp);

VSWR_IMN_Amp = VSWR_IMN_Design_1(i);
Print_Real('VSWR_IMN_Design_1', VSWR_IMN_Amp);

Print_Break;

MGamma_OMN_Amp_db = 20 .* log10(Gamma_OMN_Mag_Design_1(i));
Print_Real_Unit('MGamma_OMN_dB', MGamma_OMN_Amp_db, 'dB');

MGamma_OMN_Amp = Gamma_OMN_Mag_Design_1(i);    
Print_Real('MGamma_OMN_Design_1', MGamma_OMN_Amp);

VSWR_OMN_Amp = VSWR_OMN_Design_1(i);
Print_Real('VSWR_OMN_Design_1', VSWR_OMN_Amp);

Print_Break;

GTdb_Amp =  GT_dB_Design_1(i);
Print_Real_Unit('GTdb_Amp_Design_1', GTdb_Amp, 'dB');

GT_Amp = GT_Design_1(i);
Print_Real_Unit('GT_Design_1', GT_Amp, 'W/W')

F_Amp_MAT_dB =  F_Design_1_dB(i);
Print_Real_Unit('F_Amp_Design_1_dB', F_Amp_MAT_dB, 'dB');

%% Design 2 Print Statements

Print_Title('Design 2 Summary:')

Print_Polar('Gamma_S_Design_2', Gamma_S_Design_2_fromGPU(best_idx));

Print_Polar('Gamma_L_Design_2 (Point 3)', Gamma_L_P3_Design_2(best_idx));

Print_Polar('Gamma_In_Design_2', Gamma_in_Design_2);

Gamma_Out_Design_2 = Gamma_out_Design_2(best_idx);
Print_Polar('Gamma_Out_Design_2', Gamma_Out_Design_2);

Mag_Gamma_IMN_Design_2 = Gamma_IMN_Mag_Design_2(best_idx);
Print_Real('Mag_Gamma_IMN_Design_2', Mag_Gamma_IMN_Design_2);

Mag_Gamma_IMN_Design_2_dB = 20 .* log10(Mag_Gamma_IMN_Design_2);
Print_Real_Unit('Mag_Gamma_Design_2_IMN_dB', Mag_Gamma_IMN_Design_2_dB, 'dB');

VSWR_IMN_Design_2 = VSWR_IMN_Design_2_all(best_idx);
Print_Real('VSWR_IMN_Design_2', VSWR_IMN_Design_2);


Gamma_OMN_Mag_Design_2_all = abs((Gamma_out_Design_2 - conj(Gamma_L_Pn_Design_2_all)) ./ ...
                                 (1 - Gamma_out_Design_2 .* Gamma_L_Pn_Design_2_all));
Mag_Gamma_OMN_Design_2 = Gamma_OMN_Mag_Design_2_all(best_idx);
Print_Real('MGamma_OMN_Design_2', Mag_Gamma_OMN_Design_2);

Mag_Gamma_OMN_Design_2_dB = 20 .* log10(Gamma_OMN_Mag_Design_2_all(best_idx));
Print_Real('MGamma_Design_2_OMN_dB', Mag_Gamma_OMN_Design_2_dB, 'dB');

VSWR_OMN_Design_2 =  VSWR_OMN_Design_2_all(best_idx);
Print_Real('VSWR_OMN_Design_2', VSWR_OMN_Design_2);

GT_dB_Design_2 = GT_dB_Design_2_Selected(best_idx);
Print_Real_Unit('GT_dB_Design_2', GT_dB_Design_2, 'dB');

F_dB_Design_2 = F_Design_2_dB(best_idx);
Print_Real('F_dB_Design_2', F_dB_Design_2, 'dB');



