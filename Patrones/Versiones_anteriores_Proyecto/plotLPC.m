%lee los LPC en archivo de texto
pathread = 'C:\Users\Samuel\Dropbox\MAESTRIA\2013-II\Patrones\Proyecto\';
txtname = ['a' '_LPCcoefs.txt'];
file = fopen([pathread txtname]);
C = textscan(file, '%f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(file);
%Transformo de cellarray a array normal
ra = [C{1:1, 1:1} , C{1:1, 2:2} ,C{1:1, 3:3} ,C{1:1, 4:4} ,C{1:1, 5:5} ,C{1:1, 6:6} ,C{1:1, 7:7} ,C{1:1, 8:8} ,C{1:1, 9:9} ,C{1:1, 10:10} ,C{1:1, 11:11} ,C{1:1, 12:12} ,C{1:1, 13:13}];
figure (1)
subplot(4,1,1), plot(1:13, ra(1,:));

txtname = ['p' '_LPCcoefs.txt'];
file = fopen([pathread txtname]);
C = textscan(file, '%f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(file);
%Transformo de cellarray a array normal
rp = [C{1:1, 1:1} , C{1:1, 2:2} ,C{1:1, 3:3} ,C{1:1, 4:4} ,C{1:1, 5:5} ,C{1:1, 6:6} ,C{1:1, 7:7} ,C{1:1, 8:8} ,C{1:1, 9:9} ,C{1:1, 10:10} ,C{1:1, 11:11} ,C{1:1, 12:12} ,C{1:1, 13:13}];
%figure (2)
subplot(4,1,2),plot(1:13, rp(2,:));

txtname = ['s' '_LPCcoefs.txt'];
file = fopen([pathread txtname]);
C = textscan(file, '%f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(file);
%Transformo de cellarray a array normal
rs = [C{1:1, 1:1} , C{1:1, 2:2} ,C{1:1, 3:3} ,C{1:1, 4:4} ,C{1:1, 5:5} ,C{1:1, 6:6} ,C{1:1, 7:7} ,C{1:1, 8:8} ,C{1:1, 9:9} ,C{1:1, 10:10} ,C{1:1, 11:11} ,C{1:1, 12:12} ,C{1:1, 13:13}];
%figure (3)
subplot(4,1,3),plot(1:13, rs(3,:));
txtname = ['o' '_LPCcoefs.txt'];
file = fopen([pathread txtname]);
C = textscan(file, '%f %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(file);
%Transformo de cellarray a array normal
ro = [C{1:1, 1:1} , C{1:1, 2:2} ,C{1:1, 3:3} ,C{1:1, 4:4} ,C{1:1, 5:5} ,C{1:1, 6:6} ,C{1:1, 7:7} ,C{1:1, 8:8} ,C{1:1, 9:9} ,C{1:1, 10:10} ,C{1:1, 11:11} ,C{1:1, 12:12} ,C{1:1, 13:13}];
subplot(4,1,4),plot(1:13, ro(4,:));
