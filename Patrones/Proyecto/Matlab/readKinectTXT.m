fileID = fopen('C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\Patrones\Proyecto\22 abril\m.txt');


A = fscanf(fileID, '%i');

audio = A ./ max(A);
x= 1:length(A);
player = audioplayer(audio, 16000);
play(player)
plot(x, audio);