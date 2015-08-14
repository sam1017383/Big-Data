%path donde estan los archivos de radio
radio = 'C:\Users\Benjamin\Desktop\audio\ejercicio_silencios.wav';
promo = 'C:\Users\Benjamin\Desktop\audio\promo.wav';

%Obtiene informacion del archivo .wav
inf = audioinfo(radio)
tasa_muestreo_radio = inf.SampleRate
total_muestras_radio = inf.TotalSamples

inf = audioinfo(promo)
tasa_muestreo = inf.SampleRate
total_muestras_promocional = inf.TotalSamples


%Inicio y fin de la lectura del archivo, dado en muestras
inicio = 100000;
%20 segundos a 44,100 muestras por segundo
fin = inicio + 100000;

%Lectura del archivo
[trozo_radio fm] = audioread(radio, [inicio fin]);
[promocional fm] = audioread(promo);

%Separamos un canal
trozo_radio = trozo_radio(:,1);
promocional = promocional(:,1);

%Ventana de comparacion del tamano del anuncio a detectar
ancho_ventana = length(promocional);

paso_ventana = floor(ancho_ventana/4);

% calcula el numero total de ventanas a computar
num_ventanas = floor(((total_muestras_radio-ancho_ventana)/paso_ventana)); 

%Inicia el vector de comparaciones en cero
vector_comparaciones = zeros(num_ventanas, 1);


% ciclo principal que mide la similitud de cada ventana con el
% comercial
submuestreo = 50;
for fr = 0:num_ventanas
    %Calculo de indices de inicio y fin de la ventana 
    inicio = (fr*paso_ventana) + 1;
    fin = inicio + ancho_ventana - 1;
    
    %Lectura al archivo
    frame = audioread(radio, [inicio fin]);
    frame = frame(:,1);
    %calcula la remejanza del comercial con cada trozo de radio
    %como el maximo de la correlacion cruzada
    vector_comparaciones(fr+1, 1) = max(xcorr(frame(1:submuestreo:length(frame)), promocional(1:submuestreo:length(frame)), floor(ancho_ventana/6)));
    ['frame: ' int2str(fr) ' de ' int2str(num_ventanas)]
end

 % promedio del vector de similitud
 media = mean(vector_comparaciones);

figure(2)
hold all
plot(vector_comparaciones)
plot(ones(length(vector_comparaciones),1)*4*media)

detecciones = [];
%limpiar picos
average = mean(vector_comparaciones);
for i=1:length(vector_comparaciones)
    if vector_comparaciones(i) < 4*media 
        vector_comparaciones(i) = 0;
    end
end

steps_forward = floor(total_muestras_promocional/ paso_ventana);


slope_previous = 0;
ignore = 0;
    % para detectar los picos se sigue la pendiente hasta que cambia de
    % positiva a negativa, cuando eso pasa se registra el punto y se avanza
    % en el analisis para que el mismo pico no de multiples apariciones
    % exitosas
for i=1:length(vector_comparaciones)-1
    if ignore == 0
        slope_current = vector_comparaciones(i+1) - vector_comparaciones(i);
        if (slope_current < 0) && (slope_previous > 0)
            seconds_detected = (i-1)*(paso_ventana/tasa_muestreo);
            seconds = mod(seconds_detected, 60);
            min = floor(mod(seconds_detected, 3600)/60);
            hrs = floor(seconds_detected/3600);
            detecciones = [detecciones ; [hrs, min, seconds]];
            ignore = steps_forward;
        end
        slope_previous = slope_current;
    else
        ignore = ignore -1;
    end
end
detecciones

report_name = ['C:\Users\Benjamin\Desktop\audio\resultados.txt'];
fID = fopen(report_name, 'a+');
%fprintf(fID, '%s', ['Radio: ' radio '\n']);
%fprintf(fID, '%s', [' Promocional: ' promo '\n']);
[n m] = size(detecciones)
    
for d = 1:n
    fprintf(fID, ' hora: %d   minuto: %d   segundo: %d  \n', floor(detecciones(d,1)), floor(detecciones(d,2)), floor(detecciones(d,3)) );
end

    
    
    
%Graficar y reproducir
figure(1)
plot(trozo_radio)




