clear; clc;

pv   = pv_module_params();

for MPPT_ALGO = 1
    out = sim("PV_simulation.slx");
    % results(MPPT_ALGO).IV = out.IV_Plot;
    results(MPPT_ALGO).P_pv = out.Power_Plot.signals(1).values;
    % results(MPPT_ALGO).D = out.Duty_Ratio_Plot(1).values;
    results(MPPT_ALGO).t = out.tout;
end
