%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simple script to animate the hopper for given parameter values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear all
m1=1; % Rod mass
m2=10; % Reaction mass
k=1000 % spring constant
l=0 % rest length of spring
R=1 % radius of disk (drives angle of spring)

[t,Y]=hopper(m1,m2,k,l,R);

figure;

animatehopper(t,Y);
