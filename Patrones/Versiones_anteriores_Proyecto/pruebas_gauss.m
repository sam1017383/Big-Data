close all 

mu = [0 0];
sigma = [3 0; 0 3];

x = random('normal',70, 5,[1,100])
y = random('normal',50, 5,[1,100])


axis([0 100 0 100])
hold all 
figure(1)
plot (x, y, 'r.')