%--------------------------------------------------------------------

function [C, Z_num, Z_den] = ...
    EE456_Shunt_C_Synthesis(Z_num, Z_den, Iprint, Error)

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
C = Z_den(1) / Z_num(1);

%--------------------------------------------------------------------

Z_den = Z_den - C * conv(Z_num, [1, 0]);
if abs(Z_den(1)) <= delta
    Z_den = Z_den(2:end);
end
if abs(Z_den(1)) <= delta
    Z_den = Z_den(2:end);
end
Z_num = Z_num .* ( abs(Z_num) > delta);
Z_den = Z_den .* ( abs(Z_den) > delta);

%--------------------------------------------------------------------

if Iprint == 0, return, end
Print_Text('Shunt C Synthesis')
Print_Real('C', C, 'F')
if Iprint == 0, return, end
Print_Break
EE456_Print_Poly('Y_num', 'Y_den',...
    Z_den_old, Z_num_old)
Print_Break
Print_Text('Shunt C Synthesis')
Print_Real('C', C, 'F')
Print_Break
EE456_Print_Poly('Y_num', 'Z_den',...
    Z_den, Z_num)
Print_Break

%--------------------------------------------------------------------
