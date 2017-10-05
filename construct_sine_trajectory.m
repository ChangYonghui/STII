% ************************************************************************
% CONSTRUCT_SINE_TRAJECTORY
%
% This script computes the acceleration of the load given the maximum
% amplitude of the command position for a certain frequency.
%
% Input parameters:
%   f           Sine wave excitation frequencies (Hz).
%   Ad          Sine wave amplitude vector (mm).
%   tf          Sine wave duration (s).
%   dt          Sampling intervale (s/sample).
%
% Output parameters:
%   t           Time of sine wave trajectory (s).
%   x           Composite sine wave position (mm).
%   v           Composite sine wave velocity (mm/s).
%   a           Composite sine wave acceleration (mm/s^2).
%
% Copyright (C) 2007 Quanser Consulting Inc.
% Quanser Consulting Inc.
% ************************************************************************
%
function [t,x,v,a] = construct_sine_trajectory(fd, Ad, tf, dt)
% add one second to final time (s)
tf = tf + 1;
% total number of samples of trajectory
n = ceil( tf / dt );
% samples in first second
n1 = ceil( 1 / dt );
% sine wave excitation frequencies (rad/s)
wd = 2 * pi * fd;
% init time variable (s)
time = 0;
% pad first second with zeros
for i = 1:n1
    t(i) = time;
    x(i) = 0;
    v(i) = 0;
    a(i) = 0;
    time = time+dt;
end
% create composite sine wave trajectory
for i = n1:n
    t(i) = time;
    x(i) = Ad * sin( wd * t(i) )';
    v(i) = Ad .* wd * cos( wd * t(i) )';
    a(i) = - Ad .* wd .* wd * sin( wd * t(i) )';
    time = time+dt;    
end