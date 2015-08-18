function vq = vq_from_wav(file,n)
    w = hamming(160)'; %Ventana que se aplica a cada frame
    audio_a = wavread(file)
    audio_a = truncate(audio_a);
    clear frames
    clear lpcframes
    numframes = floor(((length(audio_a)-160)/64));
    %itero en cada frame 
    for fr = 0:numframes
        %Calculo de indices de inicio y fin del 
        inicio = (fr*64) + 1;
        fin = inicio + 159;
        frame = audio_a(inicio:fin);
        %Ventaneo
        windowed = frame.*w;
        %Se obtienen los coeficientes LPC
        lpcframes(fr+1,:) = lpc(windowed, 7);
    end
    %Cuantizador vectorial
    vq = lbg(lpcframes, n);
    while (sum(vq(:,1)) < n)
        vq = lbg(lpcframes, n);
    end
    end