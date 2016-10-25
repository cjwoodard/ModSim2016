% Plot the time required to cool to a given temperature, for a range of
% cream adding times. Then compute the optimal cream adding time.

% Define the desired simulation start and end times.
initialTime = 0;            % start time of the simulation (seconds)
finalTime = 12*60;          % end time of the simulation (seconds)

% Define the target temperature and number of cream times to examine.
targetTemperature = 320;    % K
numCreamTimes = 100;

%% PLOT OF CREAM TIMES VS. COOLING TIMES

% Create vectors for the cream-adding times and associated cooling times.
creamTimes = linspace(initialTime, finalTime, numCreamTimes)';
coolTimes = zeros(1, numCreamTimes);

% Simulate the model and store the results.
for i = 1:numCreamTimes
    coolTimes(i) = simulate_cooling_time(initialTime, finalTime, ...
        creamTimes(i), targetTemperature);
end

% Now plot the results and label the graph.
plot(creamTimes/60, coolTimes/60, 'DisplayName', strcat('Target temp. ={ }', ...
    num2str(targetTemperature - 273.15), '{\circ}C'));
title('Time to Cool as a Function of Cream Adding Time');
xlabel('Time cream is added (minutes)');
ylabel('Cooling time (minutes)');

% Let's tune up the axes to make the limits equal.
ax = gca;  % try "help gca"
ax.XLim = [0 finalTime/60];
ax.YLim = [0 finalTime/60];

% And put the legend where we want it.
l = legend('show');
l.Orientation = 'horizontal';
l.Position = [0.7 0.3 0 0];
legend('boxoff');

%% OPTIMAL CREAM ADDING TIME (optional)

% Create a function handle and invoke fminsearch.
simFunction = @(creamTime) simulate_cooling_time(initialTime, finalTime, ...
    creamTime, targetTemperature);
optimalCreamTime = fminsearch(simFunction, initialTime); % start at initialTime

% Display the result.
disp('Optimal time to add cream (in seconds and minutes):');
disp([optimalCreamTime optimalCreamTime / 60]);
