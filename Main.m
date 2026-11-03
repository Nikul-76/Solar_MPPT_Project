clear; clc;

pv   = pv_module_params();

for MPPT_ALGO = 1:2
    out = sim("PV_simulation.slx") ;
    results(MPPT_ALGO).P_pv = out.Pow_Plot.signals.values ;
    results(MPPT_ALGO).t = out.tout ;
end
