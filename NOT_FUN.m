clc;
clear all;

pv = pv_module_params();
V = linspace(0, pv.Voc_stc * 1.05, 500);

figure('Name', 'PV I-V and P-V Curve Family');

% --- Sweep irradiance at fixed temperature ---
subplot(2,2,1); hold on;
subplot(2,2,2); hold on;
for G = pv.G_levels
    [I, P] = pv_single_diode_curve(V, G, pv.T_stc, pv);
    subplot(2,2,1); plot(V, I, 'DisplayName', sprintf('%d W/m^2', G));
    subplot(2,2,2); plot(V, P, 'DisplayName', sprintf('%d W/m^2', G));
end
subplot(2,2,1);
xlabel('Voltage [V]'); ylabel('Current [A]');
title(sprintf('I-V curves vs irradiance (T = %d degC)', pv.T_stc));
legend('Location', 'southwest'); grid on;
subplot(2,2,2);
xlabel('Voltage [V]'); ylabel('Power [W]');
title(sprintf('P-V curves vs irradiance (T = %d degC)', pv.T_stc));
legend('Location', 'northwest'); grid on;

% --- Sweep temperature at fixed irradiance ---
subplot(2,2,3); hold on;
subplot(2,2,4); hold on;
for T = pv.T_levels
    [I, P] = pv_single_diode_curve(V, pv.G_stc, T, pv);
    subplot(2,2,3); plot(V, I, 'DisplayName', sprintf('%d degC', T));
    subplot(2,2,4); plot(V, P, 'DisplayName', sprintf('%d degC', T));
end
subplot(2,2,3);
xlabel('Voltage [V]'); ylabel('Current [A]');
title(sprintf('I-V curves vs temperature (G = %d W/m^2)', pv.G_stc));
legend('Location', 'southwest'); grid on;
subplot(2,2,4);
xlabel('Voltage [V]'); ylabel('Power [W]');
title(sprintf('P-V curves vs temperature (G = %d W/m^2)', pv.G_stc));
legend('Location', 'northwest'); grid on;


function [I, P] = pv_single_diode_curve(V, G, T, pv)
%PV_SINGLE_DIODE_CURVE Solve the single-diode equation for a voltage sweep.
%   Returns current I and power P at each voltage point for the given
%   irradiance G [W/m^2] and temperature T [degC]. Uses Newton-Raphson
%   since the single-diode equation is implicit in I.

    Tk   = T + 273.15;
    Vt   = pv.n * pv.Ns * pv.k * Tk / pv.q;   % Thermal voltage

    % Scale short-circuit current and reverse saturation current
    Isc_T = pv.Isc_stc * (G / pv.G_stc) * (1 + pv.alpha_Isc * (T - pv.T_stc));
    Voc_T = pv.Voc_stc + pv.beta_Voc * (T - pv.T_stc);
    I0    = Isc_T / (exp(Voc_T / Vt) - 1);

    I = zeros(size(V));
    Ig = Isc_T;
    for k = 1:length(V)
        Ik = Ig; % initial guess
        for iter = 1:50
            f  = Ig - I0 * (exp((V(k) + Ik * pv.Rs) / Vt) - 1) ...
                    - (V(k) + Ik * pv.Rs) / pv.Rsh - Ik;
            df = -I0 * (pv.Rs / Vt) * exp((V(k) + Ik * pv.Rs) / Vt) ...
                    - pv.Rs / pv.Rsh - 1;
            Ik_new = Ik - f / df;
            if abs(Ik_new - Ik) < 1e-8
                Ik = Ik_new; break;
            end
            Ik = Ik_new;
        end
        I(k) = max(Ik, 0);
    end
    P = V .* I;
end