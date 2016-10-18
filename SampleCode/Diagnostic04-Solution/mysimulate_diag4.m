% MYSIMULATE_DIAG4  An example of a simulation function that uses ode45
%   (modified for Diagnostic 4).

function [t, T] = mysimulate_diag4(initialTime, finalTime)

    %% Model parameters

    initialTemperature = 370;            % K
    environmentalTemperature = 290;      % K

    radiusOfCup = 4 / 100;               % m (converted from cm)
    heightOfCoffeeInCup = 15 / 100;      % m (converted from cm)

    heatTransferCoefficient = 100;       % W/(m^2*K) [NEW]

    specificHeatOfCoffee = 4186;         % J/(kg*K) (same as water)
    densityOfCoffee = 1000;              % kg/m^3 (same as water)

    %% Calculated variables

    areaOfSurface = pi * radiusOfCup^2;                         % m^2
    volumeOfCoffee = areaOfSurface * heightOfCoffeeInCup;       % m^3
    massOfCoffee = volumeOfCoffee * densityOfCoffee;            % kg
    heatCapacityOfCoffee = massOfCoffee * specificHeatOfCoffee; % J/K
    initialEnergy = temperatureToEnergy(initialTemperature, ... % J
        heatCapacityOfCoffee);
    
    %% Now invoke ode45 and convert the resulting energies to temperature.

    dUdt = @(ti, Ui) myflow_diag4(ti, Ui, environmentalTemperature, ...
            heatCapacityOfCoffee, heatTransferCoefficient, areaOfSurface);

    [t, U] = ode45(dUdt, [initialTime finalTime], initialEnergy);

    T = energyToTemperature(U, heatCapacityOfCoffee);    
end
