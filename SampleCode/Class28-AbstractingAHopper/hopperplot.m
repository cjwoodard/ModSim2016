close all
m1 = .1;    % mass of rod in kg
m2 = .2;    % mass of ring in kg
figure;

[t, M] = hopper(m1, m2);
plot(t,M(:,2));
hold on
plot(t,M(:,4), 'r')
legend('Rod', 'Ring')
xlabel('time (s)')
ylabel('Vertical Position (m)')