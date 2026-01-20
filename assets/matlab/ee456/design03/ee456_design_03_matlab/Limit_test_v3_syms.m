function [Logical_Array, type, Sign] = Limit_test_v3_syms(Z_num, Z_den)

% % % delete(gcp('nocreate'));  % Clean up any existing pool
% % % parpool("Threads");


% Limit_tester_gpu
% Determines element type based on symbolic impedance behavior
% Input:
%   Z_num, Z_den - Numerator and denominator of Z(s) transfer function
% Output:
%   Logical_Array = [Series C, Shunt C, Series L, Shunt L] logic codes
%   type         = Most likely topology type (int code)
%   Sign         = Sign of Gamma at s → infinity (used for R_sign)

% Type Legend:
%  -3 = Series C
%   4 = Shunt C
%  -1 = Series L
%   2 = Shunt L
%   0 = Invalid

% -------------------------------------------------------------
% Init
Logical_Array = [0, 0, 0, 0];
type = 0;
Sign = 0;

% Symbolic setup
syms s
Z_sym = poly2sym(Z_num, s) / poly2sym(Z_den, s);
Y_sym = 1 / Z_sym;
Gamma_sym = (Z_sym - 1) / (Z_sym + 1);

% Flags
found = false;

% ---------------- Series L Test (Z(s) → infinity as s → infinity)
Z_check_inf = double(subs(Z_sym, s, 1e9));  % practical s → ∞
Z_check_0   = double(subs(Z_sym, s, 1e-9)); % practical s → 0

% Logic to validate impedance shape
if abs(Z_check_inf) > 1e3 && abs(Z_check_0) < 1e-3
    pass = true;
else
    pass = false;
end
% ---------------- Shunt L Test (Y(s) → infinity as s → 0)
Y_0 = limit(Y_sym, s, 0);
if isinf(Y_0) || isnan(Y_0)
    Logical_Array(4) = 2;
    type = 2;
    found = true;
end

% ---------------- Series C Test (Z(s) → infinity as s → 0)
Z_0 = limit(Z_sym, s, 0);
if isinf(Z_0) || isnan(Z_0)
    Logical_Array(1) = -3;
    type = -3;
    found = true;
end

% ---------------- Shunt C Test (Y(s) → infinity as s → infinity)
Y_inf = limit(Y_sym, s, inf);
if isinf(Y_inf) || isnan(Y_inf)
    Logical_Array(2) = 4;
    type = 4;
    found = true;
end

% ---------------- Gamma Sign (Z for passive/active matching)
Sign = limit(Gamma_sym, s, inf);

% ---------------- Debug
fprintf('Limit Analysis Results: [Cseries, Cshunt, Lseries, Lshunt] = [%d %d %d %d]\n', Logical_Array);
fprintf('Dominant Type: %d | Gamma Sign: %.3f\n', type, double(Sign));
end
