% Plot the coffee temperature as a function of time.
% (Two ways: Euler's method and ode45.)

% Define the desired simulation start and end times.
initialTime = 0;            % start time of the simulation (seconds)
finalTime = 30*60;          % end time of the simulation (seconds)

% Simulate the model.
[t1, T1] = simulate_coffee_euler(initialTime, finalTime);
[t2, T2] = simulate_coffee_ode45(initialTime, finalTime);

% Now plot the time series. 
hold on
plot(t1/60, T1-273.15, 'b*-');     % convert units for easy reading
plot(t2/60, T2-273.15, 'r*-');     % convert units for easy reading

% And now that we know how to add labels, let's do it!
title('Temperature of Coffee over Time');
xlabel('Time (minutes)');
ylabel('Temperature ({\circ}C)');
legend('Euler', 'ode45');