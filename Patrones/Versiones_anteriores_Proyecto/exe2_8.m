close all 
num_clases = 4;
num_trainig_points = 100;
equis = floor(100*rand(1,num_trainig_points));
ye = floor(100*rand(1,num_trainig_points));
points = [equis ; ye]
classified = floor(num_clases*rand(1,num_trainig_points)) + 1

pruebax = floor(100*rand(1,1));
pruebay = floor(100*rand(1,1));
prueba = [pruebax ; pruebay]

axis([0 100 0 100])
hold all 
figure (1)

for i=1:num_trainig_points
    if classified(i) == 1
        plot (equis(i), ye(i), 'r.')
    elseif classified(i) == 2
        plot (equis(i), ye(i), 'b.')
    elseif classified(i) == 3
        plot (equis(i), ye(i), 'g.')
    elseif classified(i) == 4
        plot (equis(i), ye(i), 'k.')
    end
end



res = k_nn_classifier(points, classified, 7, prueba);

if res == 1
    plot (pruebax, pruebay, 'ro')
elseif res == 2
    plot (pruebax, pruebay, 'bo')
elseif res == 3
    plot (pruebax, pruebay, 'go')
elseif res == 4
    plot (pruebax, pruebay, 'ko')
end
