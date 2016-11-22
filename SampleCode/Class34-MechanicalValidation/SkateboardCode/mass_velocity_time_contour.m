% %%%%
% Script: mass_velocity_time_coutour
% 
% Creates pcolor of time on ramp, along with contour of success
% Used to pre-process data for exploring behavior with
% SkateboardPlaneExploration
% 

clear
% Set parameter values
m = 75 % mass of rider, kg
M = 150 % mass of ramp, kg
l = 2 % Set total length of ramp to L = 4 (ramp runs from -1 to l)
    
% Set range of velocities, angles, masses, etc.
vmin = 5.5; % minimum initial velocity, m/sec
vmax = 7.8; % maximum initial velocity, m/sec
theta = pi/4 % initial angle of ramp, radians
Mmin = 0.1*m; % minimum ramp mass
Mmax = 15*m; % maximum ramp mass
gridsize = 10; % resolution of grid

% Create grid of velocity and ramp mass values
[v,M] = meshgrid(linspace(vmin, vmax,gridsize), linspace(Mmin,Mmax,gridsize));

% Loop through all values of velocity and ramp mass;
% run simulation; 
% Store the results
for i = 1:gridsize
    for j = 1:gridsize
        [launch success fail time] = ramp_single_run(m,M(i,j),l,theta,v(i,j));
        la(i,j) = launch;
        fa(i,j) = fail;
        su(i,j) = success;
        ti(i,j) = time;
    end
end

% Create a "heat map" of time on ramp
pcolor(v,M/m,ti);shading flat;hold on; 

% Draw a contour showing the area that is successful
contour(v,M/m,su,1)  
xlabel('Velocity of Rider (m/sec)')
ylabel('M_{ramp}/m_{rider}')
title('Time on ramp')
colorbar
