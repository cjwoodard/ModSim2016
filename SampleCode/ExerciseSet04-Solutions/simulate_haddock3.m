% Simulates the change in haddock stock using Euler's method.
% (New version that uses forward_euler.m as a solver.)

initialHaddock = 100000;   % initial stock of haddock (metric tons)

initialTime = 0;    % time at start of simulation (years)
finalTime = 100;    % time at end of simulation (years)
dt = 2.5;           % simulation time step (years)

% NEW: We need to construct the range of times first.
timeSpan = initialTime:dt:finalTime;

% NEW: Simulating the system is now a one-liner!
[T, haddock] = forward_euler(@haddock_flow, timeSpan, initialHaddock);

% Now we can plot the vector in one fell swoop (no "hold on" required).
plot(T, haddock, 'bo');  % remove 'bo' to draw a smooth curve