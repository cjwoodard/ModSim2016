%%% 
% SkateboardAnimationValidation
%
% This is a wrapper function that does a single run of the skateboard
% simulation and then turns it into an animation.
%
% It takes no inputs and returns no outputs other than an animation.

function SkateboardAnimationValidation()

    close all
    clear all
    
    % Set parameters
    m = 75 % Set rider mass to 75 kg
    M = 150 % Set ramp mass to 150 kg
    l = 2 % Set total length of ramp to L = 4 (ramp runs from -1 to l)
    
    % Set initial conditions
    thetainitial = pi/4 % Ramp angle in radians
    rdotinitial = 6.2; % initial velocity,   m/sec
    thetadotinitial = 0; % initial angular velocity,   radians/sec
    
    % Do the simulation
    [launch successful failure timeonramp t y] = ...
        ramp_single_run(m, M, l, thetainitial, rdotinitial);
    
    % Create the animation using the results of the simulation
    figure;
    animate_ramp(t,  y,  l);
    
end