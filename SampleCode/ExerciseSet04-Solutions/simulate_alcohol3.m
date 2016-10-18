% Simulates the change in alcohol stocks using Euler's method.
% (New version that uses forward_euler.m as a solver.)

initialS = 0.878;   % initial concentration in the stomach (g / l)
                    % (obtained from paper: Table 1, Subj. 9, Repl. 2)

initialB = 0;       % initial concentration in the lean body mass (g / l)                    

initialTime = 0;    % time at start of simulation (hours)
finalTime = 7;      % time at end of simulation (hours)
dt = 0.1;           % simulation time step (hours)

% NEW: Let's construct the vectors we need to call forward_euler.
timeSpan = initialTime:dt:finalTime;
Y0 = [initialS, initialB];

% NEW: Here we go -- simulating the model is now a one-liner!
[T, Y] = forward_euler(@alcohol_flows, timeSpan, Y0);

% NEW: After unpacking the results, we can continue as we did last week.
S = Y(:, 1);  % concentration in stomach
B = Y(:, 2);  % concentration in lean body mass
    
% Now let's plot both of the vectors. (Note that we're using hold on
% to overlay the vectors on the same graph -- this allows us to specify
% different markers for each time series.)
hold on
plot(T, S, 'bo');  % remove 'bo' to draw a smooth curve
plot(T, B, 'rx');  % remove 'rx' to draw a smooth curve