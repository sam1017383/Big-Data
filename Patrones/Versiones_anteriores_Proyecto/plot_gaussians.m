
x1 = -10:.5:10; x2 = -10:.5:10;
[X1,X2] = meshgrid(x1,x2);
%%%%%%%%%%%%%%%%%%% fig 2.3
mu = [0 0];
Sigma = [3 0; 0 3];
F1 = mvnpdf([X1(:) X2(:)],mu,Sigma);
F1 = reshape(F1,length(x2),length(x1));

%%%%%%%%%%%%%%%%%%% fig 2.4
mu = [0 0];
Sigma = [5 0; 0 .2];
F2 = mvnpdf([X1(:) X2(:)],mu,Sigma);
F2 = reshape(F2,length(x2),length(x1));

%%%%%%%%%%%%%%%%%%% fig 2.5
mu = [0 0];
Sigma = [.2 0; 0 3];
F3 = mvnpdf([X1(:) X2(:)],mu,Sigma);
F3 = reshape(F3,length(x2),length(x1));

%%%%%%%%%%%%%%%%%%% fig 2.6
mu = [0 0];
Sigma = [3 2; 2 3];
F4 = mvnpdf([X1(:) X2(:)],mu,Sigma);
F4 = reshape(F4,length(x2),length(x1));


figure (1)
surf(x1,x2,F1);
colormap (hot)
figure (2)
surf(x1,x2,F2);
colormap (bone)
figure (3)
surf(x1,x2,F3);
colormap (bone)
figure (4)
surfc(x1,x2,F4);
colormap (bone)
