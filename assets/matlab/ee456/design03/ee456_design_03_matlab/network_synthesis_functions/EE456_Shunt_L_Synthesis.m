%--------------------------------------------------------------------

function [L, Z_num, Z_den] = ...
    EE456_Shunt_L_Synthesis(Z_num, Z_den, Iprint, Error)

%--------------------------------------------------------------------
% 04/28/2012 By John J. Burke, Ph.D., P.E.
% 03/04/2015 By John J. Burke, Ph.D., P.E.
% 03/06/2015 By John J. Burke, Ph.D., P.E.
% 03/09/2015 By John J. Burke, Ph.D., P.E.
% 07/31/2017 By John J. Burke, Ph.D., P.E.
% 08/14/2017 By John J. Burke, Ph.D., P.E.
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
N = length(Z_den) - length(Z_num);
L = Z_num(end-1) / Z_den(end);

%--------------------------------------------------------------------

% if (N < 0), [Z_den] = ...
%         Subtract_1(Z_num, Z_den, L, delta, N); end
% if (N >= 0), [Z_den] = ...
%         Subtract_2(Z_num, Z_den, L, delta, N); end
% if abs(Z_num(end)) <= delta && abs(Z_den(end)) <= delta
%     Z_num = Z_num(1:end-1);
%     Z_den = Z_den(1:end-1);
% end
Z_num = Z_num .* ( abs(Z_num) > delta);
Z_den = Z_den .* ( abs(Z_den) > delta);

%--------------------------------------------------------------------

if Iprint == 0, return, end
Print_Break
EE456_Print_Poly('Y_num', 'Y_den',...
    Z_den_old, Z_num_old)
Print_Break
Print_Text('Shunt L Synthesis')
Print_Real('L', L, 'H')
Print_Break
EE456_Print_Poly('Y_num', 'Y_den',...
    Z_den, Z_num)
Print_Break

%--------------------------------------------------------------------




%--------------------------------------------------------------------

function [Z_den] = ...
    Subtract_1(Z_num, Z_den, L, delta, N)

%--------------------------------------------------------------------

Z_den = conv(Z_den, [1, 0]) - Z_num/L;
for k = 1:abs(N)
    if abs(Z_den(end)) <= delta
        Z_den = Z_den(1:end-1);
    end
end

%--------------------------------------------------------------------




%--------------------------------------------------------------------

function [Z_den] = ...
    Subtract_2(Z_num, Z_den, L, delta, N)

%--------------------------------------------------------------------

Temp = zeros(size(Z_num)  + [0, N+1]);
Temp(N+2 : end) = Z_num;
Z_num = Temp;
Z_den = conv(Z_den, [1 0]) - Z_num/L;
if abs(Z_den(end)) <= delta
    Z_den = Z_den(1:end-1);
end

%--------------------------------------------------------------------
