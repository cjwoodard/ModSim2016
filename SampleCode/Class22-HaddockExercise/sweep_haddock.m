% Plot the time at which the haddock population reaches 95% of its
% carrying capacity, as a function of g (full sweep) and K (at several
% widely spaced values).

% Fixed model parameters.
timeSpan = [0 200];        % initial and final simulation times (years)
initialHaddock = 100000;   % initial stock of haddock (metric tons)

% Set up our sweep variables.
Ks = [5e6 1e7 2e7 5e7];    % carrying capacity (metric tons)
gs = 0.05:0.001:0.15;       % growth rate (per year)
N = length(gs);

% Now we do the sweeps, and plot at the same time ...
hold on
for K = Ks
    saturationTimes = zeros(1, N);
    for j = 1:N
        saturationTimes(j) = find_haddock_saturation(timeSpan, ...
            initialHaddock, K, gs(j));
    end
    plot(gs*100, saturationTimes, 'DisplayName', num2str(K/1e6));
        % convert to percentage growth rates and millions of metric tons
end

% Finally, let's create some labels.
t = title('How Long Does It Take for the Haddock Population to Saturate?');
xl = xlabel('Growth rate (% / year)');
yl = ylabel('Years to saturation (95% of carrying capacity)');

% And make a nice legend, too.
l = legend('show');
title(l, 'Carrying capacity (million metric tons)')
l.Orientation = 'horizontal';
l.Position = [0.7 0.5 0 0];
legend('boxoff');