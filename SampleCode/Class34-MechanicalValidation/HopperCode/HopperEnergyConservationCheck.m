%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Validation script to check for hopper energy conservation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all
clear all
m1=1; % Rod mass
m2=10; % Reaction mass
k=1000 % spring constant
l=0 % rest length of spring
R=1 % radius of disk (drives angle of spring)

[t,Y]=hopper(m1,m2,k,l,R);

KE1=1/2 * m1 * Y(:,6).^2;

KE2=1/2 * m2 * Y(:,8).^2;

PE1=10*m1*Y(:,2);

PE2=10*m2*Y(:,4);

Lspring = sqrt(R^2 + (Y(:,2)-Y(:,4)).^2);

PEspring = 1/2 * k * (Lspring - l).^2;

figure;
hold on
plot(KE1,'r-.','LineWidth',3);
plot(KE2,'b-.','LineWidth',3);

plot(PE1,'r','LineWidth',3);
plot(PE2,'b','LineWidth',3);

plot(PEspring,'k');

plot(KE1+KE2+PE1+PE2+PEspring,'k','LineWidth',3)

legend('KE Rod','KE Reaction Mass','PE Rod','PE Reaction Mass','PE spring','Total')
xlabel('time (seconds)')
ylabel('Energy (Joules)')