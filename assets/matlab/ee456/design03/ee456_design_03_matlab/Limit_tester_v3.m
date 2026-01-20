function [Logical_Array, type, Sign] = Limit_tester_v3(Z_num, Z_den)
% Limit_tester_v3 - Numerical impedance behavior detector
% Input:
%   Z_num, Z_den - Numerator and denominator of Z(s)
% Output:
%   Logical_Array = [Series C, Shunt C, Series L, Shunt L] logic codes
%   type         = Dominant component type
%   Sign         = Sign of reflection coefficient at high frequency

% Type Legend:
%  -3 = Series C
%   4 = Shunt C
%  -1 = Series L
%   2 = Shunt L
%   0 = Invalid / Unknown
if ~isnumeric(Z_num) || ~isnumeric(Z_den)
    error('Z_num and Z_den must be numeric.');
end

% Initialize outputs
Logical_Array = [0, 0, 0, 0];
type = 0;
Sign = 0;

% Define evaluation points
s_hi = 1e9;   % high frequency
s_lo = 1e-9;  % low frequency

% Evaluate impedance at high and low s
Z_num = double(Z_num);  % Ensure numeric, not symbolic or GPU array
Z_den = double(Z_den);
Y_hi = 1 / max(eps, abs(Z_hi));
Y_lo = 1 / max(eps, abs(Z_lo));
Z_hi = polyval(Z_num, s_hi) / max(eps, polyval(Z_den, s_hi));
Z_lo = polyval(Z_num, s_lo) / max(eps, polyval(Z_den, s_lo));


% Z_hi = polyval(Z_num, s_hi) / polyval(Z_den, s_hi);
% 
% Z_lo = polyval(Z_num, s_lo) / polyval(Z_den, s_lo);

% Evaluate admittance (Y = 1/Z)
% Y_hi = 1 / Z_hi;
% Y_lo = 1 / Z_lo;

% Thresholds
Z_big  = 1e3;
Z_small = 1e-3;
Y_big  = 1e3;
Y_small = 1e-3;

% Test Series L: Z -> ∞ as s -> ∞ and Z -> 0 as s -> 0
if abs(Z_hi) > Z_big && abs(Z_lo) < Z_small
    Logical_Array(3) = -1;
    type = -1;
end

% Test Shunt L: Y -> ∞ as s -> 0
if abs(Y_lo) > Y_big
    Logical_Array(4) = 2;
    type = 2;
end

% Test Series C: Z -> ∞ as s -> 0
if abs(Z_lo) > Z_big
    Logical_Array(1) = -3;
    type = -3;
end

% Test Shunt C: Y -> ∞ as s -> ∞
if abs(Y_hi) > Y_big
    Logical_Array(2) = 4;
    type = 4;
end

% Estimate sign of Gamma(s) at high frequency
Gamma_hi = (Z_hi - 1) / (Z_hi + 1);
Sign = real(Gamma_hi);

% Optional debug
% fprintf('Limit Analysis Results: [Cseries, Cshunt, Lseries, Lshunt] = [%d %d %d %d]\n', Logical_Array);
% fprintf('Dominant Type: %d | Gamma Sign: %.3f\n', type, Sign);

end


% % % % function [Logical_Array, type, Sign] = Limit_tester_v3(Z_num, Z_den)
% % % % 
% % % % % % % delete(gcp('nocreate'));  % Clean up any existing pool
% % % % % % % parpool("Threads");
% % % % 
% % % % 
% % % % % Limit_tester_gpu
% % % % % Determines element type based on symbolic impedance behavior
% % % % % Input:
% % % % %   Z_num, Z_den - Numerator and denominator of Z(s) transfer function
% % % % % Output:
% % % % %   Logical_Array = [Series C, Shunt C, Series L, Shunt L] logic codes
% % % % %   type         = Most likely topology type (int code)
% % % % %   Sign         = Sign of Gamma at s → infinity (used for R_sign)
% % % % 
% % % % % Type Legend:
% % % % %  -3 = Series C
% % % % %   4 = Shunt C
% % % % %  -1 = Series L
% % % % %   2 = Shunt L
% % % % %   0 = Invalid
% % % % 
% % % % % -------------------------------------------------------------
% % % % % Init
% % % % Logical_Array = [0, 0, 0, 0];
% % % % type = 0;
% % % % Sign = 0;
% % % % 
% % % % % Symbolic setup
% % % % syms s
% % % % Z_sym = poly2sym(Z_num, s) / poly2sym(Z_den, s);
% % % % Y_sym = 1 / Z_sym;
% % % % Gamma_sym = (Z_sym - 1) / (Z_sym + 1);
% % % % 
% % % % % Flags
% % % % found = false;
% % % % 
% % % % % ---------------- Series L Test (Z(s) → infinity as s → infinity)
% % % % Z_check_inf = double(subs(Z_sym, s, 1e9));  % practical s → ∞
% % % % Z_check_0   = double(subs(Z_sym, s, 1e-9)); % practical s → 0
% % % % 
% % % % % Logic to validate impedance shape
% % % % if abs(Z_check_inf) > 1e3 && abs(Z_check_0) < 1e-3
% % % %     pass = true;
% % % % else
% % % %     pass = false;
% % % % end
% % % % % ---------------- Shunt L Test (Y(s) → infinity as s → 0)
% % % % Y_0 = limit(Y_sym, s, 0);
% % % % if isinf(Y_0) || isnan(Y_0)
% % % %     Logical_Array(4) = 2;
% % % %     type = 2;
% % % %     found = true;
% % % % end
% % % % 
% % % % % ---------------- Series C Test (Z(s) → infinity as s → 0)
% % % % Z_0 = limit(Z_sym, s, 0);
% % % % if isinf(Z_0) || isnan(Z_0)
% % % %     Logical_Array(1) = -3;
% % % %     type = -3;
% % % %     found = true;
% % % % end
% % % % 
% % % % % ---------------- Shunt C Test (Y(s) → infinity as s → infinity)
% % % % Y_inf = limit(Y_sym, s, inf);
% % % % if isinf(Y_inf) || isnan(Y_inf)
% % % %     Logical_Array(2) = 4;
% % % %     type = 4;
% % % %     found = true;
% % % % end
% % % % 
% % % % % ---------------- Gamma Sign (Z for passive/active matching)
% % % % Sign = limit(Gamma_sym, s, inf);
% % % % 
% % % % % ---------------- Debug
% % % % fprintf('Limit Analysis Results: [Cseries, Cshunt, Lseries, Lshunt] = [%d %d %d %d]\n', Logical_Array);
% % % % fprintf('Dominant Type: %d | Gamma Sign: %.3f\n', type, double(Sign));
% % % % end
