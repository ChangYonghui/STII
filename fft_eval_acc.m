% ************************************************************************
% FFT_EVAL_ACC
% 
% Loads the desired position data and measured table data from the MAT file 
% data_a.mat. The power spectrum of the desired and measured positions is
% computed and plotted.
%
% Copyright (C) 2007 Quanser Consulting Inc.
% Quanser Consulting Inc.
% ************************************************************************
%
%% INPUT
% Save collected acceleration in the following file. 
fname = 'data_a.mat';
% min/max frequencies for plotting (Hz)
f_min = .1;
f_max = 10;
% sampling interval (s)
Ts = qc_get_step_size;
%
%% LOAD DATA
% Load acceleration data into Matlab workspace
load(fname);
% desired accelerometer (g)
a_des = data_a(2,:);
% accelerometer measurement (g)
a_meas = data_a(3,:);
% final time (s)
Te = max(data_a(1,:));
%
%% FFT
% Sampling frequency (Hz)
f_s = 1 / qc_get_step_size;
% Calculate power spectrum of desired accelerometer
[fp,Pad] = d_power_spectrum(a_des,Ts,Te);
% Calculate power spectrum of measured accelerometer
[fp,Pam] = d_power_spectrum(a_meas,Ts,Te);
%
%% DISPLAY PLOT
figure(4);
set (4,'name','FFT of desired and measured acceleration');
plot(fp,Pad,'b--',fp,Pam,'r-');
% semilogy(fp,Pad,'b--',fp,Pam,'r-');
axis([f_min f_max 0 1.2*max(Pam)]);
title('FFT of desired and measured X acceleration');
xlabel('Frequency (Hz)');
ylabel('Amplitude (g)');
legend('desired','measured');
% 