% github test CH2017.10.05
%% SETUP
%
% This script calculates the control gains, filter parameters, and other
% variables to use the Quanser Shake Table II Simulink models. It also
% calculates the performance limitations of the STII system such as maximum
% acceleration based on the mass of the load and the motor specifications.
%
% See the "Shake Table II User Manual" for further details.
%
% Copyright (C) 2017 Quanser Consulting Inc.
% Quanser Consulting Inc.
% ************************************************************************
%
% Clear the workspace.
clear all;
%
%% USER INPUT
% Enter revision of Shake Table II: REV1, REV2, REV3, or REV4.
STII_REV = 'REV4'; % 'REV1', 'REV2', 'REV3', or 'REV4'
% Enter type of amplifier being used.
AMP_TYPE = 'AMPAQ-PWM';
%
%% CONTROL PARAMETERS
% Spec #1: maximum percent overshoot
PO = 2.0;
% Spec #2: time of first peak
tp = 0.025;
% 
%% DEBOUNCE
% Time frame to switch from off to on
dbnc_rise_time = 0.25;
% Input signal threshold
dbnc_threshold = 0.8;
%
%% SWEEP SIGNAL
% Maximum amplitude of sine sweep (m)
SWEEP_MAX = 4e-3;
% Target time (s)
tf_sweep = 20;
%
%% LOAD MASS
% Calculate useful conversion factors
[ K_R2D, K_D2R, K_IN2M, K_M2IN, K_RDPS2RPM, K_RPM2RDPS, K_OZ2N, K_N2OZ, K_LBS2N, K_N2LBS, K_G2MS, K_MS2G ] = calc_conversion_constants ();
% Set amplifier (e.g. AMPAQ-PWM) parameters.
[ Rm, Kt, Km, Pb, Mp, Ml_max, K_AMP, Ms, VMAX_AMP, IMAX_AMP, P_MAX ] = config_STII( STII_REV, AMP_TYPE );
% Load sensor gains
[K_CURR, K_ENC, K_S0, K_S1, K_S2, K_S3] = d_STII_sensors(Pb);
%
disp(' ');
load_used_str = input('Enter any additional load on the top stage of the table (kg): ','s');
% If no mass entered then load_used = 0 kg
if ~isempty(load_used_str)    
    Ml = str2double(load_used_str);
else
    Ml = 0;
    disp(' ');
    disp('NOTE: Load set to 0 kg. ');
end
%
% Total Load Mass = pre-load mass + added load mass (kg)
Mt = Mp + Ml;
%
%% CALC PERFORMANCE LIMITATIONS
% Compute load-dependent stage acceleration and velocity limits (m/s^2)
[ VEL_MAX, F_MAX, ACC_MAX, G_MAX ] = d_STII_limits( Km, Kt, Mt, Pb, IMAX_AMP, VMAX_AMP );
%
%% DISPLAY
[f, x_t, x_v, x_a, x_min, g_max_f] = d_STII_display_results(P_MAX,VEL_MAX,F_MAX,G_MAX,K_ENC,Mp,Ml,Mt,Ml_max);
%
%% CALC CONTROL and FILTER PARAMETERS
% IMPORTANT: Always test the controller with control gains calculated from
% having no load.
% Added load mass for control calc (kg)
Ml = 0;
% Total Load Mass = pre-load mass + added load mass (kg)
Mt = Mp + Ml;
% Calculate the PD control gains
% [Kf, K] = d_STII_pd(Kt,Mt,Pb,f0,zeta);
[Kf, kp, kd] = d_STII_pd(Kt, Km, Mt, Pb, Rm, tp, PO);
% Set low-pass filter parameters
[wa,za,wd,zd] = d_STII_filters( );
% 