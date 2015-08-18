
%Limpia el ambiente del interprete
clear;
close all;
%Constantes
Fs = 16000; %Frecuencia de muestreo
%Paths donde se guardaron las señales originales y se escriben las truncadas
pathread = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\Patrones\Proyecto\';
pathwrite = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\Patrones\Proyecto\';

%Iterea para las 10 señales de entrenamiento de cada digito 
for i = 1:1
    for j = 1:1
        enable = 1;
        wavname = ['s' '.wav'];
        audio= wavread([pathread wavname]);
        audiofiltered = filter([1 -0.95], 1, audio);
        numframes = floor(((length(audio)-256)/128));
        clear audiotrunc;
        clear buffer;
        frames = zeros(numframes, 256);
        frame = zeros(1, 256);
        framepot = zeros(1, numframes);
        k = 0;
        kb = 0;
        timesmissed = 0;
        for n = 0:numframes
           inicio = (n * 128) + 1;
           fin = inicio + 255;
           iniciot = (k * 128) + 1;
           fint = iniciot + 255;
           frame = audiofiltered(inicio:fin);
           frames(n+1,:) = frame;
           framepot(n+1) = dot(frame, frame) / 256;
           
           if (framepot(n+1) > 0.00005) && (enable == 1)
               if k == 1
                   kb = 1;
               end 
               frameinicio = n+1;
               audiotrunc(iniciot:fint) = audiofiltered(inicio:fin);
               k = k + 1;
               %No acumulo fallos de captura
               timesmissed = 0;
           else
                if (kb == 1) && (enable == 1)
                    %si kb = 1 ya empezo la captura
                    %fallo en capturar una vezz mas
                    timesmissed = timesmissed + 1;
                    if timesmissed < 8
                        %si no ha fallado 5 veces seguidas, lo perdono y
                        %capturo
                        audiotrunc(iniciot:fint) = audiofiltered(inicio:fin);
                        k = k + 1;
                    else 
                        % si ya fallo 5 veces seguidas evito que capture y
                        % borro las ultimas 5 frames
                        enable =0;
                        audiotrunc = audiotrunc(1: length(audiotrunc)-2*256);
                    end 
                    
                end
           end
        end
        figure (1)
        plot(1:length(audiofiltered), audiofiltered);
        figure (2)
        plot(1:length(audiotrunc), audiotrunc);
        figure (3)
        plot(1:length(framepot), framepot);
        
        wavname = ['s' '_truncated.wav'];
        wavwrite(audiotrunc,Fs,[pathwrite wavname]);
    end
end 