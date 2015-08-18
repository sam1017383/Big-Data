close all 
num_training_points = 100;

mu1x = 100*rand();
sigma1x = 20*rand()+10;
mu1y = 100*rand();
sigma1y = 20*rand()+10;
x1 = random('normal',mu1x, sigma1x,[1,100]);
y1 = random('normal',mu1y, sigma1y,[1,100]);
c1 = ones(1,100);

mu2x = 100*rand();
sigma2x = 10*rand();
mu2y = 100*rand();
sigma2y = 10*rand();

x2 = random('normal',mu2x, sigma2x,[1,100]);
y2 = random('normal',mu2y, sigma2y,[1,100]);
c2 = 2.*ones(1,100);

points = [x1, x2 ; y1, y2];
class = [c1 c2];

%pruebax = floor(100*rand());
%pruebay = floor(100*rand());
pruebax = 50;
pruebay = 50;

prueba = [pruebax ; pruebay];

res = k_nn_classifier(points, class, 3, prueba);

axis([0 100 0 100])
hold all 
figure(1)
plot (x1, y1, 'r.')
plot (x2, y2, 'b.')

if res == 1
    plot (pruebax, pruebay, 'ro')
elseif res == 2
    plot (pruebax, pruebay, 'bo')
end