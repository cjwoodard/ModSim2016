% Create a contour plot of the final height of the baseball as a function
% of the angle and speed with which it is hit.

% Range of speeds and angles to plot.
speeds = 30:0.5:60;
angles = 25:0.5:65;

% Initialize our matrix of heights.
numSpeeds = length(speeds);
numAngles = length(angles);
heights = zeros(numSpeeds, numAngles);

% Now sweep the speeds and angles.
for row = 1:numSpeeds
    for col = 1:numAngles
        heights(row, col) = simulate_manny(speeds(row), angles(col));
    end
end

% Then create our beautiful plot.
pcolor(angles, speeds, heights)
shading interp
colorbar

% Overlay two contours, one at the height of the Green Monster and one
% near the ground. (We run into numerical issues if we plot the contour
% at exactly zero, but 1 meter is close enough for the purpose of
% visualizing the wall.)
hold on
greenMonster = contour(angles, speeds, heights, [12 12], 'r*-');
contour(angles, speeds, heights, [1 1], 'r*-')

% Now add some labels.
xlabel('Angle (deg)')
ylabel('Speed (m/s)')
title('Final Height of Baseball')
text(45, 32, 'Green Monster is between the red lines', 'Color', 'white')

% Finally, to determine the minimum speed that clears the wall, we can
% use the contour matrix we defined above.
[minSpeed, indexOfMinSpeed] = min(greenMonster(2,:));  % 2nd row is speeds
minAngle = greenMonster(1,indexOfMinSpeed);    % pick angle with min speed

disp(['Minimum speed: ', num2str(minSpeed)]);
disp(['Angle of minimum speed: ', num2str(minAngle)]);
