function truncatedaudio = truncate(audio)
        audio = filter([1 -0.95], 1, audio);
        numframes = floor(((length(audio)-256)/128));
        frames = zeros(numframes, 256);
        frame = zeros(1, 256);
        framepot = zeros(1, numframes);
        k = 0;
        for n = 0:numframes
           inicio = (n * 128) + 1;
           fin = inicio + 255;
           iniciot = (k * 128) + 1;
           fint = iniciot + 255;
           frame = audio(inicio:fin);
           frames(n+1,:) = frame;
           framepot(n+1) = dot(frame, frame) / 128;
           if (framepot(n+1) > 0.00001) 
               truncatedaudio(iniciot:fint) = audio(inicio:fin);
               k = k + 1;
           end
        end