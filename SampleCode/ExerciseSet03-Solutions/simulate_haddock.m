% Simulates the change in haddock stock using Euler's method.

haddock = 100000;   % initial stock of haddock (metric tons)

initialTime = 0;    % time at start of simulation (years)
finalTime = 100;    % time at end of simulation (years)
dt = 2.5;           % simulation time step (years)

% Note that we only have to do this once at the beginning of the
% simulation to make all of the plot commands add points to the
% same graph.
hold on

% Here is the forward Euler loop -- it's pretty simple, but you should
% read it carefully and be sure you understand what's going on!
for t = initialTime:dt:finalTime
    flow = haddock_flow(haddock);
    haddock = haddock + (flow * dt);  % note that we multiply the flow by dt
    plot(t, haddock, 'bo');
end