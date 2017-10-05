%
%% DISPLAY_RESULTS
% Show postion, velocity, force, and acceleration limits and generate
% setpoint plot
%
%% ************************************************************************
% ENCODER, LOAD, and LIMITS of STII
% ************************************************************************
%
function [f, x_t, x_v, x_a, x_min, g_max_f] = d_STII_display_results(P_MAX,VEL_MAX,F_MAX,G_MAX,K_ENC,Mp,Ml,Mt,Ml_max)
% Calculate useful conversion factors
[ K_R2D, K_D2R, K_IN2M, K_M2IN, K_RDPS2RPM, K_RPM2RDPS, K_OZ2N, K_N2OZ, K_LBS2N, K_N2LBS, K_G2MS, K_MS2G ] = calc_conversion_constants ();
%
% Limit the maximum acceleration of stage (m/s^2)
if (G_MAX > 2.5 )
    G_MAX = 2.5;
end
% Conver acceleration limit (m/s^2)
ACC_MAX = G_MAX * K_G2MS;
% Convert velocity limit (mm/s)
VEL_MAX_MM = VEL_MAX * 1000;
% Convert position limit (mm/s)
P_MAX_MM = P_MAX * 1000;
% Calculate maximum amplitude of position command that the Shake Table II
% can track at various frequencies.
[f,x_t,x_v,x_a,x_min] = d_setpoint_limit(P_MAX_MM, VEL_MAX_MM, ACC_MAX);
% Calculate the maximum possible acceleration of the load given the limits.
[g_max_f] = d_load_acceleration(f,x_min);
%
disp(' ')
disp('ENCODER CALIBRATION')
disp( [ '   K_ENC = ' num2str( K_ENC,4 ) ' m/counts' ] )
disp(' ')
disp('LOAD')
disp( [ '   Mass of top stage and bearing parts = ' num2str( Mp,3 ) ' kg' ] )
disp( [ '   Load added = ' num2str( Ml,3 ) ' kg' ] )
disp( [ '   Total load = ' num2str( Mt,3 ) ' kg' ] )
disp( [ '   NOTE: Shake Table II specified for moving ' num2str( Ml_max,3 ) ' kg at 2.5 g' ] )
disp(' ')
disp('LIMITS')
disp( [ '   Position limit of table = +/- ' num2str( P_MAX_MM,4 ) ' mm' ] )
disp( [ '   Max velocity deliverable by motor = ' num2str( VEL_MAX_MM,4 ) ' mm/s' ] )
disp( [ '   Max force deliverable by motor = ' num2str( F_MAX,6 ) ' N' ] )
disp( [ '   Max load acceleration = ' num2str( G_MAX,4 ) ' g' ] )    
%
%% PLOT
disp(' ')
% Prompt user if performance limitations plot should be generated.
plot_perform_str = input('Do you want to view the setpoint limitations plot? (y/[n]) ','s');
%
if ( (plot_perform_str ~= 'n') & (plot_perform_str ~= 'N') )    
    figure(1)
    % Plot 1: Setpoint limitations.
    subplot(2,1,1)
    % semilogy(f',x_t,'b-.',f',x_v,'r',f',x_a,'g',f',x_min,'k.');
    plot(f',x_t,'b-.',f',x_v,'r',f',x_a,'g',f',x_min,'k.');
    axis([0 10 0 1.25*P_MAX_MM]);
    ylabel('Amplitude (mm)');
    %xlabel('Frequency (Hz)');
    title('ALL COMMANDS SHOULD BE UNDER THE BLACK LINE' );
    legend('Mechanical Limit','Velocity Limit','Acceleration Limit','Combined Limit');
    % Plot 2: Acceleration at combined setpoint limitation.
    subplot(2,1,2)
    plot(f',g_max_f,'b-');
    axis([0 10 0 1.2*G_MAX]);
    grid;
    xlabel('Frequency (Hz)')
    ylabel('Accelerations (g)')
    title('Load Acceleration when Moving Stage at the "Combined Limit" Amplitude');
end
end
