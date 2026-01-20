function [IMN_parts, OMN_parts] = dp3_run_matches_nets_gpu_Placzek()
    % Constants
    G = 1e9; M = 1e6; K = 1e3;
    m = 1e-3; u = 1e-6; n = 1e-9;
    p = 1e-12; f = 1e-15;
    
    % Transistor parameters
    Ri = 23.0767;
    Ci = 245.2104 * f;
    Li = 347.8189 * p;
    Ro = 44.0222;
    Co = 283.0342 * f;
    Lo = 202.0340 * p;
    Z0 = 50;
    
    % Frequency specifications
    fL = 9*G;
    fH = 20*G;
    f0 = sqrt(fL*fH);
    
    % Run input matching network (IMN)
    [S_IMN, nt_I, IMN_parts] = dp3_IMN_direct();
    
    % Run output matching network (OMN)
    [S_OMN, nt_O, OMN_parts, ~, ~] = dp3_OMN_direct();
    
    % Display results for comparison with target values
    fprintf('\n\n========== IMN Components ==========\n');
    fprintf('Ci1 = %.4f fF\n', IMN_parts(1) * 1e15);
    fprintf('Li2 = %.4f pH\n', IMN_parts(2) * 1e12);
    fprintf('Li3 = %.4f pH\n', IMN_parts(3) * 1e12);
    fprintf('Ci4 = %.4f fF\n', IMN_parts(4) * 1e15);
    fprintf('Ci5 = %.4f fF\n', IMN_parts(5) * 1e15);
    fprintf('Ci6 = %.4f fF\n', IMN_parts(6) * 1e15);
    fprintf('Li7 = %.4f pH\n', IMN_parts(7) * 1e12);
    
    fprintf('\n\n========== OMN Components ==========\n');
    fprintf('Co1 = %.4f fF\n', OMN_parts(1) * 1e15);
    fprintf('Lo2 = %.4f pH\n', OMN_parts(2) * 1e12);
    fprintf('Co3 = %.4f fF\n', OMN_parts(3) * 1e15);
    fprintf('Lo4 = %.4f pH\n', OMN_parts(4) * 1e12);
    fprintf('Lo5 = %.4f pH\n', OMN_parts(5) * 1e12);
    fprintf('Lo6 = %.4f pH\n', OMN_parts(6) * 1e12);
    fprintf('Co7 = %.4f fF\n', OMN_parts(7) * 1e15);
    
end

function [S_IMN, nt, components] = dp3_IMN_direct()
    % This function implements the direct synthesis approach for IMN

    %% Constants
    G = 1e9; M = 1e6; p = 1e-12; f = 1e-15;
    
    % Transistor model
    Ri = 23.0767;
    Ci = 245.2104 * f;
    Li = 347.8189 * p;
    Z0 = 50;
    
    % Frequency specs
    fL = 9*G;
    fH = 20*G;
    f0 = sqrt(fL*fH);
    
    % Network design parameters
    NE = 7;
    NS_I = 1;
    IL_min_dB_I = 0.0;
    Ripple_I = 0.1;
    
    % Calculate IL coefficients
    N_Poly = (1/2)*(NE-1);
    IL_max_I = 10^((IL_min_dB_I + Ripple_I)/10);
    IL_min_I = 10^(IL_min_dB_I/10);
    k0_I = IL_min_I;
    kT_I = IL_max_I - k0_I;
    
    % Generate IL function
    [IL_num, IL_den, R2_num, R2_den] = EE456_IL_Function_f0(fL, fH, k0_I, kT_I, N_Poly, NS_I);
    
    % Find poles and zeros
    sz2 = roots(R2_num);
    sz = sz2(real(sz2) < 0);
    sp2 = roots(R2_den);
    sp = sp2(real(sp2) < 0);
    
    % Generate impedance function
    R_Sign = 1;
    [Z_num, Z_den, ~, ~] = EE456_Z_Function(sz, sp, R_Sign);
    
    % Now perform the synthesis, element by element
    [C1_I, Z_num, Z_den] = EE456_Series_C_Synthesis(Z_num, Z_den, 0);
    [L2_I, Z_num, Z_den] = EE456_Series_L_Synthesis(Z_num, Z_den, 0);
    [L3_I, Z_num, Z_den] = EE456_Shunt_L_Synthesis(Z_num, Z_den, 0);
    [C4_I, Z_num, Z_den] = EE456_Shunt_C_Synthesis(Z_num, Z_den, 0);
    [C5_I, Z_num, Z_den] = EE456_Series_C_Synthesis(Z_num, Z_den, 0);
    [L6_I, Z_num, Z_den] = EE456_Shunt_L_Synthesis(Z_num, Z_den, 0);
    R7_I = Z_num / Z_den;
    
    % Denormalize
    C1_I = C1_I/(2*pi*f0*Ri);
    L2_I = (L2_I/(2*pi*f0))*Ri;
    L3_I = (L3_I/(2*pi*f0))*Ri;
    C4_I = C4_I/(2*pi*f0*Ri);
    C5_I = C5_I/(2*pi*f0*Ri);
    L6_I = (L6_I/(2*pi*f0))*Ri;
    RTp_I = R7_I*Ri;
    
    % Calculate transformer ratio
    nt = sqrt(Z0/RTp_I);
    NT = nt^2;
    
    % Apply transformer
    CP = C4_I;
    CS = C5_I;
    CC = (1/nt)*((nt-1)*CS+(nt*CP));
    CB = (1/nt)*CS;
    CA = (1/nt^2)*((1-nt)*CS);
    LZ = (nt^2)*L6_I;
    
    % Final component values
    C6_I = CA;
    C5_I = CB;
    C4_I = CC;
    L7_I = LZ;
    
    % Adjust for transistor integration
    Ci1 = ((1/C1_I) - (1/Ci))^-1;
    Li2 = L2_I - Li;
    Li3 = L3_I;
    Ci4 = C4_I;
    Ci5 = C5_I;
    Ci6 = C6_I;
    Li7 = L7_I;
    
    % Return the S-parameters (placeholder)
    S_IMN = zeros(1, 2, 2);  % Would be calculated with ABCD matrices
    
    % Return the component values
    components = [Ci1, Li2, Li3, Ci4, Ci5, Ci6, Li7];
end

function [S_OMN, nt, components, fx, Tholder] = dp3_OMN_direct()
    % This function implements the direct synthesis approach for OMN
    % similar to the process in DP3_Ryan_Total.m

    %% Constants
    G = 1e9; M = 1e6; p = 1e-12; f = 1e-15;
    
    % Transistor model
    Ro = 44.0222;
    Co = 283.0342 * f;
    Lo = 202.0340 * p;
    Z0 = 50;
    
    % Frequency specs
    fL = 9*G;
    fH = 20*G;
    f0 = sqrt(fL*fH);
    fx = [fL, f0, fH];
    
    % Network design parameters
    NE = 7;
    NS = 0;
    IL_min_dB = 0.1;
    Ripple = 0.1;
    
    % Calculate IL coefficients
    N_Poly = (1/2)*(NE-1);
    IL_max = 10^((IL_min_dB + Ripple)/10);
    IL_min = 10^(IL_min_dB/10);
    k0 = IL_min;
    kT = IL_max - k0;
    
    % Generate IL function
    [IL_num, IL_den, R2_num, R2_den] = EE456_IL_Function_f0(fL, fH, k0, kT, N_Poly, NS);
    
    % Find poles and zeros
    sz2 = roots(R2_num);
    sz = sz2(real(sz2) < 0);
    sp2 = roots(R2_den);
    sp = sp2(real(sp2) < 0);
    
    % Generate impedance function
    R_Sign = 1;
    [Z_num, Z_den, ~, ~] = EE456_Z_Function(sz, sp, R_Sign);
    
    % Now perform the synthesis, element by element
    [C1, Z_num, Z_den] = EE456_Series_C_Synthesis(Z_num, Z_den, 0);
    [L2, Z_num, Z_den] = EE456_Series_L_Synthesis(Z_num, Z_den, 0);
    [C3, Z_num, Z_den] = EE456_Shunt_C_Synthesis(Z_num, Z_den, 0);
    [L4, Z_num, Z_den] = EE456_Series_L_Synthesis(Z_num, Z_den, 0);
    [L5, Z_num, Z_den] = EE456_Shunt_L_Synthesis(Z_num, Z_den, 0);
    [C6, Z_num, Z_den] = EE456_Series_C_Synthesis(Z_num, Z_den, 0);
    R7 = Z_num / Z_den;
    
    % Denormalize
    C1 = C1/(2*pi*f0*Ro);
    L2 = (L2/(2*pi*f0))*Ro;
    C3 = C3/(2*pi*f0*Ro);
    L4 = (L4/(2*pi*f0))*Ro;
    L5 = (L5/(2*pi*f0))*Ro;
    C6 = C6/(2*pi*f0*Ro);
    RTp = R7*Ro;
    
    % Calculate transformer ratio
    nt = sqrt(Z0/RTp);
    NT = nt^2;
    
    % Apply transformer
    LP = L5;
    LS = L4;
    LA = nt*(nt-1)*LP;
    LB = nt*LP;
    LC = (1 - nt)*LP + LS;
    CZ = (1/nt^2)*C6;
    
    % Final component values
    L6 = LA;
    L5 = LB;
    L4 = LC;
    C7 = CZ;
    
    % Adjust for transistor integration
    Co1 = ((1/C1) - (1/Co))^-1;
    Lo2 = L2 - Lo;
    Co3 = C3;
    Lo4 = L4;
    Lo5 = L5;
    Lo6 = L6;
    Co7 = C7;
    
    % Return the S-parameters (placeholder)
    S_OMN = zeros(1, 2, 2);  % Would be calculated with ABCD matrices
    Tholder = zeros(1, 2, 2); % ABCD matrix placeholder
    
    % Return the component values
    components = [Co1, Lo2, Co3, Lo4, Lo5, Lo6, Co7];
end
