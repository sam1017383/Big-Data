%path donde estan los archivos de radio
radio = 'C:\Users\Benjamin\Desktop\audio\radio_20h.wav';
promo = 'C:\Users\Benjamin\Desktop\audio\ads\tribunalelectoral.wav';

%Obtiene informacion del archivo .wav
inf = audioinfo(radio)
tasa_muestreo_radio = inf.SampleRate
total_muestras_radio = inf.TotalSamples

inf = audioinfo(promo)
tasa_muestreo = inf.SampleRate
total_muestras = inf.TotalSamples


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

paso_ventana = floor(ancho_ventana/2);

% calcula el numero total de ventanas a computar
num_ventanas = floor(((total_muestras_radio-ancho_ventana)/paso_ventana)); 

%Inicia el vector de comparaciones en cero
vector_comparaciones = zeros(num_ventanas, 1);


% ciclo principal que mide la similitud de cada ventana con el
% comercial
for fr = 0:num_ventanas
    %Calculo de indices de inicio y fin de la ventana 
    inicio = (fr*paso_ventana) + 1;
    fin = inicio + ancho_ventana - 1;
    
    %Lectura al archivo
    frame = audioread(radio, [inicio fin]);
    frame = frame(:,1);
    %calcula la remejanza del comercial con cada trozo de radio
    %como el maximo de la correlacion cruzada
    vector_comparaciones(fr+1, 1) = max(xcorr(frame(1:10:length(frame)), promocional(1:10:length(frame)), floor(ancho_ventana/6)));
    ['frame: ' int2str(fr) ' de ' int2str(num_ventanas)]
end

%Graficar y reproducir
figure(1)
plot(trozo_radio)
figure(2)
plot(vector_comparaciones)

