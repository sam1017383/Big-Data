%%%%%%%%%%%%%%%%%%%RECONOCIMIENTO DE VOZ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%Y LENGUAJE NATURAL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%PRACTICA 2%%%Samuel Salvador Vazquez Sanchez%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%Coeficientes LPC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Este codigo requiere leer los archivos de audio truncados y la funcion%%%
%%para calcular los centroides usando cuantizacion vectorial por LBG%%%%%%%
%%Se lee los archivos de audio truncados y los divide en frames, obtiene%%%
%%los coeficientes LPC de cada frames, calcula 16 vectores representativos%
%%entre todos los vectories de LPC de todos los frames usando la funcion%%%
%%personalmente implementada del cuantizador vectorial LBG, calcula la%%%%%
%%autocorrelacion corta de los 16 vectres del codebook. Los resultados del%
%%Cuantizador y su autocorrelacion se guardan en un archivo de texto para
%%su posterior uso.

%Limpia el ambiente del interprete
clear;
close all;
%Constantes
Fs = 16000; %Frecuencia de muestreo
w = hamming(160); %Ventana que se aplica a cada frame
%Paths donde se guardaron las señales truncadas y se escriben los
%resultados
pathread = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\voz\practica2\Matlab\EntrenamientosTruncados\';
pathwrite = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\voz\practica2\Matlab\textResults\';

%Carga señales en .txt
fileID = fopen('C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\Patrones\Proyecto\22 abril\n.txt');
A = fscanf(fileID, '%i');
audio = A ./ max(A);
audio = audio(1:15000)
x= 1:15000;
player = audioplayer(audio, 16000);
play(player)


        clear frames
        clear lpcframes
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
           lpcframes(fr+1,:) = lpc(windowed, 7);
        end
        %Cuantizador vectorial
        vq = lbg(lpcframes, 4)
        
        %graficacion
equis = 1:8;
close all

figure1 = figure (1);
plot(equis,vq(1,:),'LineWidth',4);
axis([1 8 -7 7]);

figure2 = figure (2);
plot(equis,vq(2,:), 'LineWidth',4);
axis([1 8 -7 7]);

figure3 = figure (3);
plot(equis,vq(3,:), 'LineWidth',4);
axis([1 8 -7 7]);

figure4 = figure (4);
plot(equis,vq(4,:), 'LineWidth',4);
axis([1 8 -7 7]);

% guarda como jpg
saveas(figure1, 'plot_n1.jpg');
saveas(figure2, 'plot_n2.jpg');
saveas(figure3, 'plot_n3.jpg');
saveas(figure4, 'plot_n4.jpg');

close all;

figure(5)
plot(x, audio);

