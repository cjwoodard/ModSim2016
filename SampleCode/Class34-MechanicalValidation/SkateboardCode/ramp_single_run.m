%%%%%%%%%%%%%%%%%%%%%%%
% ramp_single_run(m,M,l,thetainitial,rdotinitial)
% 
%
% Function to calculate the time on ramp and success or failure for a 
% given ramp design and given initial conditions
%
% [launch successful failure timeonramp t y]=ramp_single_run(m,M,l,thetainitial,rdotinitial)
% 
% Takes as input:
%   m: mass of rider, in kg
%   M: mass or ramp, in kg
%   l: distance from pivot to end of ramp, in m
%   thetainitial: initial angle (radians); assumed to be in contact with ground at
%       this angle
%   rdotinitial: initial speed of rider, m/s
%
% Returns:
%   launch: boolean for whether the rider leaves the ramp while ramp is in the air
%   successful: boolean for whether the rider successfully leaves to the right
%   failure: boolean for rider leaving to the left
%   timeonramp: floating point value of time spent on ramp
%   t: vector of times for the run
%   y: matrix of state variables for the run (r, theta, rdot, thetadot)
% 
%
% Includes stitching between condition where ramp is in the air, and
% condition where ramp is on the ground.
% 
    

function [launch successful failure timeonramp t y]=ramp_single_run(m,M,l,thetainitial,rdotinitial)


    I=1/12*M*(2*l)^2;   % Moment of inertia 
    g=10;               % gravitational acceleration
    rinitial=-l;        % Start rider at the left
    thetadotinitial=0;  % Ramp is not moving initially
    
    thetamax=thetainitial+eps;  % Set limits on theta so that ramp does not go through the ground
    thetamin=-thetamax;
    
    initialvelocity=rdotinitial; 
        
    x=[rinitial thetainitial  rdotinitial thetadotinitial]; % Set initial conditions: r=1, Theta=pi/4,rdot=0,thetadot=0

    
    % First we do an initial run of the fixed ramp...  
    
    % This option set will stop the ODE EITHER 
    % when the rider leaves the ramp on
    % the left, or when the rider crosses the pivot.
    %
    
    options=odeset('Events', @fixedevents, 'MaxStep',0.01); %
    
    % Solve the ODE for the fixed ramp case
    
    [t1,y1]=ode23s(@fixedrampde,[0 300],x,options);         
    y=y1;
    t=t1;
    
    % Now continue to run until we are off the ramp
    done = (y(end,1)>=l) || (y(end,1)<=-l); 
      
    while not(done)
        % If the rider is currently on the "up" side of the ramp...
        if y(end,1)*y(end,2)>0
            
            % Solve the free ramp ODE, until 
            % the ramp hits ground or rider leaves ramp
            options=odeset('Events', @freeevents);    %
            [t2,y2]=ode23s(@freerampde,[t(end) t(end)+300],y(end,:),options); % Solve the free DE
 
            t2=t2(2:end);
            y2=y2(2:end,:);
            
            y=[y;y2];
            t=[t;t2];
            
            % Check if the ramp hitting the ground is reason for termination
            % If so, set the ramp to stationary on the appropraite side
            
            if (y(end,2)>=thetamax)&&(abs(y(end,1))<l)  
                y(end,4)=0;
                y(end,2)=thetamax;
            elseif (y(end,2)<=thetamin)&&(abs(y(end,1))<l)
                y(end,4)=0;
                y(end,2)=thetamin;
            end
            
       % If the rider is on the "down" side of the ramp, run the 
       % appropriate de for that case
       % Note that you start in this condition, but can only re-enter this
       % condition by the ramp hitting the ground.
       
        else
            options=odeset('Events', @fixedevents, 'MaxStep',0.01); 
            [t3,y3]=ode23s(@fixedrampde,[t(end) t(end)+300],y(end,:),options);
            t3=t3(2:end);
            y3=y3(2:end,:);
            y=[y;y3];
            t=[t;t3];
        end
        
        % Evaluate if the rider has left the ramp
        done = (y(end,1)>=l) || (y(end,1)<=-l); 
    end
    
    % Now evaluate the run
    
    launch=(y(end,1)>=l) && (y(end,2)>thetamin);
    failure=y(end,1)<=0;
    successful=not(failure||launch);
    
    timeonramp=t(end);
 
        
    
    %%%%%%%%%%%%%%%%
    % DE for the free ramp case
    
    
    function result=freerampde(t,x);

        % This function returns the rdot, thetadot, rddot, and thetaddot
        % for a
        % block on a ramp
        % Unpack the input values

        r=x(1);
        theta=x(2);
        rdot=x(3);
        thetadot=x(4);
        %Calculate rddot:
        rddot=-g*sin(theta) +r*thetadot.^2;
        %calculate thetaddot
        numerator = -m*g*cos(theta)-2*m*rdot*thetadot;
        denominator=m*r+I/r;
        thetaddot=numerator./denominator;
        % Return the results
        result=[rdot;thetadot;rddot;thetaddot];

    end

    %%%%%%%%%%%%%%%%%%%%
    % Events to stop solving the free ramp DE
    %
    
    function [value,isterminal,direction]=freeevents(t,x)
        value(1)=x(2)-thetamin; %hit ground on the right
        isterminal(1)=1;
        direction(1)=-1;
        
        value(2)=x(2)-thetamax; %hit ground on the left
        isterminal(2)=1;
        direction(2)=1;
        
        value(3)=x(1)-l; % sail off the ramp in the air to right
        isterminal(3)=1;
        direction(3)=1;
        
        value(4)=x(1)+l; % sail off the ramp in the air to left
        isterminal(4)=1;
        direction(4)=-1;
    end
    
    %%%%%%%%%%%%%%%%
    % DE for the ramp that's on the ground and rider is on down side
    % i.e., a block on a FIXED ramp

    function result=fixedrampde(t,x)

        % Unpack the input values

        r=x(1);
        theta=x(2);
        rdot=x(3);
        thetadot=x(4);
        %Calculate rddot:
        rddot=-g*sin(theta);
        thetaddot=0;
        result=[rdot;thetadot;rddot;thetaddot];
        
    end

    
    %%%%%%%%%%%%%%%%
    % Events for stoppig solution to the fixed ramp DE
    %
    function [value,isterminal,direction]=fixedevents(t,x)
        value(1)=x(1)*x(2); %cross the pivot
        isterminal(1)=1;
        direction(1)=1;
        
        value(2)=x(1)-l; %rolls off to right
        isterminal(2)=1;
        direction(2)=1;
        
        value(3)=x(1)+l; % rolls off to the left
        isterminal(3)=1;
        direction(3)=-1;
        
    end


end
