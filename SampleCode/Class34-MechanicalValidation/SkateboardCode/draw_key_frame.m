%%%%%%%%%%%%%%%%
% draw_key_frame(t,  y,  l,  thetamin)
% 
% Draws a single frame of the simulation in the current axis.  
%
% Takes as input:
%   t,   y: the time vector and results matrix from ramp_single_run
%   l,   thetamin: parameters defining the ramp (distance from pivot to end 
%                and minimum angle of ramp
% 
% Returns no output.

function result=draw_key_frame(t,  y,  l,  thetamin);

    % Unpack radial position and angle
    r=y( :,  1);
    theta=y( :,  2);
    
   
    cla;
    
    % Draw the ramp
    line( [-l*cos(theta),  l*cos(theta)],  [-l*sin(theta), l*sin(theta)]);
    
    % Draw the ground
    line( [-l l],  [ l*sin(thetamin),  l*sin(thetamin) ], 'LineWidth',  0.5);
    hold on;
    
    % Draw the rider
    plot( r*cos(theta),  r*sin(theta),  'ro',...
        'MarkerSize',  10,  'MarkerFaceColor',  'r');
    
    % Fix the aspect ratio and size of the frame
    axis([-l l -l l])
    axis square
    set(gca,  'XTickLabel',  ' ')
    set(gca,  'YTickLabel',  ' ')

    drawnow;
    result=[];

    end
