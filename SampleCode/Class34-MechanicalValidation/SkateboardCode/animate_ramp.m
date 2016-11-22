%%%%%%%%%%%%%%
% animate_ramp(t,y,l)
% 
% Takes as input:
%   t,   y: the time vector and results matrix from ramp_single_run
%   l:      parameter defining the distance from pivot to end of ramp
% 
% Returns nothing.

function animate_ramp(t,y,l);

    % Create interpolated time and state vectors so that animation is
    % smooth.
    tinterp=0:0.02:t(end);
    rinterp=interp1(t,y(:,1),tinterp);
    thetainterp=interp1(t,y(:,2),tinterp);
    
    
    % Now loop through the interpolated vectors, and draw the appropriate
    % frame
   
    for i=1:length(tinterp);
        r=rinterp(i);
        theta=thetainterp(i);

        cla;
        line([-l*cos(theta),l*cos(theta)],[-l*sin(theta),l*sin(theta)]); % Draw the ramp
        hold on;
        plot(r*cos(theta),r*sin(theta),'ro','MarkerSize',10,'MarkerFaceColor','r'); % Draw the rider
        axis([-l l -l l])
        axis square;
        drawnow;
    end
    result=[];

    end