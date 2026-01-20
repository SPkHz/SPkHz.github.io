%--------------------------------------------------------------------

function [C, Z_num, Z_den] = ...
    EE456_Series_C_Synthesis(Z_num, Z_den, Iprint, Error)

%--------------------------------------------------------------------
% 04/28/2012 By John J. Burke, Ph.D., P.E.
% 03/04/2015 By John J. Burke, Ph.D., P.E.
% 03/06/2015 By John J. Burke, Ph.D., P.E.
% 03/09/2015 By John J. Burke, Ph.D., P.E.
% 07/31/2017 By John J. Burke, Ph.D., P.E.
% 02/15/2019 By John J. Burke, Ph.D., P.E.
% 03/22/2021 By John J. Burke, Ph.D., P.E.
% 03/12/2023 By John J. Burke, Ph.D., P.E.
%--------------------------------------------------------------------

if nargin < 3, Iprint = 0; end
if nargin < 4, Error = 10^-5; end

%--------------------------------------------------------------------

Z_max = max(max(abs(Z_num)), max(abs(Z_den)));
delta = Error*Z_max;
Z_num_old = Z_num;
Z_den_old = Z_den;
N = length(Z_num) - length(Z_den);
C = Z_den(end-1) / Z_num(end);

%--------------------------------------------------------------------

if (N < 0), [Z_num] = ...
        Subtract_1(Z_num, Z_den, C, delta, N); end
if (N >= 0), [Z_num] = ...
        Subtract_2(Z_num, Z_den, C, delta, N); end
if abs(Z_num(end)) <= delta && abs(Z_den(end)) <= delta
    Z_num = Z_num(1:end-1);
    Z_den = Z_den(1:end-1);
end
Z_num = Z_num .* ( abs(Z_num) > delta);
Z_den = Z_den .* ( abs(Z_den) > delta);

%--------------------------------------------------------------------

if Iprint == 0, return, end
Print_Break
EE456_Print_Poly('Z_num', 'Z_den',...
    Z_num_old, Z_den_old)
Print_Break
Print_Text('Series C Synthesis')
Print_Real('C', C, 'F')
Print_Break
EE456_Print_Poly('Z_num', 'Z_den',...
    Z_num, Z_den)
Print_Break

%--------------------------------------------------------------------




%--------------------------------------------------------------------

function [Z_num] = ...
    Subtract_1(Z_num, Z_den, C, delta, N)

%--------------------------------------------------------------------

Z_num = conv(Z_num, [1, 0]) - Z_den/C;
for k = 1:abs(N)
    if abs(Z_num(end)) <= delta
        Z_num = Z_num(1:end-1);
    end
end

%--------------------------------------------------------------------




%--------------------------------------------------------------------

function [Z_num] = ...
    Subtract_2(Z_num, Z_den, C, delta, N)

%--------------------------------------------------------------------

Temp = zeros(size(Z_den)  + [0, N+1]);
Temp(N+2 : end) = Z_den;
Z_den = Temp;
Z_num = conv(Z_num, [1, 0]) - Z_den/C;
if abs(Z_num(end)) <= delta
    Z_num = Z_num(1:end-1);
end

%--------------------------------------------------------------------
