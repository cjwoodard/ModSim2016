% Sweep the initial concentration of alcohol (S0), plotting full time
% series of blood alcohol concentration.

% Fixed parameters.
d = 0;           % drinking rate (g / l  hour)
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
k_e = 0.8;       % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)

% Set up our sweep variable.
S0s = 0.5:0.5:3.0;  % initial concentration in the stomach (g / l)
                    % (0.5 =~ 1 drink)

% Now we do the sweep ...
hold on;
for S0 = S0s;
    [t, Y] = simulate_alcohol_ode45(S0, d, k_a, k_e);    
    plot(t, Y(:,2), 'DisplayName', num2str(S0));
end

% Finally, let's label the axes ...
title('Effect of Initial Consumption on Blood Alcohol Concentration');
xlabel('Time (hours)');
ylabel('Blood alcohol concentration (grams / liter)');

% And make a nice legend ...
l = legend('show');
title(l, 'Initial consumption (grams / liter)')
l.Orientation = 'vertical';
l.Position = [0.7 0.4 0 0];
legend('boxoff');
