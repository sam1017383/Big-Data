%%%%%%%%%%%%%%%%%%%RECONOCIMIENTO DE VOZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%Y LENGUAJE NATURAL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%PRACTICA 2%%%Samuel Salvador Vazquez Sanchez%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%Truncado de las señales%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Limpia el ambiente del interprete
clear;
close all;
%Constantes
Fs = 16000; %Frecuencia de muestreo
%Paths donde se guardaron las señales originales y se escriben las truncadas
pathread = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\voz\practica2\Matlab\Entrenamientos\';
pathwrite = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\voz\practica2\Matlab\EntrenamientosTruncados\';

%Iterea para las 10 señales de entrenamiento de cada digito 
for i = 1:10
    for j = 12:15
        enable = 1;
        wavname = [int2str(i) '_' int2str(j) '.wav'];
        audio= wavread([pathread wavname]);
        audiofiltered = filter([1 -0.95], 1, audio);
        numframes = floor(((length(audio)-512)/256));
        clear audiotrunc;
        clear buffer;
        frames = zeros(numframes, 512);
        frame = zeros(1, 512);
        framepot = zeros(1, numframes);
        k = 0;
        kb = 0;
        timesmissed = 0;
        for n = 0:numframes
           inicio = (n * 256) + 1;
           fin = inicio + 511;
           iniciot = (k * 256) + 1;
           fint = iniciot + 511;
           frame = audiofiltered(inicio:fin);
           frames(n+1,:) = frame;
           framepot(n+1) = dot(frame, frame) / 512;
           
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
                        audiotrunc = audiotrunc(1: length(audiotrunc)-2*512);
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
        
        wavname = [int2str(i) '_' int2str(j) '_truncated.wav'];
        wavwrite(audiotrunc,Fs,[pathwrite wavname]);
    end
end 
