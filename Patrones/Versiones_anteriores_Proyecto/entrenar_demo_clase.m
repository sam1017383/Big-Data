Fs=16000;

centroides=64;
codebook=zeros(centroides,13,2);
path='C:\Users\biorrobotica\Documents\JOSE\Speakerecog\trunk-jose\';

at=[];
corrt=[];
audio = wavread('entrenamiento_jose.wav');
audio=truncar(audio);        
wavplay(audio, 16000);
[corr a]=ventana2(audio,64,160);
at=cat(1,at,a);
corrt=cat(1,corrt,corr);
disp(size(a));
codebook(:,:,1)=QuantVec(at,corrt,centroides);

at=[];
corrt=[];
audio = wavread('entrenamiento_samuel.wav');
audio=truncar(audio);        
wavplay(audio, 16000);
[corr a]=ventana2(audio,64,160);
at=cat(1,at,a);
corrt=cat(1,corrt,corr);
disp(size(a));
codebook(:,:,2)=QuantVec(at,corrt,centroides);

fwriteid = fopen('samueljose.bin','w');
count = fwrite(fwriteid,codebook,'double');
status = fclose(fwriteid);
