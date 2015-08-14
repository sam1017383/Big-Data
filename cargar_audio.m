%path donde estan los archivos de radio
radio = 'C:\Users\Benjamin\Desktop\audio\ejercicio.wav';

%Obtiene informacion del archivo .wav
inf = audioinfo(radio)
tasa_muestreo = inf.SampleRate
total_muestras = inf.TotalSamples

%Inicio y fin de la lectura del archivo, dado en muestras
inicio = 100000;
%20 segundos a 44,100 muestras por segundo
fin = inicio + 44100*20;

%Lectura del archivo
[trozo_radio fm] = audioread(radio, [inicio fin]);

%Graficar y reproducir
plot(trozo_radio)
sound(trozo_radio, fm)
