% Performs a simple parameter sweep on the alcohol model, plotting
% the results on the same axes.

% Fixed parameters.
S0 = 0.878;      % initial concentration in the stomach (g / l)
                 %     (obtained from paper: Table 1, Subj. 9, Repl. 2)                          
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)

% Now we do the sweep ...
hold on
for k_e = 0.4:0.2:0.8    % rate constant for elimination of alcohol
                         % from the lean body mass (1 / hour)

    % Call the simulation function.
    [T, Y] = simulate_alcohol4(S0, k_a, k_e);
    
    % Unpack the result.
    B = Y(:, 2);  % concentration of alcohol in lean body mass
    
    % Plot! Note that we don't have to specify a marker type or a color;
    % the plot function is smart enough to figure out that we want
    % connected lines and different colors for each overlaid time series.
    plot(T, B);
end

% Finally, let's make it an awesome-looking figure by labeling the axes.
title('Effect of Elimination Rate Parameter on Blood Alcohol Concentration');
xlabel('Time (hours)');
ylabel('Blood alcohol concentration (grams / liter)');
legend('k_e = 0.4', 'k_e = 0.6', 'k_e = 0.8');