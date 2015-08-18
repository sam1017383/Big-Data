%%%%%%%%%%%%%%%%%%%RECONOCIMIENTO DE VOZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%Y LENGUAJE NATURAL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%PRACTICA 2%%%Samuel Salvador Vazquez Sanchez%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%Distancia de Itakura Saito %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Este codigo necesita los archivos de texto donde se guardaron los%%%%%%%%
%%coeficientes LPC y la autocorrelacion de dichos coeficientes%%%%%%%%%%%%%
%%Lee el audio de entrada, lo divide en bloques de 160 cada 64 muestras,%%%
%%Obtiene la autocorrelacion del frame y calcula la distancia de Itakura%%%
%%Saito para determinar a que entrenamiento es mas parecido%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Constantes
pathread = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\voz\practica2\Matlab\EntrenamientosTruncados\';
pathreadtxt = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\voz\practica2\Matlab\textResults\';
w = hamming(160);
%Iterea para las 5 señales de entrenamiento de cada digito, empiezan en
%j=11

for i = 1:10
    for j = 11:15
        clear frames
        clear lpcframes
        %se concatena el nombre del archivo de audio a leer, se carga 
        wavname = [int2str(i) '_' int2str(j) '_truncated.wav'];
        audio= wavread([pathread wavname]);
        wavplay(audio, 16000);
        %calculo del numero de frames que se necesitan
        numframes = floor(((length(audio)-160)/64));
        %acumulador de distancia contra los 100 entrenamientos de cada
        %frame
        distances = ones(100, numframes);
        %itero en cada frame 
        for fr = 0:numframes
            %Calculo de indices de inicio y fin del 
            inicio = (fr*64) + 1;
            fin = inicio + 159;
            frame = audio(inicio:fin);
            %Ventaneo
            windowed = frame.*w;
            %Division de la señal en frames
            
            %Autocorrelacion de 12 elementos
            acorr = autocorr(windowed, 12);
            
            
            %mido Itakura Saito para las 100 señales
            for d = 1:10
                for e = 1:10
                    %lee correlacion de los LPC en archivo de texto
                    txtname = [int2str(d) '_' int2str(e) '_LPCautocorr.txt'];
                    file = fopen([pathreadtxt txtname]);
                    C = textscan(file, '%f %f %f %f %f %f %f %f %f %f %f %f %f');
                    fclose(file);
                    %Transformo de cellarray a array normal
                    ra = [C{1:1, 1:1} , C{1:1, 2:2} ,C{1:1, 3:3} ,C{1:1, 4:4} ,C{1:1, 5:5} ,C{1:1, 6:6} ,C{1:1, 7:7} ,C{1:1, 8:8} ,C{1:1, 9:9} ,C{1:1, 10:10} ,C{1:1, 11:11} ,C{1:1, 12:12} ,C{1:1, 13:13}];
                    %asumo que la distancia minima es con el primer vector
                    %(solo para iniciarlo en algun valor valido)
                    dISmin = ra(1,1)* acorr(1) + 2 * dot(acorr(2:length(acorr)) , ra(1, 2:length(ra(1,:))));
                    %itero en los 16 vectores caracteristicos de la palabra
                    for m = 2:16
                        dIS = ra(m,1)* acorr(1) + 2 * dot(acorr(2:length(acorr)) , ra(m, 2:length(ra(1,:))));
                        
                        if dIS < dISmin
                            dISmin = dIS;
                        end
                    end
                    %Hasta aqui dISmin es la distancia minima del frame
                    %actual a algun vector del entrenamiento d_e_truncado
                    %Forma de acomodar entrnamientos linealmente
                    trainingdir = (d-1)*10 + e;
                    distances (trainingdir, fr+1) = dISmin;
                end
            end
        end%end frame
        dISacum = zeros(100,1);
        %calculo las distancias minimas acumuladas de la señal de entrada
        %hacia cada uno de los entrenamientos, los diez primeros son los
        %entrenamientos de 'uno', los siguientes diez son entrenamientos de
        %'dos', etc
        for acc = 1:100
            dISacum(acc) = sum(distances (acc,:) ); 
        end
        
        for acc = 1:10
            inicio = (acc -1)*10 + 1;
            fin = inicio + 9;
            dISblock(acc) = sum(dISacum(floor(inicio):floor(fin)));
        end
        %calculo donde esta la distancia mínima al bloque de entrenamiento
        [mindistance, index] = min (dISacum);
        hip = floor(index/10) + 1;
        
        [mindistance2, index2] = min (dISblock);
        %['el archivo ' wavname ' suena a que es un ' int2str(hip)]
        
        ['--otro metodo--- el archivo ' wavname ' suena a que es un ' int2str(index2)]
        
    end
end






