%%%%%%%%%%%%%%%%%Cuantizador vectorial generico%%%%%%%%%%%%%%
%%%%%%Usa el algoritmo Linde, Buzo, Gray%%%%%%%%%%%%%%%%%%%
function z = VQ_LBG(points, maxcodebooksize)
    %%codebook vacio
    codebook = [];
    %Obtengo el centroide de todos los puntos y lo agrego al codebook
    centroide = mean(points);
    codebook = [codebook ; centroide];
    codebook
    %Mientras el codebook no sea del tama�o deseado hago
    while (maxcodebooksize > length(codebook(:,1)))

        %%Por cada vector del codebook saco dos mas
        newcodebook = [];
        for i = 1:length(codebook(:,1))
            variation = codebook (i,:) + (rand*0.1*max(codebook(1,:)));
            newcodebook = [newcodebook ; variation];
            variation = codebook (i,:) - (rand*0.1*max(codebook(1,:)));
            newcodebook = [newcodebook ; variation]; 
        end
        epsilon = 10;

        %%Con el nuevo codebook busco estabilizar los centroides para que no cambien
        while epsilon > 1
            epsilon = epsilon -1;

            %%Itero en cada punto, asocio el punto al vector de codebook mas
            %%cercano, una vez asociados todos promedio para sacar centroides
            centroidsX = zeros(length(codebook(:,1)),2);
            centroidsY = zeros(length(codebook(:,1)),2);
            for p = 1: length(points(:,1))
                point = points(p,:);
                %saco la distancia al primer vector y luego busco otro mejor
                bestmin = 1;
                distmin = sqrt ( (point(1)-codebook(1,1))^2 + (point(2)-codebook(1,2))^2);
                for c = 2:length(codebook(:,1))
                    dis = sqrt ( (point(1)-codebook(c,1))^2 + (point(2)-codebook(c,2))^2);
                    if dis < distmin
                        distmin = dis;
                        best = c;
                    end
                end
                %%hasta aqui c me dice a que vector esta mas cerca
                %%ahora sumo ese punto a un acumulador para despues sacar
                %%centroides centroideX(equisacumuladas, numacumulados)
                centroidsX(c,1) = centroidesX(c,1) + point(1);
                centroidsX(c,2) = centroidesX(c,2) + 1;

                centroidsY(c,1) = centroidesY(c,1) + point(2);
                centroidsY(c,2) = centroidesY(c,2) + 1;
            end
        end

        codebook = newcodebook;
        codebook
    end
    z = 0;
