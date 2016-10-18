% Plot one time series of BAC.

% Fixed parameters.
d = 0;           % drinking rate (g / l  hour)
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
k_e = 0.8;       % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)

S0 = 1.0;        % initial concentration in the stomach (g / l)

[t, Y] = simulate_alcohol_ode45(S0, d, k_a, k_e);    
plot(t, Y);

% Finally, let's label the axes ...
title('Time Series of Alcohol Concentration');
xlabel('Time (hours)');
ylabel('Concentration (grams / liter)');

% And make a nice legend ...
legend('Stomach', 'Lean body mass');
%title(l, 'Initial consumption (grams / liter)')
%l.Orientation = 'vertical';
%l.Position = [0.7 0.4 0 0];
%legend('boxoff');
