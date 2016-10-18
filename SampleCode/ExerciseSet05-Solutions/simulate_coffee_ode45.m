% SIMULATE_COFFEE_ODE45  Simulate the coffee cooling model using ode45.
%   [t, T] = simulate_coffee_ode45(initialTime, finalTime) returns a column
%   vector of times (in seconds) and a column vector of corresponding
%   temperatures (in Kelvin). The function takes the initial and final
%   time to be simulated (in seconds) as parameters.

function [t, T] = simulate_coffee_ode45(initialTime, finalTime)

    %% Model parameters (same as before)

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

    %% Calculated variables (same as before)

    areaOfSurface = pi * radiusOfCup^2;                         % m^2
    areaOfConduction = (2*pi * radiusOfCup * heightOfCoffeeInCup) + ...
        areaOfSurface;                                          % m^2
    volumeOfCoffee = areaOfSurface * heightOfCoffeeInCup;       % m^3
    massOfCoffee = volumeOfCoffee * densityOfCoffee;            % kg
    heatCapacityOfCoffee = massOfCoffee * specificHeatOfCoffee; % J/K
    initialEnergy = temperatureToEnergy(initialTemperature, ... % J
        heatCapacityOfCoffee);
    
    %% Drum roll ... ode45!

    % NOTE: MATLAB magic here. This cryptic incantation is really doing
    % something very simple, namely constructing an "anonymous function"
    % that invokes our coffee_flow function with the parameters of the
    % model that are defined above (environmentalTemperature, etc.), while
    % leaving ti and Ui free to be "filled in" by ode45 itself. This allows
    % us to pass exactly the parameters we need, without using global
    % variables or nesting the flow function within this one (both of which
    % work fine but have other drawbacks, as noted in the Appendix).
    dUdt = @(ti, Ui) coffee_flow(ti, Ui, environmentalTemperature, ...
            heatCapacityOfCoffee, thicknessOfCupWalls, ...
            thermalConductivityOfCupWalls, areaOfConduction);

    % And now, we invoke ode45 with the anonymous function we constructed
    % above, along with a vector consisting of the initial and final
    % simulation times (note that we don't need dt anymore!), and the
    % initial energy of the coffee.
    [t, U] = ode45(dUdt, [initialTime finalTime], initialEnergy);
    
    %% Results (same as before)

    % Construct a vector of temperatures from internal energies.
    % (Note that our temperature functions also work with vectors.)
    T = energyToTemperature(U, heatCapacityOfCoffee);
    
    % As indicated at the beginning of the function, we return the
    % column vectors t and T. (For a more general discussion of
    % returning multiple values in MATLAB, see, e.g.,
    % http://stackoverflow.com/questions/4188139.)
end
