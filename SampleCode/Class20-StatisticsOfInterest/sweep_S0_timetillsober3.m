% Full 2D sweep of initial concentration and threshold BAC level; contour
% plot of the time until sober.

% Fixed parameters.
d = 0;           % drinking rate (g / l  hour)
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
k_e = 0.8;       % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)
                 
% Set up our sweep variables.
S0s = 0.5:0.1:3;   % initial concentration in the stomach (g / l)
                    % (0.5 =~ 1 drink)
thresholds = 0.2:0.025:0.8;   % threshold BAC (g / l)

% Convert our input variables to more intuitive units.
drinks = S0s / 0.5;   % initial concentration (g / l) to number of drinks
threshPcts = thresholds / 10;  % lean body mass conc. (g / l) to BAC %

% Set up our result matrix.
numS0s = length(S0s);
numThresholds = length(thresholds);
durations = zeros(numThresholds, numS0s);

% Now we do the sweeps and store the result in a matrix ...
for i = 1:numThresholds
    for j = 1:numS0s
        durations(i, j) = find_time_until_sober(S0s(j), d, k_a, k_e, ...
            thresholds(i));
    end
end

% Here we create a contour plot with a color bar ...
contourf(drinks, threshPcts, durations);

% NOTE FROM CLASS: Mark suggested these variations, which you can try
% by commenting out the line above and uncommenting the lines below.

%pcolor(drinks, threshPcts, durations); % compute the color in every cell
%shading interp % interpolate smoothly between cells (or leave commented out)

% Create the main title and axis labels (and fine-tune their positions).
title('How Long Does It Take To Get Sober?');
xlabel('Number of drinks');
ylabel('Definition of sober (BAC %)');

% Create a color bar with a title.
cb = colorbar;
title(cb, 'Hours');

% Now let's tune up the axes to put zero on both of them, and ticks
% where we want them ...
ax = gca;  % try "help gca" for an explanation
ax.XLim = [1 6];
ax.XTick = 1:6;
ax.YLim = [0.02 0.08];
ax.YTick = 0.02:0.02:0.08;