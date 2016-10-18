% Sweep the initial concentration of alcohol (S0), then plot S0 versus
% the duration that the BAC remains above a given threshold.

% Fixed parameters.
d = 0;           % drinking rate (g / l  hour)
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
k_e = 0.8;       % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)
threshold = 0.1; % threshold BAC (g / l) [FIXED VALUE]
                 
                 
% Set up our sweep variable.
S0s = 0.5:0.5:2.5;  % initial concentration in the stomach (g / l)
                    % (0.5 =~ 1 drink)

% Set up our result variables.
N = length(S0s);
durations = zeros(1, N);

% Now we do the sweep ...
for i = 1:N
    durations(i) = find_duration_of_drunkenness(S0s(i), d, k_a, k_e, ...
        threshold);
end

% And plot ...
plot(S0s, durations, 'b*-');

% Now that's a little more interesting! How about we do the same plot
% for multiple values of the threshold?
