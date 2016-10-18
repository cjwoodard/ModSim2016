% Plot the time until BAC drops below a threshold as a function of the
% number of initial drinks.

% Fixed parameters.
d = 0;           % drinking rate (g / l  hour)
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
k_e = 0.8;       % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)
                 
% Set up our sweep variables.
S0s = 0.5:0.05:3;   % initial concentration in the stomach (g / l)
                    % (0.5 =~ 1 drink)
threshold = 0.5;    % threshold BAC (g / l)

% Convert our input variable to more intuitive units
drinks = S0s / 0.5;  % initial concentration (g / l) to number of drinks

% Set up our result variables.
N = length(S0s);
durations = zeros(1, N);

% Now we do the sweep, then plot ...
for j = 1:N
    durations(j) = find_time_until_sober(S0s(j), d, k_a, k_e, ...
        threshold);
end
plot(drinks, durations, 'DisplayName', num2str(threshold / 10));
    % divide by 10 to convert lean body mass conc. (g / l) to BAC %

% Finally, let's create some labels (and fine-tune their positions) ...
t = title('How Long Does It Take To Get Sober?');
t.Position = [3 5.1 0];
xl = xlabel('Number of drinks');
xl.Position = [3 -0.3 0];
yl = ylabel('Hours until sober');
yl.Position = [-0.3 2.5 0];

% Let's tune up the axes to put zero on both of them ...
ax = gca;  % try "help gca" for an explanation
ax.XLim = [0 6];
ax.XTick = 0:6;
ax.YLim = [0 5];
ax.YTick = 0:5;

% And make a nice legend, too.
l = legend('show');
title(l, 'Definition of sober (BAC %)')
l.Orientation = 'vertical';
l.Position = [0.28 0.72 0 0];
legend('boxoff');