% ***********************************************************************
% D_POWER_SPECTRUM
% Calculates the power spectrum of a signal x, i.e |X(w)|, along with the
% corresponding frequency vector to plot the result.
%
% Input parameters:
%       x       Signal acquired.
%       f_s     Sampling rate of measured signal (Hz).
%       f_min   Minimum frequency to plot power spectrum (Hz).
%       f_max   Maximum frequency to plot power spectrum (Hz).
%
% OUPUT:
%       f_p     Frequency vector used to plot power spectrum.
%       Py_p    Power spectrum vector evaluated at given frequencies in
%               f_p vector.
%
% Copyright (C) 2007 Quanser Consulting Inc.
% Quanser Consulting Inc.
% ***********************************************************************
%
function [f,Py] = d_power_spectrum(x,dt,tf)
    % length of signal (samples)
    L = tf / dt;
    % Next power of 2 from length of y
    n = 2^nextpow2(L);
    % Take FFT of x
    y = fft(x,n)/L;
    % Power spectrum of x
    Py = 2*abs(y(1:n/2));
    % sampling frequency (Hz)
    fs = 1 / dt;
    % frequency division (Hz)
    f = fs/2*linspace(0,1,n/2);
end
   