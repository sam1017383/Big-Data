function feat = feat_from_lpc(vq, nCentroids)
    %Acondicionar features sobre los LPC 
    %traspuesto
    vq = vq';
    %features: pendientes entre componentes 4,5,6 y 7 componente de la fft
    feat = zeros(3,nCentroids);
    %fft de cada vector de LPCs
    fftx = zeros(8,nCentroids);
    for i = 1:nCentroids
        fftx(:,i) = abs(fft(vq(:,i)));
    end
    %Primer feature componente de directa
    for i = 1:nCentroids
        %feat(1,i) = fftx(6,i)/sum(fftx(:,i));
        feat(1,i) = (fftx(5,i)-fftx(6,i))/(fftx(5,i)+fftx(6,i));
    end
    %Segundo feature
    for i = 1:nCentroids
        %feat(2,i) = fftx(7,i)/sum(fftx(:,i));
        feat(2,i) = (fftx(6,i)-fftx(7,i))/(fftx(6,i)+fftx(7,i));

    end
    
    for i = 1:nCentroids
        %feat(3,i) = fftx(8,i)/sum(fftx(:,i));
        feat(3,i) = (fftx(7,i)-fftx(8,i))/(fftx(7,i)+fftx(8,i));
    end
end