function pv = pv_module_params()

    % --- Datasheet values (STC: 1000 W/m^2, 25 degC) ---
    pv.Voc_stc   = 37.6;      % Open-circuit voltage [V]
    pv.Isc_stc   = 8.55;      % Short-circuit current [A]
    pv.Vmp_stc   = 31;      % Voltage at max power point [V]
    pv.Imp_stc   = 8.06;      % Current at max power point [A]
    pv.Pmax_stc  = pv.Vmp_stc * pv.Imp_stc;  % Max power [W]

    % --- Single-diode model parameters ---
    pv.n         = 0.99766;       % Diode ideality factor
    pv.Ns        = 60;        % Number of cells in series
    pv.Rs        = 0.247;      % Series resistance [ohm]
    pv.Rsh       = 301.8149;       % Shunt resistance [ohm]
    pv.k         = 1.380649e-23; % Boltzmann constant [J/K]
    pv.q         = 1.602176e-19; % Electron charge [C]

    % --- Temperature coefficients ---
    pv.alpha_Isc = 0.06;    % Isc temp coefficient [A/degC]
    pv.beta_Voc  = -0.35;   % Voc temp coefficient [V/degC]

    % --- Test conditions to sweep in pv_iv_pv_curves.m ---
    pv.G_levels  = [0 20 200 200 400 700 900 1000 850 500 200 20 0];  % Irradiance [W/m^2]
    pv.T_levels  = [26 25 24 25 29 35 42 48 50 45 38 32 28];              % Temperature [degC]
    pv.G_stc     = 1000;
    pv.T_stc     = 25;
end