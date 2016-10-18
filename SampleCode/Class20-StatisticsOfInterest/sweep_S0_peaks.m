% Sweep the initial concentration of alcohol (S0), then plot S0 versus
% the peak time and concentration.

% Fixed parameters.
d = 0;           % drinking rate (g / l  hour)
k_a = 1.5;       % rate constant for absorption of alcohol from the
                 %     stomach to the lean body mass (1 / hour)
k_e = 0.8;       % rate constant for elimination of alcohol from the
                 %     lean body mass (1 / hour)

% Set up our sweep variable.
S0s = 0.5:0.5:2.5;  % initial concentration in the stomach (g / l)
                    % (0.5 =~ 1 drink)

% Set up our result variables.
N = length(S0s);
peakTimes = zeros(1, N);
peakLevels = zeros(1, N);

% Now we do the sweep ...
for i = 1:N
    [peakTimes(i), peakLevels(i)] = ...
        find_peak_concentration(S0s(i), d, k_a, k_e);    
end

% And do the first plot (peakTimes) ...
figure(1);
plot(S0s, peakTimes, 'b*-');

% And then the second plot (peakLevels) ...
figure (2);
plot(S0s, peakLevels, 'r*-');

% Uh oh -- these aren't very interesting! Peak times are all approximately
% equal (can check by setting tolerances in the simulation function), and
% peak levels are linearly related to S0 (can check using MATLAB's built-in
% curve fitting app).