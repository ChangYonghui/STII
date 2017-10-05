% ************************************************************************
% MAKE_SINE
%
% Generates custom sine wave at different amplitudes, frequencies, and for 
% a specified duration.
%
% ATTENTION: Make sure the Simulink model "q_earthquake.mdl" is open before
% running this script. The sampling interval parameter "qc_get_step_size"
% is set when the model is open.
%
% Copyright (C) 2008 Quanser Consulting Inc.
% Quanser Consulting Inc.
% ************************************************************************
%
% ************************************************************************
% INPUT
% ************************************************************************
% sine wave amplitude for each excitation (mm)
Ad  = [3.5, 2, 0.5];
% sine wave excitation frequencies (Hz)
fd = [2, 4, 7];
% duration (s)
t_dur = 3;
% sampling period (s/sample)
Ts = qc_get_step_size;
%
% ************************************************************************
% MAKE SINE WAVE
% ************************************************************************
% construct sine wave trajectory
[Tc, xd_mm, vd_mm, ad_mm] = construct_sine_trajectory(fd, Ad, t_dur, Ts);
% Duration (s)
Te = max(Tc);
% Desired position (cm)
Xc = xd_mm/10;
% Desired velocity (cm/s)
Vc = vd_mm/10;
% Desired acceleration (g)
Ac = ad_mm / 1000 / 9.81;
% Clear unused variables
clear [xd_mm, vd_mm, ad_mm, t_dur];
%
% ************************************************************************
% DISPLAY PLOT
% ************************************************************************
% plot generated sine wave trajectories
figure(2);
% position
subplot(3,1,1);
plot(Tc,Xc,'b-');
grid;
title('Generated Sine Wave')
xlabel('time (s)');
ylabel('position (cm)');
% velocity
subplot(3,1,2);
plot(Tc,Vc,'b-');
grid;
xlabel('time (s)');
ylabel('velocity (cm/s)');
% accleration
subplot(3,1,3);
plot(Tc,Ac,'b-');
grid;
xlabel('time (s)');
ylabel('acceleration (g)');

%% Convert desired scaled position (m)
xd = Xc / 100;