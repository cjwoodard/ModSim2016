% Sweep the initial concentration of alcohol (S0) and the threshold BAC
% level, then plot S0 (converted to number of drinks) versus the duration
% that the BAC remains above the threshold.

% Fixed parameters.
d = 0;           % drinking rate (g / l  hour)
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
k_e = 0.8;       % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)
                 
% Set up our sweep variables.
S0s = 0.5:0.1:2.5;  % initial concentration in the stomach (g / l)
                    % (0.5 =~ 1 drink)
thresholds = 0.2:0.15:0.8;   % threshold BAC (g / l)

% Convert our input variable to more intuitive units
N0s = S0s / 0.5;  % initial concentration (g / l) to number of drinks

% Set up our result variables.
N = length(S0s);
durations = zeros(1, N);

% Now we do the sweeps, and plot at the same time ...
hold on
for threshold = thresholds
    for j = 1:N
        durations(j) = find_duration_of_drunkenness(S0s(j), d, k_a, k_e, ...
            threshold);
    end
    plot(N0s, durations, 'DisplayName', num2str(threshold / 10));
        % divide by 10 to convert lean body mass conc. (g / l) to BAC %
end

% Finally, let's label the axes ...
title('Relationship Between Number of Drinks and Duration of Drunkenness');
xlabel('Number of drinks');
ylabel('Duration of drunkenness (hours)');

% Let's tune up the axes to put zero on both of them ...
ax = gca;  % try "help gca" for an explanation
ax.XLim = [0 5];
ax.XTick = 0:5;
ax.YLim = [0 4.2];
ax.YTick = 0:4;

% And make a nice legend, too.
l = legend('show');
title(l, 'Definition of drunk (BAC %)')
l.Orientation = 'vertical';
l.Position = [0.28 0.72 0 0];
legend('boxoff');