% Plot the coffee temperature as a function of time, adding cream
% at different points in the cooling process.

% Define the desired simulation start and end times.
initialTime = 0;            % start time of the simulation (seconds)
finalTime = 30*60;          % end time of the simulation (seconds)

% Define the times we want to add cream.
creamTimes = [0, 5, 15, 25]*60;

% Simulate the model and plot the results.
hold on
for ct = creamTimes
    
    % Run the simulation for the current value of ct.
    [t, T] = simulate_coffee_cream(initialTime, finalTime, ct);
    
    % Let's plot inside the loop, just to make it easy to play around
    % with the cream adding times. The last two arguments of the plot
    % function set the name of this series in the legend to the
    % number of minutes of cooling before the cream is added. (We need
    % the int2str function to convert this number to a string; try
    % just using ct/60 to see what happens.)
    plot(t/60, T-273.15, 'DisplayName', int2str(ct/60));
end

% And now that we know how to add labels, let's do it!
title('Temperature of Coffee over Time ... Now with Cream!');
xlabel('Time (minutes)');
ylabel('Temperature ({\circ}C)');

% And just for fun, let's do some fancier things with the legend.
% (Try 'help legend' for details.)
l = legend('show');
title(l, 'Cooling time before cream added (minutes)')
l.Orientation = 'horizontal';
l.Position = [0.7 0.35 0 0];
legend('boxoff');
