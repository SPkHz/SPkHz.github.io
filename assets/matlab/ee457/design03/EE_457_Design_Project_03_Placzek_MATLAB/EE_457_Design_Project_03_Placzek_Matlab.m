% EE_457_Design_Project_03_Placzek_Matlab.m
% Calculations and Design for EE-457 Design Project 03.
% Implements the transmission-line patch calculations for EE-457.
% IMPORTANT NOTE: This script relies on Dr. Burke's 
% MATLAB_EELab/* MATLAB scripts to be
% present in the MATLAB PATH in order to run.
% (e.g., EE457_Microstrip_Patch_Conductance).

clc; close all; clear all;

projDir = fileparts(mfilename('fullpath'));
rootDir = fileparts(projDir);
% eelabRoot = fullfile(rootDir, 'MATLAB_EELab');
% if exist(eelabRoot, 'dir') && ~contains(path, eelabRoot)
%     addpath(genpath(eelabRoot));
% else
%     warning('MATLAB_EELab path not found: %s', eelabRoot);
% end

%% Input specifications

specs = defaultSpecs();

%% Transmission-line design parameters

Dims = computeDimensions(specs);

%% Edge conductance and feed offset

Edge = computeEdgeQuantities(specs, Dims);
Feed = computeFeedLocation(specs, Dims, Edge);

%% Performance expectations (HPBW & bandwidth estimate)

Pattern = estimatePattern(specs, Dims);
BW = estimateBandwidth(specs, Dims);

%% Aggregate results, print summary, and write tables

Results = assembleResults(specs, Dims, Edge, Feed, Pattern, BW);
displaySummary(Results);
writeTables(Results);

%% ------------------------------------------------------------------------
% DEFAULTSPECS --> Project inputs and physical constants.

function specs = defaultSpecs()
specs.f0 = 3e9;                % Hz
specs.h = 1.5748e-3;           % m (62 mil)
specs.er = 4.4;                % FR-4 εr
specs.tand = 0.02;             % Loss tangent (documentation)
specs.t_patch = 18e-6;         % Copper thickness (m)
specs.rin = 50;                % Target input resistance (ohm)
specs.widthFactor = 1.5;       % W ~=~ 1.5 * Le (assignment requirement)
specs.substrateFactor = 1.5;   % Ls ~=~ Ws ~=~ 1.5 × patch size
specs.c0 = 299792458;
specs.lambda0 = specs.c0/specs.f0;
specs.k0 = 2*pi/specs.lambda0;
specs.eta0 = 376.730313668;
end

%% ------------------------------------------------------------------------
% computeDimensions --> Does exactly what it sounds like it would do.

function dims = computeDimensions(specs)
lambda_g = specs.lambda0/sqrt(specs.er);      % Guided λ using ε_r
Le = 0.5 * lambda_g;
W = specs.widthFactor * Le;                   % Physical patch width

eps_eff = effectivePermittivity(specs, W);
deltaL = fringingExtension(specs, W, eps_eff);
L = Le - 2*deltaL;
Ls = specs.substrateFactor * L;
Ws = specs.substrateFactor * W;

lambda_g_eff = specs.lambda0/sqrt(eps_eff);   % Useful for documentation.

Dims = struct(); %#ok<NASGU>
dims.lambda_g = lambda_g;
dims.lambda_g_eff = lambda_g_eff;
dims.Le = Le;
dims.W = W;
dims.Wprime = W;
dims.eps_eff = eps_eff;
dims.deltaL = deltaL;
dims.L = L;
dims.Ls = Ls;
dims.Ws = Ws;
end

%%-------------------------------------------------------------------------
% Hammerstad Expression

function eps_eff = effectivePermittivity(specs, W) % Hammerstad expression.
ratio = specs.h/max(W, 1e-12);
eps_eff = (specs.er + 1)/2 + (specs.er - 1)/2 * (1 + 12*ratio)^(-0.5);
end

%%-------------------------------------------------------------------------
% FRINGINGEXTENSION -> Hammerstad extension length on one side.
function deltaL = fringingExtension(specs, W, eps_eff)
ratio = W/specs.h;
deltaL = 0.412*specs.h * ((eps_eff + 0.3)*(ratio + 0.264))/((eps_eff - 0.258)*(ratio + 0.8));
end

%% COMPUTEEDGEQUANTITIES -> Calls the EE457 conductance helper script.
function edge = computeEdgeQuantities(specs, dims)
[Gedge, G1, G12, B1, G1a, B1a] = EE457_Microstrip_Patch_Conductance( ...
    dims.Le, dims.W, specs.h, specs.k0, specs.lambda0, specs.eta0);
edge.Gedge = Gedge;
edge.G1 = G1;
edge.G12 = G12;
edge.B1 = B1;
edge.G1_approx = G1a;
edge.B1_approx = B1a;
edge.Redge = 1/Gedge;
end

%% COMPUTEFEEDLOCATION --> Coaxial probe distance from radiating edge.
function feed = computeFeedLocation(specs, dims, edge)
ratio = min(max(specs.rin/edge.Redge, 0), 1);
xf = (dims.Le/pi) * acos(sqrt(ratio));
x0 = 0.5*dims.Le - xf;
feed.xf = xf;
feed.x0 = x0;
feed.Rin = specs.rin;
end

%% ESTIMATEPATTERN --> Coarse HPBW/directivity expectated values.
function pattern = estimatePattern(specs, dims)
lambda_g = dims.lambda_g;
BWE = 50 * (lambda_g/dims.L);
BWH = 50 * (lambda_g/dims.W);
BWE = min(max(BWE, 30), 180);
BWH = min(max(BWH, 30), 180);
Dlin = 41253/(BWE * BWH);
Ddb = 10*log10(Dlin);
pattern.BWE = BWE;
pattern.BWH = BWH;
pattern.Dlin = Dlin;
pattern.DdB = Ddb;
pattern.Glin = Dlin;
pattern.GdB = Ddb;
end

%%|------------------------------------------------------------------------
%  ESTIMATEBANDWIDTH --> -10 dB impedance bandwidth (transmission-line Q).

function bw = estimateBandwidth(specs, dims)
er = specs.er;
h = specs.h;
lambda0 = specs.lambda0;
fracBW = 3.77 * ((er - 1)/(er^2)) * (h/lambda0);
VSWR = 1.92; % -10 dB return-loss circle
fracBW = fracBW * sqrt((VSWR - 1)/VSWR);
bw.abs = fracBW * specs.f0;
bw.frac = fracBW;
bw.percent = fracBW * 100;
end

%%|------------------------------------------------------------------------
%  ASSEMBLERESULTS --> Organizes script output values for console and CSV.

function results = assembleResults(specs, dims, edge, feed, pattern, bw)
mm = 1e-3;
um = 1e-6;
results.f0_GHz = specs.f0/1e9;
results.h_mm = specs.h/mm;
results.er = specs.er;
results.lambda_g_mm = dims.lambda_g/mm;
results.Le_mm = dims.Le/mm;
results.Wprime_mm = dims.Wprime/mm;
results.eps_eff = dims.eps_eff;
results.deltaL_um = dims.deltaL/um;
results.L_mm = dims.L/mm;
results.W_mm = dims.W/mm;
results.Redge_ohm = edge.Redge;
results.xf_mm = feed.xf/mm;
results.x0_mm = feed.x0/mm;
results.Ls_mm = dims.Ls/mm;
results.Ws_mm = dims.Ws/mm;
results.BWE_deg = pattern.BWE;
results.BWH_deg = pattern.BWH;
results.D_lin = pattern.Dlin;
results.D_dB = pattern.DdB;
results.G_lin = pattern.Glin;
results.G_dB = pattern.GdB;
results.BW_MHz = bw.abs/1e6;
results.BW_percent = bw.percent;
end

%%|------------------------------------------------------------------------
%  DISPLAYSUMMARY --> Print concise summary for sanity checks.

function displaySummary(results)
fprintf('--- EE-457 Design Project 03: Table 01 Calculations --\n');
fprintf('\nf0 = %.4f GHz\n\nεr = %.4f\n\nh = %.4f mm\n', results.f0_GHz, results.er, results.h_mm);
fprintf('\nλg = %.4f mm\n\nLe = %.4f mm\n\nW = %.4f mm\n\nL = %.4f mm\n', ...
        results.lambda_g_mm, results.Le_mm, results.W_mm, results.L_mm);
fprintf('\nΔL = %.4f µm\n\nR_edge = %.4f Ω\n\nxf = %.4f mm (from edge)\n', ...
        results.deltaL_um, results.Redge_ohm, results.xf_mm);
fprintf('\nHPBW_E = %.4f°\n\nHPBW_H = %.4f°\n\nD ≈ %.4f (%.4f dB)\n', ...
        results.BWE_deg, results.BWH_deg, results.D_lin, results.D_dB);
fprintf('\nEstimated BW10dB = %.4f MHz (%.4f%%)\n', results.BW_MHz, results.BW_percent);
end

%%|------------------------------------------------------------------------
%  WRITETABLES --> Populate calculated columns for Tables 1 and 4.

function writeTables(results)
rootDir = fileparts(mfilename('fullpath'));
tablesDir = fullfile(rootDir, 'tables');
if ~exist(tablesDir, 'dir')
    mkdir(tablesDir);
end
T1 = table(results.f0_GHz, results.h_mm, results.er, results.lambda_g_mm, ...
    results.Le_mm, results.Wprime_mm, results.eps_eff, results.deltaL_um, ...
    results.L_mm, results.W_mm, results.Redge_ohm, results.xf_mm, ...
    'VariableNames', {'f0_GHz','h_mm','eps_r','lambda_g_mm','Le_mm','Wprime_mm', ...
                      'eps_eff','deltaL_um','L_mm','W_mm','R_edge_ohm','xf_mm'});
writetable(T1, fullfile(tablesDir, 'table_1_calculated.csv'));
T4 = table(results.BW_MHz, results.BW_percent, ...
    'VariableNames', {'BW_10dB_MHz','BW_10dB_percent'});
writetable(T4, fullfile(tablesDir, 'table_4_calculated.csv'));
end
