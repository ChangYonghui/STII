% ************************************************************************
% FFT_EVAL_POS
% 
% Loads the desired position data and measured table data from the MAT file 
% data_x.mat. The power spectrum of the desired and measured positions is
% computed and plotted.
%
% Copyright (C) 2007 Quanser Consulting Inc.
% Quanser Consulting Inc.
% ************************************************************************
%
%% INPUT
% Save collected acceleration in the following file. 
fname = 'data_x.mat';
% min/max frequencies for plotting (Hz)
f_min = .1;
f_max = 10;
% sampling interval (s)
Ts = qc_get_step_size;
%
%% LOAD DATA
% Load acceleration data into Matlab workspace
load(fname);
% desired position (m);
x_des = data_x(2,:);
% resulting measured table position (m)
x_meas = data_x(3,:);
% final time (s)
Te = max(data_x(1,:));
% 
%% FFT
% Sampling frequency (Hz)
f_s = 1 / qc_get_step_size;
% Calculate power spectrum of desired position
[fp,Pxd] = d_power_spectrum(x_des,Ts,Te);
% Calculate power spectrum of measured position
[fp,Pxm] = d_power_spectrum(x_meas,Ts,Te);
%
%% PLOT
figure(3);
set (3,'name','FFT of desired and measured position');
plot(fp,Pxd,'b--',fp,Pxm,'r-');
axis([f_min f_max 0 1.2*max(Pxm)]);
title('Desired vs. Measured Position');
ylabel('Amplitude (m)');
legend('desired','measured');
%