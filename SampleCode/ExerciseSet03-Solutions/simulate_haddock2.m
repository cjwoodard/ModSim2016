% Simulates the change in haddock stock using Euler's method.
% (Alternative version that makes more extensive use of vectors.)

initialHaddock = 100000;   % initial stock of haddock (metric tons)

initialTime = 0;    % time at start of simulation (years)
finalTime = 100;    % time at end of simulation (years)
dt = 2.5;           % simulation time step (years)

% Compute the number of time steps required. (To see why we need the
% floor function, try omitting it and choosing a time step that doesn't
% divide evenly into finalTime.)
N = floor((finalTime - initialTime) / dt);

% Pre-allocate a column vector for the stock time series, and set its
% first element to the initial value defined above.
haddock = [initialHaddock; zeros(N, 1)];

% Create another column vector to hold the time of each stock observation;
% note that it has the same dimensions as our stock time series vector.
t = [initialTime; zeros(N, 1)];

% Once again, the forward Euler loop. (Note that we iterate using a
% counter, starting at 2, because we need it as an index into the
% stock and time vectors.)
for i = 2:N+1
    
    % Note that when we invoke the flow function to obtain the current
    % flow, we pass it the previous value of the stock, haddock(i-1).
    currentFlow = haddock_flow(haddock(i-1));
    
    % Similarly, we update the haddock vector based on the previous
    % value of the stock plus the current flow times dt (the heart of
    % Euler's method).
    haddock(i) = haddock(i-1) + (currentFlow * dt);
    
    % And we also have to update the time vector ...
    t(i) = t(i-1) + dt;
end

% Now we can plot the vector in one fell swoop (no "hold on" required).
plot(t, haddock, 'bo');  % remove 'bo' to draw a smooth curve