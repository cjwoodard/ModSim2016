%%%
% SkateboardPlaneExploration()
% 
% Creates a pcolor of time on ramp as a function of mass and velocity
% and allows user to click on different locations to see corresponding 
% animation.  
%
% Takes no inputs; returns no outputs; does require data file created by
% mass_velocity_time_contour.m
%

function SkateboardPlaneExploration()

    close all
    clear all
    % Load in all data (saved from previous run to avoid having to create the pcolor on the fly!)
    load('mvcontour.mat') 
    
    % Create a pcolor of time on ramp, with the success region indicated
    subplot(2,1,1);
    pcolor(v,M,ti);shading flat;hold on; contour(v,M,su,1)
    colorbar
    xlabel('Velocity of Rider (m/sec)')
    ylabel('M_{ramp}/m_{rider}')
    
    % Now allow user to click in five different locations, and run
    % corresponding animation below the pcolor.
    for i=1:5
        subplot(2,1,1);
        [vanim,Manim]=ginput(1); % Get mouse input
        subplot(2,1,2);
        [launch successful failure timeonramp t y]=ramp_single_run(m,Manim,l,theta,vanim);
        animate_ramp(t,y,l);
    end
end
