%
%% d_STII_filters
%
% This function converts the low-pass filter (LPF) cutoff frequencies used
% to filter the accelerometer measurements, the command position, and the
% acceleration from the encoders to radians per second.
%
% Output parameters:
%   wa          Accelerometer measurements LPF cutoff frequency (rad/s).
%   za          Accelerometer measurements LPF damping ratio.
%   wd          Encoder position HPF cutoff frequency (rad/s).
%   zd          Encoder position HPF damping ratio.
%
% Copyright (C) 2007 Quanser Consulting Inc.
% Quanser Consulting Inc.
%
function [wa,za,wd,zd] = d_STII_filters()
% 
% Low-pass filter for accelerometer measurements (Hz)
% Cutoff frequency (rad/s)
wa = 2 * pi * 45.0;
% Damping ratio
za = 0.9;
%
% Low-pass filter used to calculate velocity from the encoder.
% Cutoff frequency (rad/s)
wd = 2 * pi * 150.0;
% Damping ratio
zd = 0.9;