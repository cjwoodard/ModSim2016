%%%%%%%
% SkateboardEnergyPositionValidation()
% 
% This function does a single run of the skateboard simulation
% and then creates a plot of energies versus times as well as keyframes for
% different times during the motion.
%
% The function takes no inputs, and returns no outputs (other than a plot).
% 


function SkateboardEnergyPositionValidation()
    close all
    clear all

    % Define constants
    g = 10 % gravitational acceleration, m/s^2
    m = 75 % Set rider mass to 75 kg
    M = 150 % Set ramp mass to 150 kg
    l = 2 % Set total length of ramp to L = 4 (ramp runs from -1 to l)
    I  =  1/12*(M*(2*l)^2); % moment of inertia of ramp: kg m^2

    % Set initial conditions
    thetainitial = pi/4 % initial ramp angle, radians 
    rdotinitial = 6.2; % initial speed,   in m/sec
    thetadotinitial = 0; % initial angular velocity, radians/sec
    
    % set limits of ramp motion
    thetamin = -thetainitial; 
    thetamax = thetainitial;

    % Run the simulation
    [launch successful failure timeonramp t y] = ...
        ramp_single_run(m,  M,  l,  thetainitial,  rdotinitial);
    
    % Now create the energy-motion validation figure
    
        % Identify five key frames
        tmax = max(t);
        index(1) = find( t == min(t) );
        index(2) = min( find( t > tmax/4 ));
        index(3) = min( find( t > tmax/2 ));
        index(4) = min( find( t > 3*tmax/4 ));
        index(5) = length(t);

        % Create the five key frames in the second row of a figure.
        figure;
        for i = 1:5
            subplot(2,  5,  i+5);
            draw_key_frame( t(index(i)),  y(index(i),  :),  l,  thetamin );
        end

        % Now unpack the result vector and calculate the energies
        r = y(:,  1);
        rdot = y(:,  3);
        theta = y(:,  2);
        thetadot = y(:,  4)
        KErider = 0.5*m*(r.^2.*thetadot.^2+rdot.^2);
        PErider = m*g*(r.*sin(theta)) + m*g*l*sin(thetamax);
        KEramp  =  0.5*I*thetadot.^2;

        % And create a plot of energies in the first row of the figure.
        subplot(2,  1,  1);
        plot(t,  KErider,  'g',  'LineWidth',  2);
        hold on
        plot(t,  PErider,  'r',  'LineWidth',  2);
        plot(t,  KEramp,  'b',  'LineWidth',  2);
        plot(t,  KErider+KEramp+PErider,  'k',  'LineWidth',  2);
        Emax = max(KErider);
        Emin = min(PErider);
        xlabel('Time (seconds)',   'FontSize',  24)
        ylabel('Energy (Joules)',  'FontSize',  24)
        set(gca,  'FontSize',  16)

        % Make lines at the five spots where we drew key frames
        for i = 1:5
            plot([t(index(i)),  t(index(i))],  [-0.1*Emax,  1.1*Emax],  'k',  'LineWidth',  0.5);
        end
        legend('Rider KE',  'Rider PE',  'Ramp KE',  'Total E')
        axis([min(t)-0.1,  max(t)+0.1,  -0.1*Emax,  1.1*Emax]);
end