% EE_457_Design_Project_03_Placzek_Matlab_read_csv_10dB.m
% Matlab script for creating |S11|dB versus frequency plots
% Uses all *.csv files in the current project directory.
%
% Assumptions (HFSS-style export):
%  - Each CSV file has at least three columns:
%      Col 1: sweep variable (ignored here)
%      Col 2: frequency (GHz by default; see PlotSpec.freqInHz)
%      Col 3: |S11| in dB
%  - Files are named so that alphabetical sort produces V1, V2, V3, V4, ...
% Behavior:
%  - All traces are plotted on a single figure.
%  - All traces get -10 dB markers at crossings.
%  - A -10 dB bandwidth is computed and printed for each trace (BW_f),
%     or reported as N/A if there are fewer than two -10 dB crossings.

clc; close all; clear all;

projDir = fileparts(mfilename('fullpath')); %#ok<NASGU>

%% ------------------------------------------------------------------------
%  Plot configuration and file discovery
PlotSpec = default_Plot_Spec();
files = list_Csv_Files(pwd);                % Use current working directory

%% ------------------------------------------------------------------------
%  Generate S11 plot

Fig = plot_All_S11(files, PlotSpec); %#ok<NASGU>

%% ------------------------------------------------------------------------
%  DEFAULT_PLOT_SPEC --> Styles and options for S11 plotting.

function PlotSpec = default_Plot_Spec()
PlotSpec = struct();
PlotSpec.colorList = [
    0.0  0.8  0.0;   % V1  - green
    0.0  0.0  1.0;   % V2  - blue
    1.0  0.0  1.0;   % V3  - magenta
    1.0  0.0  0.0;   % V4  - red
];
PlotSpec.lineWidths = [4 5 4 4];
PlotSpec.markerLevel_dB = -10;        % Level for bandwidth markers (dB)
PlotSpec.markerIndices  = [];         % [] => mark all traces
PlotSpec.lineWidth      = 3;          % fallback if lineWidths not used
PlotSpec.markerSize     = 10;
PlotSpec.fontSizeAxes   = 14;
PlotSpec.fontSizeLabel  = 18;
PlotSpec.fontSizeLegend = 12;
PlotSpec.fontName       = 'Times New Roman';
PlotSpec.gridLineStyle  = ':';
PlotSpec.gridLineWidth  = 1;
PlotSpec.titleString = '$|S_{11}|$ (dB) vs Frequency';
PlotSpec.legendStrings = { ...
    '$|S_{11}|$dB V1', ...
    '$|S_{11}|$dB V2', ...
    '$|S_{11}|$dB V3', ...
    '$|S_{11}|$dB V4'};
PlotSpec.freqInHz = false;            % Set true if CSV frequency is in Hz
end

%% ------------------------------------------------------------------------
%  LIST_CSV_FILES --> Find and alphabetize all *.csv files in a directory.

function files = list_Csv_Files(dirPath)
files = dir(fullfile(dirPath, '*.csv'));
if isempty(files)
    error('No .csv files found in directory: %s', dirPath);
end
[~, idx] = sort({files.name});
files = files(idx);
end

%% ------------------------------------------------------------------------
%  PLOT_ALL_S11 --> Read CSVs, plot all |S11| curves, and decorate axes.

function Fig = plot_All_S11(files, PlotSpec)
Fig = figure; hold on; grid on; box on;
set(Fig, 'Color', 'w');
nFiles   = numel(files);
nColors  = size(PlotSpec.colorList, 1);
fprintf('--- %.1f dB bandwidths from |S_{11}| ---\n', ...
        abs(PlotSpec.markerLevel_dB));
for k = 1:nFiles
    filePath = fullfile(files(k).folder, files(k).name);
    [f, s11] = read_S11_Trace(filePath, PlotSpec.freqInHz);
    if isempty(f) || numel(s11) < 2
        warning('Skipping file with insufficient data: %s', files(k).name);
        continue;
    end
    c = PlotSpec.colorList(min(k, nColors), :);
    name = strip_Extension(files(k).name);
    if isfield(PlotSpec, 'lineWidths') && ~isempty(PlotSpec.lineWidths)
        lwList = PlotSpec.lineWidths;
        lw = lwList(min(k, numel(lwList)));
    else
        lw = PlotSpec.lineWidth;
    end
    plot(f, s11, ...                                   % Main curve
        'LineWidth', lw, ...
        'Color', c, ...
        'DisplayName', name);
    markThisCurve = isempty(PlotSpec.markerIndices) || ...
                    ismember(k, PlotSpec.markerIndices);
    % -10 dB crossings and bandwidth
    bw = computeBandwidthFromLevel(f, s11, PlotSpec.markerLevel_dB);
    if markThisCurve && ~isempty(bw.crossings)
        plot(bw.crossings, ...
             PlotSpec.markerLevel_dB * ones(size(bw.crossings)), 'o', ...
             'MarkerFaceColor', c, ...
             'MarkerEdgeColor', 'k', ...
             'MarkerSize', PlotSpec.markerSize, ...
             'LineWidth', 1.2, ...
             'HandleVisibility', 'off');
    end
    if ~isnan(bw.BWabs)
        fprintf('%s: f0 ≈ %.4f GHz, ', name, bw.f0);
        fprintf('f_low = %.4f GHz, f_high = %.4f GHz, ', ...
                bw.fLow, bw.fHigh);
        fprintf('BW_f = %.4f GHz (%.4f%%)\n', ...
                bw.BWabs, bw.BWpercent);
    else
        fprintf('%s: BW_f = N/A (no %.1f dB crossings).\n', ...
                name, PlotSpec.markerLevel_dB);
    end
end
formatS11Axes(PlotSpec);
end

%% ------------------------------------------------------------------------
%  READ_S11_TRACE --> Load frequency and |S11| from a CSV file.

function [f, s11] = read_S11_Trace(filePath, freqInHz)
T = readtable(filePath, 'PreserveVariableNames', true);
vars = T.Properties.VariableNames;
freqIdx = find(contains(vars, 'Freq', 'IgnoreCase', true), 1, 'first');
s11Idx  = find(contains(vars, 'dB',   'IgnoreCase', true) | ...
               contains(vars, 'S11',  'IgnoreCase', true), 1, 'first');
if isempty(freqIdx) || isempty(s11Idx)
    warning('Could not find frequency/S11 columns in %s. Skipping.', filePath);
    f   = [];
    s11 = [];
    return;
end
f   = T{:, freqIdx};                      % Extract numeric data
s11 = T{:, s11Idx};
bad = ~isfinite(f) | ~isfinite(s11);      % Drop any NaNs
f(bad)   = [];
s11(bad) = [];
if numel(f) < 2 || numel(s11) < 2         % Still not enough samples? bail.
    f   = [];
    s11 = [];
    return;
end
if freqInHz                               % Optional Hz → GHz conversion
    f = f/1e9;
end
end

%% ------------------------------------------------------------------------
%  LEVELCROSSINGS --> Linear interpolation for y = level crossings.

function crossings = levelCrossings(f, y, level)
delta    = y - level;
idxCross = find(delta(1:end-1) .* delta(2:end) <= 0);
crossings = zeros(size(idxCross));
for n = 1:numel(idxCross)
    i  = idxCross(n);
    f1 = f(i);    f2 = f(i+1);
    y1 = y(i);    y2 = y(i+1);

    if y2 ~= y1
        crossings(n) = f1 + (level - y1) * (f2 - f1) / (y2 - y1);
    else
        crossings(n) = f1;
    end
end
end

%% ------------------------------------------------------------------------
%  COMPUTEBANDWIDTHFROMLEVEL --> -XdB bandwidth around the resonance.

function bw = computeBandwidthFromLevel(f, s11, level_dB)
bw = struct();                                % Initialize struct with NaNs
bw.f0        = NaN;
bw.fLow      = NaN;
bw.fHigh     = NaN;
bw.BWabs     = NaN;
bw.BWfrac    = NaN;
bw.BWpercent = NaN;
bw.crossings = [];
if numel(f) < 2 || numel(s11) < 2
    return;
end
crossings = levelCrossings(f, s11, level_dB);
if numel(crossings) < 2
    return;
end
[~, idxMin] = min(s11);                       % (min |S11|)
f0    = f(idxMin);
fLow  = crossings(1);
fHigh = crossings(end);
BWabs     = fHigh - fLow;
BWfrac    = BWabs / f0;
BWpercent = 100 * BWfrac;
bw.f0        = f0;
bw.fLow      = fLow;
bw.fHigh     = fHigh;
bw.BWabs     = BWabs;
bw.BWfrac    = BWfrac;
bw.BWpercent = BWpercent;
bw.crossings = crossings;
end

%% ------------------------------------------------------------------------
%  FORMAT_S11_AXES --> Publication-style axis, labels, and legend.

function formatS11Axes(PlotSpec)
set(gca, ...
    'FontSize', PlotSpec.fontSizeAxes, ...
    'FontName', PlotSpec.fontName, ...
    'GridLineStyle', PlotSpec.gridLineStyle, ...
    'LineWidth', PlotSpec.gridLineWidth);

xlabel('$f$ (GHz)', 'Interpreter', 'latex', ...
    'FontSize', PlotSpec.fontSizeLabel);
ylabel('$|S_{11}|$ (dB)', 'Interpreter', 'latex', ...
    'FontSize', PlotSpec.fontSizeLabel);

title(PlotSpec.titleString, 'Interpreter', 'latex', ...
    'FontSize', PlotSpec.fontSizeLabel);

if isfield(PlotSpec, 'legendStrings') && ~isempty(PlotSpec.legendStrings)
    legend(PlotSpec.legendStrings, ...
        'Interpreter', 'latex', ...
        'Location', 'southwest', ...
        'FontSize', PlotSpec.fontSizeLegend);
else
    legend('show', 'Location', 'southwest', ...
        'FontSize', PlotSpec.fontSizeLegend);
end
end

%% ------------------------------------------------------------------------
%  STRIP_EXTENSION --> Remove file extension from a filename.

function name = strip_Extension(filename)
[~, name, ~] = fileparts(filename);
end
