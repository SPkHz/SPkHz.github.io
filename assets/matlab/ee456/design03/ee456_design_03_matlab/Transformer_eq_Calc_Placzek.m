function [PA, PB, PC, nt] = Transformer_eq_Calc_Placzek(Ps, Pp, RTp, Z0, Type)
% Transformer_Equivalent_calculator
% Computes equivalent network components when applying a transformer match.
%
% Inputs:
%   Ps   - Series element (e.g., capacitor or inductor before transformer)
%   Pp   - Shunt element (e.g., capacitor or inductor after transformer)
%   RTp  - Reflected impedance from transformer
%   Z0   - Reference impedance (typically 50 Ohm)
%   Type - 1 for capacitor-type network, 0 for inductor-type network
%
% Outputs:
%   PA, PB, PC - Equivalent parts for matching network
%   nt         - Transformer turns ratio (sqrt(Z0 / RTp))
% parpool("Threads");
% Calculate transformer turns ratio
nt = sqrt(Z0 / RTp);

if Type == 0  % Inductor-type equivalent
    if RTp <= Z0
        PA = nt * (nt - 1) * Pp;
        PB = nt * Pp;
        PC = (1 - nt) * Pp + Ps;
    else
        PA = (nt^2 - nt) * Pp + Ps * nt^2;
        PB = nt * Pp;
        PC = (1 - nt) * Pp;
    end
else  % Capacitor-type equivalent
    if RTp <= Z0
        PA = ((1 - nt) * Ps + Pp) / (nt^2);
        PB = (1 / nt) * Ps;
        PC = ((nt - 1) / nt) * Ps;
    else
        PA = ((1 - nt) / (nt^2)) * Ps;
        PB = (1 / nt) * Ps;
        PC = ((nt - 1) * Ps + nt * Pp) / nt;
    end
end

end
