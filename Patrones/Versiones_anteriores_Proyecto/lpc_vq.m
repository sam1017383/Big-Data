
%Limpia el ambiente del interprete
clear;
close all;
%Constantes
Fs = 16000; %Frecuencia de muestreo
w = hamming(160); %Ventana que se aplica a cada frame
%Paths donde se guardaron las señales truncadas y se escriben los
%resultados
pathread = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\Patrones\Proyecto\';
pathwrite = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\Patrones\Proyecto\';
%Iterea para las 10 señales de entrenamiento de cada digito si i = 1:10 y j = 1:10 
for i = 9:9
    for j = 9:9
        clear frames
        clear lpcframes
        %se concatena el nombre del archivo de audio a leer, se carga 
        wavname = ['s'  '_truncated.wav'];
        audio= wavread([pathread wavname]);
        %calculo del numero de frames que se necesitan
        numframes = floor(((length(audio)-160)/64));
        %itero en cada frame 
        for fr = 0:numframes
           %Calculo de indices de inicio y fin del 
           inicio = (fr*64) + 1;
           fin = inicio + 159;
           frame = audio(inicio:fin);
           %Ventaneo
           windowed = frame.*w;
           %Division de la señal en frames
           frames(fr+1,:) = windowed;
           %Se obtienen los coeficientes LPC
           lpcframes(fr+1,:) = lpc(windowed, 12);
        end
        %Cuantizador vectorial
        vq = lbg(lpcframes, 16);
        %Guarda los LPC en archivo de texto
        txtname = [ 's' '_LPCcoefs.txt'];
        file = fopen([pathwrite txtname],'w');
        for row = 1:16
            fprintf(file,'%f %f %f %f %f %f %f %f %f %f %f %f %f \n',vq(row,:));
        end
        fclose(file);
        %Obtiene la correlacion corta de los coeficientes LPC
        ra = zeros(16,13);
        for row = 1:16
            for coef = 1:13
                limit = 13 - coef + 1;
                for k = 1:limit 
                    offset = coef + k -1;
                    ra(row, coef) = ra(row, coef) + vq(row,k) * vq(row, offset);
                end
            end
        end
        %Guarda la correlacion de los LPC en archivo de texto
        txtname = ['s' '_LPCautocorr.txt'];
        file = fopen([pathwrite txtname],'w');
        for row = 1:16
            fprintf(file,'%f %f %f %f %f %f %f %f %f %f %f %f %f \n',ra(row,:));
        end
        fclose(file);
    end
end 