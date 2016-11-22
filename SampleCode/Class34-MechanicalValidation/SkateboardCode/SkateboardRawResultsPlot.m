% Plot_r_theta
% Simple script to look at r and theta versus time
%
close all
clear all
g=10
m=75 % Set rider mass to 75 kg
M=150 % Set ramp mass to 150 kg
l=2 % Set total length of ramp to L=4 (ramp runs from -1 to l)
thetainitial=pi/4 % Ramp angle of 45 degrees
rdotinitial=6.2;
thetadotinitial=0;
[launch successful failure timeonramp t y]=ramp_single_run(m,M,l,thetainitial,rdotinitial);
figure;
plot(t,y(:,1),'b');
hold on
plot(t,y(:,2),'r');
legend('r','theta')
xlabel('time')
text(0.1,0,['v_{initial}=' num2str(rdotinitial)])
