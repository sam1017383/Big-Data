%path donde estan los archivos de radio
radio = 'C:\Users\Benjamin\Desktop\audio\promo.wav';

%Obtiene informacion del archivo .wav
inf = audioinfo(radio)
tasa_muestreo = inf.SampleRate
total_muestras = inf.TotalSamples

%Inicio y fin de la lectura del archivo, dado en muestras
inicio = 100000;
%20 segundos a 44,100 muestras por segundo
fin = inicio + 100;

%Lectura del archivo
[trozo_radio fm] = audioread(radio, [inicio fin]);


%Graficar fragmento original 
figure(1)
plot(trozo_radio)


%Graficar fragmento un canal
figure(2)
trozo_radio = trozo_radio(:,1);
plot(trozo_radio)


%Graficar componentes espectrales
figure(3)
espectro = abs(fft(trozo_radio));
plot(espectro)

figure(4)
auto_corr = xcorr(trozo_radio, trozo_radio);
plot(auto_corr)

ruido = rand(100,1);
figure(5)
auto_corr_ruido = xcorr(ruido, ruido);
plot(auto_corr_ruido)

