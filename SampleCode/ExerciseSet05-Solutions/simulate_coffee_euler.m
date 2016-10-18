% SIMULATE_COFFEE_EULER  Simulate the coffee cooling model using Euler's method.
%   [t, T] = simulate_coffee_euler(initialTime, finalTime) returns a column
%   vector of times (in seconds) and a column vector of corresponding
%   temperatures (in Kelvin). The function takes the initial and final
%   time to be simulated (in seconds) as parameters.

function [t, T] = simulate_coffee_euler(initialTime, finalTime)

    %% Model parameters

    initialTemperature = 370;            % K
    environmentalTemperature = 290;      % K

    radiusOfCup = 4 / 100;               % m (converted from cm)
    heightOfCoffeeInCup = 15 / 100;      % m (converted from cm)

    thicknessOfCupWalls = 0.7 / 100;     % m (converted from cm)
    thermalConductivityOfCupWalls = 1.5; % W/(m*K)
    % Source: http://www.engineeringtoolbox.com/thermal-conductivity-d_429.html
    % (see "porcelain")

    specificHeatOfCoffee = 4186;         % J/(kg*K) (same as water)
    densityOfCoffee = 1000;              % kg/m^3 (same as water)

    %% Simulation settings
    
    % (Note that initialTime and finalTime are passed as parameters above.)
    dt = 60;                             % simulation time step (seconds)

    %% Calculated variables

    areaOfSurface = pi * radiusOfCup^2;                         % m^2
    areaOfConduction = (2*pi * radiusOfCup * heightOfCoffeeInCup) + ...
        areaOfSurface;                                          % m^2
    volumeOfCoffee = areaOfSurface * heightOfCoffeeInCup;       % m^3
    massOfCoffee = volumeOfCoffee * densityOfCoffee;            % kg
    heatCapacityOfCoffee = massOfCoffee * specificHeatOfCoffee; % J/K
    initialEnergy = temperatureToEnergy(initialTemperature, ... % J
        heatCapacityOfCoffee);

    %% Initialization

    % Compute the number of time steps required.
    N = floor(finalTime / dt);

    % Pre-allocate a column vector for the stock of internal energy, and
    % set its first element to the initial value defined above.
    U = [initialEnergy; zeros(N, 1)];

    % Create another vector to hold the time of each stock observation.
    t = [initialTime; zeros(N, 1)];

    %% Main loop (Euler's method)

    for i = 2:N+1
        
        % See coffee_flow.m for an explanation of why we pass the
        % current time (and what the ...'s mean).
        currentFlow = coffee_flow(t, U(i-1), environmentalTemperature, ...
            heatCapacityOfCoffee, thicknessOfCupWalls, ...
            thermalConductivityOfCupWalls, areaOfConduction);
        
        % Now update via forward Euler as usual.
        U(i) = U(i-1) + (currentFlow * dt);
        t(i) = t(i-1) + dt;
    end

    %% Results

    % Construct a vector of temperatures from internal energies.
    % (Note that our temperature functions also work with vectors.)
    T = energyToTemperature(U, heatCapacityOfCoffee);
    
    % As indicated at the beginning of the function, we return the
    % column vectors t and T. (For a more general discussion of
    % returning multiple values in MATLAB, see, e.g.,
    % http://stackoverflow.com/questions/4188139.)
end
