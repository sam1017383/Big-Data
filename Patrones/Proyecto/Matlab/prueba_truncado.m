close all
audio_a = wavread('training_Ms');
audio_a = truncate(audio_a);
sound(audio_a, 16000)


figure (3)
plot(1:length(audio_a), audio_a)