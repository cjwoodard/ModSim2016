% MYFLOW_DIAG5  An example of a flow function that plays nicely with
% ode45 (modified for Diagnostic 4; unchanged in Diagnostic 5).

function res = myflow_diag5(~, currentEnergy, environmentalTemperature, ...
    heatCapacityOfCoffee, heatTransferCoefficient, areaOfSurface)

    % Compute the temperature gradient (from coffee_flow.m).
    deltaTemperature = energyToTemperature(currentEnergy, ...
        heatCapacityOfCoffee) - environmentalTemperature; 

    % Compute the convection flow (NEW).
    convectionFlow = heatTransferCoefficient * areaOfSurface * ...
            deltaTemperature;

    % Make it negative to produce a net flow out of the coffee stock.
    res = -convectionFlow;
end
