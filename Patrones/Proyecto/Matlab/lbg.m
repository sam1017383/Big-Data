function z = lbg(points, maxcodebooksize)
    %['inicio del algoritmo LBG --------------------------------------------------->']
    %%codebook vacio
    codebook = [];
    %Obtengo el centroide de todos los puntos y lo agrego al codebook
    centroide = mean(points);
    codebook = [codebook ; centroide];
    
    %Mientras el codebook no sea del tama�o deseado hago
    while (maxcodebooksize > length(codebook(:,1)))
        %%Por cada vector del codebook saco dos mas
        newcodebook = [];
        for i = 1:length(codebook(:,1))
            variation = codebook (i,:) + (rand*0.05*max(codebook(1,:)));
            %plot(variation(1), variation(2), '.r')
            newcodebook = [newcodebook ; variation];
            variation = codebook (i,:) - (rand*0.05*max(codebook(1,:)));
            %plot(variation(1), variation(2), '.r')
            newcodebook = [newcodebook ; variation]; 
        end
        codebook = newcodebook;
        
        %NUmero maximo de veces que intentar� estabilizar los centroides
        epsilon = 400;
        %%Centroides que se van a estabilizar
        error = 2;
        %%Con el nuevo codebook busco estabilizar los centroides para que no cambien
        while epsilon > 1 && error > 0.5
            epsilon = epsilon -1;
            %%Itero en cada punto, asocio el punto al vector de codebook mas
            %%cercano, una vez asociados todos promedio para sacar centroides
            class = zeros(length(points(:,1)),1);
            for p = 1: length(points(:,1))
                point = points(p,:);
                %saco la distancia al primer vector y luego busco otro mejor
                bestmin = 1;
                distmin = sqrt ( sum( (point - codebook(1,:)).^2 ) );
                for c = 2:length(codebook(:,1))
                    dis = sqrt ( sum( (point - codebook(c,:)).^2 ) );
                    if dis < distmin
                        distmin = dis;
                        bestmin = c;
                    end
                end
                
                %Clasifico al punto en con el centroide mas cercado
                class(p) = bestmin;
                
            end
            %%calculo de nuevos centroides
            centroids = zeros (length(codebook(:,1)), length(points(1,:)));
            acum = zeros (length(codebook(:,1)), 1);
            
            for p = 1: length(points(:,1))
                %%C es la clase del punto 
                c = class(p);
                centroids(c,:) = centroids(c,:) + points(p,:);
                %sumo 1 a los puntos que he acumulado
                acum(c) = acum(c) + 1;
            end
            %Hasta aqui centroids tiene la acumulacion de puntos de cada
            %clase ahora lo divido entre los puntos que acumule
            for c = 1:length(codebook(:,1))
                if acum(c) ~= 0
                    centroids(c,:) = centroids(c,:) / acum(c);
                else 
                    %si no hay ningun punto asignado al vector entonces
                    %vario otro centroide valido y prosigo
                    if c ~= 1
                        centroids(c,:) = codebook (c-1,:) + 0.1*rand(1,length(codebook(1,:)));
                    end
                end
                %plot(centroids(c,1), centroids(c,2), 'og')
            end
            %centroids
            %Obtengo un valor que indique que tanto cambiaron los
            %centroides repecto al codebook
            error = norm (codebook - centroids);
            %%Ahora son centroides son el nuevo codebook 
            codebook = centroids;
        end % END WHILE
        
    end
    
    z = codebook;