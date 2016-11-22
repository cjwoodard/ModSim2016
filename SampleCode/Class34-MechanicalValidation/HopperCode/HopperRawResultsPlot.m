%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple script that calls the hopper function and plots the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all

m1=1; % Rod mass
m2=10; % Reaction mass
k=1000 % spring constant
l=0 % rest length of spring
R=1 % radius of disk (drives angle of spring)

[t,Y]=hopper(m1,m2,k,l,R);

figure
plot(t,Y(:,2),'r','Linewidth',2)
hold on
plot(t,Y(:,4),'b','Linewidth',2)

xlabel('Time')
ylabel('Position')
legend('Rod','Reaction Mass')

title('Raw results of ODE45')
h=gca;
xlim=get(h,'XLim')
ylim=get(h,'YLim')
text(xlim(1)+.1,ylim(end)-(ylim(end)-ylim(1))/16,['m_{rod}=',num2str(m1),...
    ' m_{ring}=',num2str(m2),' k=',num2str(k),' R=',num2str(R),' l_0=',num2str(l)],'FontSize',14)

