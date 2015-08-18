%Limpia el ambiente del interprete
clear;
clc;
close all;
%Constantes
Fs = 16000; %Frecuencia de muestreo
%numero de centroides por entrenamiento
nCentroids = 64;
fprintf('calculando y clusterizando vectores LPC grabaciones de entrenamiento... \n');
%siempre es 8 LPCs
vq_a = vq_from_wav('train_A', nCentroids, false);
vq_i = vq_from_wav('train_I', nCentroids, false);
vq_u = vq_from_wav('train_U', nCentroids, false);
vq_e = vq_from_wav('train_E', nCentroids, false);
vq_o = vq_from_wav('train_O', nCentroids, false);

vq_s = vq_from_wav('train_S', nCentroids, false);
vq_m = vq_from_wav('train_M', nCentroids, false);

fprintf('obteniendo features de grabaciones de entrenamiento... \n');
feat_a = feat_from_lpc(vq_a,nCentroids);
feat_e = feat_from_lpc(vq_e,nCentroids);
feat_i = feat_from_lpc(vq_i,nCentroids);
feat_o = feat_from_lpc(vq_o,nCentroids);
feat_u = feat_from_lpc(vq_u,nCentroids);

feat_m = feat_from_lpc(vq_m,nCentroids);
feat_s = feat_from_lpc(vq_s,nCentroids);

%:::::::Clasificador bayesiano::::::::
fprintf('ensamblando casificador bayesiano... \n');
%AAAAAAAAAAAAAAAAAA
cov_a = cov(feat_a');
mean_a = mean(feat_a');

%UUUUUUUUUUUUUUUUUU
cov_u = cov(feat_u');
mean_u = mean(feat_u');

%SSSSSSSSSSSSSSSSSS
cov_s = cov(feat_s');
mean_s = mean(feat_s');

%MMMMMMMMMMMMMMMMMM
cov_m = cov(feat_m');
mean_m = mean(feat_m');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%CLASIFICADORES LINEALES POR PARES %%%%%%%%%%%%%%%%%%%
fprintf('clasificadores lineales por pares... \n');
w_ini = [ 1 1 1 1 ]';

%::::::::::perceptron para consonantes::::::::::
y_cons = [-ones(1,nCentroids) ones(1,nCentroids)];
X_t_cons = [feat_s feat_m];
X_t_cons(4,:) = 1;
w_perce_cons = perce(X_t_cons, y_cons, w_ini);

%::::::::::perceptron para vocales::::::::::::::
y_vocs = [-ones(1,nCentroids) ones(1,nCentroids)];
X_t_vocs = [feat_a feat_u];
X_t_vocs(4,:) = 1;
w_perce_vocs = perce(X_t_vocs, y_vocs, w_ini);



%::::::::::suma de errores para consonantes::::::::::
y_cons = [-ones(1,nCentroids) ones(1,nCentroids)];
X_t_cons = [feat_s feat_m];
X_t_cons(4,:) = 1;
w_sumerrors_cons = sum_of_errors(X_t_cons, y_cons);

%::::::::::suma de errores para vocales::::::::::::::
y_vocs = [-ones(1,nCentroids) ones(1,nCentroids)];
X_t_vocs = [feat_a feat_u];
X_t_vocs(4,:) = 1;
w_sumerrors_vocs = sum_of_errors(X_t_vocs, y_vocs);


w_ini = [1 2 2 0]';

%::::::::::LMS para consonantes::::::::::
y_cons = [-ones(1,nCentroids) ones(1,nCentroids)];
X_t_cons = [feat_s feat_m];
X_t_cons(4,:) = 1;
w_lms_cons = lms(X_t_cons, y_cons, w_ini);


w_ini = [-.5 -.5 0.5 0]';

%::::::::::LMS para vocales::::::::::::::
y_vocs = [-ones(1,nCentroids) ones(1,nCentroids)];
X_t_vocs = [feat_a feat_u];
X_t_vocs(4,:) = 1;
w_lms_vocs = lms(X_t_vocs, y_vocs, w_ini);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%CLASIFICADORES LINEALES UNO VS TODOS%%%%%%%%%%%%%%%%%
fprintf('clasificador con perceptron uno contra todos... \n');
w_ini = [ 1 1 1 1 ]';

%::::::::::perceptron para a::::::::::
y_a = [-ones(1,3*nCentroids) ones(1,nCentroids)];
X_t_a = [feat_s feat_m feat_u feat_a];
X_t_a(4,:) = 1;
w_perce_a = perce(X_t_a, y_a, w_ini);

%::::::::::perceptron para u::::::::::
y_u = [-ones(1,3*nCentroids) ones(1,nCentroids)];
X_t_u = [feat_s feat_m feat_a feat_u];
X_t_u(4,:) = 1;
w_perce_u = perce(X_t_u, y_u, w_ini);

%::::::::::perceptron para s::::::::::
y_s = [-ones(1,3*nCentroids) ones(1,nCentroids)];
X_t_s = [feat_a feat_m feat_u feat_s];
X_t_s(4,:) = 1;
w_perce_s = perce(X_t_s, y_s, w_ini);

%::::::::::perceptron para m::::::::::
y_m = [-ones(1,3*nCentroids) ones(1,nCentroids)];
X_t_m = [feat_s feat_a feat_u feat_m];
X_t_m(4,:) = 1;
w_perce_m = perce(X_t_m, y_m, w_ini);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%::::::::::::::Red neuronal multicapa:::::::::::::
fprintf('clasificador con red neuronal multicapa... \n');
P = [feat_a(1:3,:) feat_u(1:3,:) feat_s(1:3,:) feat_m(1:3,:)];
target_a = zeros(4,nCentroids);
target_u = zeros(4,nCentroids);
target_s = zeros(4,nCentroids);
target_m = zeros(4,nCentroids);
for i=1:nCentroids
    target_a(:,i) = [1 ; 0 ; 0 ; 0];
    target_u(:,i) = [0 ; 1 ; 0 ; 0];
    target_s(:,i) = [0 ; 0 ; 1 ; 0];
    target_m(:,i) = [0 ; 0 ; 0 ; 1];
end
T = [target_a target_u target_s target_m];
net = newff(P,T, [10 10]); 
net.trainParam.epochs = 50;
net = train(net,P,T);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Clustering
%Cuantizacion vectorial
points_lbg = [feat_a' ; feat_u' ; feat_s' ; feat_m'];
vq_fon_lbg = lbg2(points_lbg, 4)';

%BSAS
order = zeros(1,4*nCentroids);
for i=1:nCentroids
    j= (i-1)*4 +1;
    order(j) = i;
    order(j+1) = i+64;
    order(j+2) = i+128;
    order(j+3) = i+64+128;
end


points_bsas = [feat_a feat_u feat_s feat_m];
[bel, vq_fon_bsas] = BSAS(points_bsas, 0.23, 4, []); %%reordenados .19 ok










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%:::::::::captura de seï¿½ales de prueba:::::::::
%nombre de archivos de prueba
t_a = 'test_A';
t_u = 'test_U';
t_m = 'test_M';
t_s = 'test_S';

nCentroids_test = 16;

%AAAAAAAAAAAAAA
vq_test_a = vq_from_wav(t_a, nCentroids_test, false);
feat_test_a = feat_from_lpc(vq_test_a,nCentroids_test);
feat_test_a(4,:) = 1;

%UUUUUUUUUUUUUU
vq_test_u = vq_from_wav(t_u, nCentroids_test, false);
feat_test_u = feat_from_lpc(vq_test_u,nCentroids_test);
feat_test_u(4,:) = 1;

%SSSSSSSSSSSSSSS
vq_test_s = vq_from_wav(t_s, nCentroids_test, false);
feat_test_s = feat_from_lpc(vq_test_s,nCentroids_test);
feat_test_s(4,:) = 1;

%MMMMMMMMMMMMMMM
vq_test_m = vq_from_wav(t_m, nCentroids_test, false);
feat_test_m = feat_from_lpc(vq_test_m,nCentroids_test);
feat_test_m(4,:) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%evaluacion de la clasificacion
fprintf(' \n \n')
fprintf('::::::::evaluando con bayes:::::::: \n')
bayes_a = feat_test_a(1:3,:);
misclasify_bayes_a = 0;
for i=1:nCentroids_test
    eval_bayes_a(1) = gaussian_eval(mean_a', cov_a, bayes_a(:,i));
    eval_bayes_a(2) = gaussian_eval(mean_u', cov_u, bayes_a(:,i));
    [C inx_a] = max(eval_bayes_a);
    if inx_a ~= 1
        misclasify_bayes_a = misclasify_bayes_a + 1;
    end
end

bayes_u = feat_test_u(1:3,:);
misclasify_bayes_u = 0;
for i=1:nCentroids_test
    eval_bayes_u(1) = gaussian_eval(mean_a', cov_a, bayes_u(:,i));
    eval_bayes_u(2) = gaussian_eval(mean_u', cov_u, bayes_u(:,i));
    [C inx_u] = max(eval_bayes_u);
    if inx_u ~= 2
        misclasify_bayes_u = misclasify_bayes_u + 1;
    end
end

bayes_s = feat_test_s(1:3,:);
misclasify_bayes_s = 0;
for i=1:nCentroids_test
    eval_bayes_s(1) = gaussian_eval(mean_s', cov_s, bayes_s(:,i));
    eval_bayes_s(2) = gaussian_eval(mean_m', cov_m, bayes_s(:,i));
    [C inx_s] = max(eval_bayes_s);
    if inx_s ~= 1
        misclasify_bayes_s = misclasify_bayes_s + 1;
    end
end

bayes_m = feat_test_m(1:3,:);
misclasify_bayes_m = 0;
for i=1:nCentroids_test
    eval_bayes_m(1) = gaussian_eval(mean_s', cov_s, bayes_m(:,i));
    eval_bayes_m(2) = gaussian_eval(mean_m', cov_m, bayes_m(:,i));
    [C inx_m] = max(eval_bayes_m);
    if inx_m ~= 2
        misclasify_bayes_m = misclasify_bayes_m + 1;
    end
end
stats_bayes = zeros(4,1);
stats_bayes(1) = misclasify_bayes_a/nCentroids_test *100;
stats_bayes(2) = misclasify_bayes_u/nCentroids_test *100;
stats_bayes(3) = misclasify_bayes_s/nCentroids_test *100;
stats_bayes(4) = misclasify_bayes_m/nCentroids_test *100;

fprintf(['El clasificador bayesiano se equivocó en ' num2str(stats_bayes(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador bayesiano se equivocó en ' num2str(stats_bayes(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador bayesiano se equivocó en ' num2str(stats_bayes(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador bayesiano se equivocó en ' num2str(stats_bayes(4)) '%% de las pruebas de M' ' \n'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

fprintf(' \n \n')
fprintf(':::evaluando K-vecinos con distancia euclidiana::: \n')
z_vocs = [feat_a feat_u];
v_vocs = [ones(1,nCentroids) 2*ones(1,nCentroids)];

z_cons = [feat_s feat_m];
v_cons = [3*ones(1,nCentroids) 4*ones(1,nCentroids)];

num_neighbors = 10;
misclasify_k_a = 0;
misclasify_k_u = 0;
misclasify_k_s = 0;
misclasify_k_m = 0;
for i=1:nCentroids_test
    k_neighbors_a = k_nn_classifier(z_vocs,v_vocs,num_neighbors, feat_test_a(1:3,i));
    if k_neighbors_a ~= 1
        misclasify_k_a = misclasify_k_a + 1;
    end
    
    k_neighbors_u = k_nn_classifier(z_vocs,v_vocs,num_neighbors, feat_test_u(1:3,i));
    if k_neighbors_u ~= 2
        misclasify_k_u = misclasify_k_u + 1;
    end
    
    k_neighbors_s = k_nn_classifier(z_cons,v_cons,num_neighbors, feat_test_s(1:3,i));
    if k_neighbors_s ~= 3
        misclasify_k_s = misclasify_k_s + 1;
    end

    k_neighbors_m = k_nn_classifier(z_cons,v_cons,num_neighbors, feat_test_m(1:3,i));
    if k_neighbors_m ~= 4
        misclasify_k_m = misclasify_k_m + 1;
    end
end

stats_k = zeros(4,1);
stats_k(1) = misclasify_k_a/nCentroids_test *100;
stats_k(2) = misclasify_k_u/nCentroids_test *100;
stats_k(3) = misclasify_k_s/nCentroids_test *100;
stats_k(4) = misclasify_k_m/nCentroids_test *100;


fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(4)) '%% de las pruebas de M' ' \n'])


fprintf(' \n \n')
fprintf(':::evaluando K-vecinos 1 vs todos::: \n')
z = [feat_a feat_u feat_s feat_m];
v = [ones(1,nCentroids) 2*ones(1,nCentroids) 3*ones(1,nCentroids) 4*ones(1,nCentroids)];

num_neighbors = 10;
misclasify_k_a = 0;
misclasify_k_u = 0;
misclasify_k_s = 0;
misclasify_k_m = 0;
for i=1:nCentroids_test
    k_neighbors_a = k_nn_classifier(z,v,num_neighbors, feat_test_a(1:3,i));
    if k_neighbors_a ~= 1
        misclasify_k_a = misclasify_k_a + 1;
    end
    
    k_neighbors_u = k_nn_classifier(z,v,num_neighbors, feat_test_u(1:3,i));
    if k_neighbors_u ~= 2
        misclasify_k_u = misclasify_k_u + 1;
    end
    
    k_neighbors_s = k_nn_classifier(z,v,num_neighbors, feat_test_s(1:3,i));
    if k_neighbors_s ~= 3
        misclasify_k_s = misclasify_k_s + 1;
    end

    k_neighbors_m = k_nn_classifier(z,v,num_neighbors, feat_test_m(1:3,i));
    if k_neighbors_m ~= 4
        misclasify_k_m = misclasify_k_m + 1;
    end
end

stats_k = zeros(4,1);
stats_k(1) = misclasify_k_a/nCentroids_test *100;
stats_k(2) = misclasify_k_u/nCentroids_test *100;
stats_k(3) = misclasify_k_s/nCentroids_test *100;
stats_k(4) = misclasify_k_m/nCentroids_test *100;


fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador de k vecinos se equivocó en ' num2str(stats_k(4)) '%% de las pruebas de M' ' \n'])


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(' \n \n')
fprintf('::::::::evaluando con perceptrón por pares:::::::: \n')
misclasify_perce_a = 0;
misclasify_perce_u = 0;
misclasify_perce_s = 0;
misclasify_perce_m = 0;


for i=1:nCentroids_test
    g_a = dot(feat_test_a(:,i), w_perce_vocs);
    if g_a > 0
        misclasify_perce_a = misclasify_perce_a + 1;
    end
end

for i=1:nCentroids_test
    g_u = dot(feat_test_u(:,i), w_perce_vocs);
    if g_u < 0
        misclasify_perce_u = misclasify_perce_u + 1;
    end
end

for i=1:nCentroids_test
    g_s = dot(feat_test_s(:,i), w_perce_cons);
    if g_s > 0
        misclasify_perce_s = misclasify_perce_s + 1;
    end
end

for i=1:nCentroids_test
    g_m = dot(feat_test_m(:,i), w_perce_cons);
    if g_m < 0
        misclasify_perce_m = misclasify_perce_m + 1;
    end
end


stats_perce = zeros(4,1);
stats_perce(1) = misclasify_perce_a/nCentroids_test *100;
stats_perce(2) = misclasify_perce_u/nCentroids_test *100;
stats_perce(3) = misclasify_perce_s/nCentroids_test *100;
stats_perce(4) = misclasify_perce_m/nCentroids_test *100;

fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce(4)) '%% de las pruebas de M' ' \n'])

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(' \n \n')
fprintf('::::::::evaluando con suma de errores cuadraticos:::::::: \n')

misclasify_sumerrors_a = 0;
misclasify_sumerrors_u = 0;
misclasify_sumerrors_s = 0;
misclasify_sumerrors_m = 0;


for i=1:nCentroids_test
    g_a = dot(feat_test_a(:,i), w_sumerrors_vocs);
    if g_a > 0
        misclasify_sumerrors_a = misclasify_sumerrors_a + 1;
    end
end

for i=1:nCentroids_test
    g_u = dot(feat_test_u(:,i), w_sumerrors_vocs);
    if g_u < 0
        misclasify_sumerrors_u = misclasify_sumerrors_u + 1;
    end
end

for i=1:nCentroids_test
    g_s = dot(feat_test_s(:,i), w_sumerrors_cons);
    if g_s > 0
        misclasify_sumerrors_s = misclasify_sumerrors_s + 1;
    end
end

for i=1:nCentroids_test
    g_m = dot(feat_test_m(:,i), w_sumerrors_cons);
    if g_m < 0
        misclasify_sumerrors_m = misclasify_sumerrors_m + 1;
    end
end


stats_sumerrors = zeros(4,1);
stats_sumerrors(1) = misclasify_sumerrors_a/nCentroids_test *100;
stats_sumerrors(2) = misclasify_sumerrors_u/nCentroids_test *100;
stats_sumerrors(3) = misclasify_sumerrors_s/nCentroids_test *100;
stats_sumerrors(4) = misclasify_sumerrors_m/nCentroids_test *100;

fprintf(['El clasificador con suma de errores se equivocó en ' num2str(stats_sumerrors(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador con suma de errores se equivocó en ' num2str(stats_sumerrors(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador con suma de errores se equivocó en ' num2str(stats_sumerrors(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador con suma de errores se equivocó en ' num2str(stats_sumerrors(4)) '%% de las pruebas de M' ' \n'])

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
fprintf(' \n \n')
fprintf('::::::::evaluando con LMS:::::::: \n')

misclasify_lms_a = 0;
misclasify_lms_u = 0;
misclasify_lms_s = 0;
misclasify_lms_m = 0;


for i=1:nCentroids_test
    g_a = dot(feat_test_a(:,i), w_lms_vocs);
    if g_a > 0
        misclasify_lms_a = misclasify_lms_a + 1;
    end
end

for i=1:nCentroids_test
    g_u = dot(feat_test_u(:,i), w_lms_vocs);
    if g_u < 0
        misclasify_lms_u = misclasify_lms_u + 1;
    end
end

for i=1:nCentroids_test
    g_s = dot(feat_test_s(:,i), w_lms_cons);
    if g_s > 0
        misclasify_lms_s = misclasify_lms_s + 1;
    end
end

for i=1:nCentroids_test
    g_m = dot(feat_test_m(:,i), w_lms_cons);
    if g_m < 0
        misclasify_lms_m = misclasify_lms_m + 1;
    end
end


stats_lms = zeros(4,1);
stats_lms(1) = misclasify_lms_a/nCentroids_test *100;
stats_lms(2) = misclasify_lms_u/nCentroids_test *100;
stats_lms(3) = misclasify_lms_s/nCentroids_test *100;
stats_lms(4) = misclasify_lms_m/nCentroids_test *100;

fprintf(['El clasificador con LMS se equivocó en ' num2str(stats_lms(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador con LMS se equivocó en ' num2str(stats_lms(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador con LMS se equivocó en ' num2str(stats_lms(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador con LMS se equivocó en ' num2str(stats_lms(4)) '%% de las pruebas de M' ' \n'])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(' \n \n')
fprintf('::::::::evaluando perceptrón A vs todos:::::::: \n')

misclasify_perce_a_all = 0;
for i=1:nCentroids_test
    g_a = dot(feat_test_a(:,i), w_perce_a);
    if g_a < 0
        misclasify_perce_a_all = misclasify_perce_a_all + 1;
    end
end
stats_perce_a_all = misclasify_perce_a_all/nCentroids_test *100;
fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce_a_all) '%% de las pruebas de A' ' \n'])


fprintf(' \n \n')
fprintf('::::::::evaluando perceptrón U vs todos:::::::: \n')

misclasify_perce_u_all = 0;
for i=1:nCentroids_test
    g_u = dot(feat_test_u(:,i), w_perce_u);
    if g_u < 0
        misclasify_perce_u_all = misclasify_perce_u_all + 1;
    end
end
stats_perce_u_all = misclasify_perce_u_all/nCentroids_test *100;
fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce_u_all) '%% de las pruebas de U' ' \n'])


fprintf(' \n \n')
fprintf('::::::::evaluando perceptrón S vs todos:::::::: \n')

misclasify_perce_s_all = 0;
for i=1:nCentroids_test
    g_s = dot(feat_test_s(:,i), w_perce_s);
    if g_s < 0
        misclasify_perce_s_all = misclasify_perce_s_all + 1;
    end
end
stats_perce_s_all = misclasify_perce_s_all/nCentroids_test *100;
fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce_s_all) '%% de las pruebas de S' ' \n'])


fprintf(' \n \n')
fprintf('::::::::evaluando perceptrón M vs todos:::::::: \n')

misclasify_perce_m_all = 0;
for i=1:nCentroids_test
    g_m = dot(feat_test_m(:,i), w_perce_m);
    if g_m < 0
        misclasify_perce_m_all = misclasify_perce_m_all + 1;
    end
end
stats_perce_m_all = misclasify_perce_m_all/nCentroids_test *100;
fprintf(['El clasificador con perceptrón se equivocó en ' num2str(stats_perce_m_all) '%% de las pruebas de M' ' \n'])

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %pruebas de red neuronal
fprintf('Evaluando con red multicapa... \n')
misclasified_nn_a = 0;
for i=1:nCentroids_test
    out_a = sim(net,feat_test_a(1:3,i));
    [n class] = max(out_a);
    if class ~= 1
        misclasified_nn_a = misclasified_nn_a + 1;
    end
end
stats_nn_a = misclasified_nn_a/nCentroids_test *100;
fprintf(['El clasificador con red neuronal multicapa se equivocó en ' num2str(stats_nn_a) '%% de las pruebas de A' ' \n'])



misclasified_nn_u = 0;
for i=1:nCentroids_test
    out_u = sim(net,feat_test_u(1:3,i));
    [n class] = max(out_u);
    if class ~= 2
        misclasified_nn_u = misclasified_nn_u + 1;
    end
end
stats_nn_u = misclasified_nn_u/nCentroids_test *100;
fprintf(['El clasificador con red neuronal multicapa se equivocó en ' num2str(stats_nn_u) '%% de las pruebas de U' ' \n'])


misclasified_nn_s = 0;
for i=1:nCentroids_test
    out_s = sim(net,feat_test_s(1:3,i));
    [n class] = max(out_s);
    if class ~= 3
        misclasified_nn_s = misclasified_nn_s + 1;
    end
end
stats_nn_s = misclasified_nn_s/nCentroids_test *100;
fprintf(['El clasificador con red neuronal multicapa se equivocó en ' num2str(stats_nn_s) '%% de las pruebas de S' ' \n'])


misclasified_nn_m = 0;
for i=1:nCentroids_test
    out_m = sim(net,feat_test_m(1:3,i));
    [n class] = max(out_m);
    if class ~= 4
        misclasified_nn_m = misclasified_nn_m + 1;
    end
end
stats_nn_m = misclasified_nn_m/nCentroids_test *100;
fprintf(['El clasificador con red neuronal multicapa se equivocó en ' num2str(stats_nn_m) '%% de las pruebas de M' ' \n'])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%Pruebas clusterizacin por BSAS
%se prueba con los datos de entrenamiento para reconocer cual vector
%representa a cada fonema
misclasified_bsas_a = 0;
distance_bsas_a = zeros(4,nCentroids);
for i=1:nCentroids
    distance_bsas_a(1,i) = sqrt( (vq_fon_bsas(1,1)-feat_a(1,i))^2 +  (vq_fon_bsas(2,1)-feat_a(2,i))^2 + (vq_fon_bsas(3,1)-feat_a(3,i))^2 );
    distance_bsas_a(2,i) = sqrt( (vq_fon_bsas(1,2)-feat_a(1,i))^2 +  (vq_fon_bsas(2,2)-feat_a(2,i))^2 + (vq_fon_bsas(3,2)-feat_a(3,i))^2 );
    distance_bsas_a(3,i) = sqrt( (vq_fon_bsas(1,3)-feat_a(1,i))^2 +  (vq_fon_bsas(2,3)-feat_a(2,i))^2 + (vq_fon_bsas(3,3)-feat_a(3,i))^2 );
    distance_bsas_a(4,i) = sqrt( (vq_fon_bsas(1,4)-feat_a(1,i))^2 +  (vq_fon_bsas(2,4)-feat_a(2,i))^2 + (vq_fon_bsas(3,4)-feat_a(3,i))^2 );
end
[c inx_bsas_a] = min( mean(distance_bsas_a') ); %%3


misclasified_bsas_u = 0;
distance_bsas_u = zeros(4,nCentroids);
for i=1:nCentroids
    distance_bsas_u(1,i) = sqrt( (vq_fon_bsas(1,1)-feat_u(1,i))^2 +  (vq_fon_bsas(2,1)-feat_u(2,i))^2 + (vq_fon_bsas(3,1)-feat_u(3,i))^2 );
    distance_bsas_u(2,i) = sqrt( (vq_fon_bsas(1,2)-feat_u(1,i))^2 +  (vq_fon_bsas(2,2)-feat_u(2,i))^2 + (vq_fon_bsas(3,2)-feat_u(3,i))^2 );
    distance_bsas_u(3,i) = sqrt( (vq_fon_bsas(1,3)-feat_u(1,i))^2 +  (vq_fon_bsas(2,3)-feat_u(2,i))^2 + (vq_fon_bsas(3,3)-feat_u(3,i))^2 );
    distance_bsas_u(4,i) = sqrt( (vq_fon_bsas(1,4)-feat_u(1,i))^2 +  (vq_fon_bsas(2,4)-feat_u(2,i))^2 + (vq_fon_bsas(3,4)-feat_u(3,i))^2 );
end
[c inx_bsas_u] = min( mean(distance_bsas_u') ); %%1


misclasified_bsas_s = 0;
distance_bsas_s = zeros(4,nCentroids);
for i=1:nCentroids
    distance_bsas_s(1,i) = sqrt( (vq_fon_bsas(1,1)-feat_s(1,i))^2 +  (vq_fon_bsas(2,1)-feat_s(2,i))^2 + (vq_fon_bsas(3,1)-feat_s(3,i))^2 );
    distance_bsas_s(2,i) = sqrt( (vq_fon_bsas(1,2)-feat_s(1,i))^2 +  (vq_fon_bsas(2,2)-feat_s(2,i))^2 + (vq_fon_bsas(3,2)-feat_s(3,i))^2 );
    distance_bsas_s(3,i) = sqrt( (vq_fon_bsas(1,3)-feat_s(1,i))^2 +  (vq_fon_bsas(2,3)-feat_s(2,i))^2 + (vq_fon_bsas(3,3)-feat_s(3,i))^2 );
    distance_bsas_s(4,i) = sqrt( (vq_fon_bsas(1,4)-feat_s(1,i))^2 +  (vq_fon_bsas(2,4)-feat_s(2,i))^2 + (vq_fon_bsas(3,4)-feat_s(3,i))^2 );
end
[c inx_bsas_s] = min( mean(distance_bsas_s') ); %%4


misclasified_bsas_m = 0;
distance_bsas_m = zeros(4,nCentroids);
for i=1:nCentroids
    distance_bsas_m(1,i) = sqrt( (vq_fon_bsas(1,1)-feat_m(1,i))^2 +  (vq_fon_bsas(2,1)-feat_m(2,i))^2 + (vq_fon_bsas(3,1)-feat_m(3,i))^2 );
    distance_bsas_m(2,i) = sqrt( (vq_fon_bsas(1,2)-feat_m(1,i))^2 +  (vq_fon_bsas(2,2)-feat_m(2,i))^2 + (vq_fon_bsas(3,2)-feat_m(3,i))^2 );
    distance_bsas_m(3,i) = sqrt( (vq_fon_bsas(1,3)-feat_m(1,i))^2 +  (vq_fon_bsas(2,3)-feat_m(2,i))^2 + (vq_fon_bsas(3,3)-feat_m(3,i))^2 );
    distance_bsas_m(4,i) = sqrt( (vq_fon_bsas(1,4)-feat_m(1,i))^2 +  (vq_fon_bsas(2,4)-feat_m(2,i))^2 + (vq_fon_bsas(3,4)-feat_m(3,i))^2 );
end
[c inx_bsas_m] = min( mean(distance_bsas_m') ); %%3

%Pruebas con BSAS
misclasified_bsas_a = 0;
distance_bsas_a = zeros(4,1);
for i=1:nCentroids_test
    distance_bsas_a(1,1) = sqrt( (vq_fon_bsas(1,1)-feat_test_a(1,i))^2 +  (vq_fon_bsas(2,1)-feat_test_a(2,i))^2 + (vq_fon_bsas(3,1)-feat_test_a(3,i))^2 );
    distance_bsas_a(2,1) = sqrt( (vq_fon_bsas(1,2)-feat_test_a(1,i))^2 +  (vq_fon_bsas(2,2)-feat_test_a(2,i))^2 + (vq_fon_bsas(3,2)-feat_test_a(3,i))^2 );
    distance_bsas_a(3,1) = sqrt( (vq_fon_bsas(1,3)-feat_test_a(1,i))^2 +  (vq_fon_bsas(2,3)-feat_test_a(2,i))^2 + (vq_fon_bsas(3,3)-feat_test_a(3,i))^2 );
    distance_bsas_a(4,1) = sqrt( (vq_fon_bsas(1,4)-feat_test_a(1,i))^2 +  (vq_fon_bsas(2,4)-feat_test_a(2,i))^2 + (vq_fon_bsas(3,4)-feat_test_a(3,i))^2 );
    [c inx_bsas_a] = min( distance_bsas_a' ); %%3
    if inx_bsas_a ~= 3
        misclasified_bsas_a = misclasified_bsas_a + 1;
    end
end

misclasified_bsas_u = 0;
distance_bsas_u = zeros(4,1);
for i=1:nCentroids_test
    distance_bsas_u(1,1) = sqrt( (vq_fon_bsas(1,1)-feat_test_u(1,i))^2 +  (vq_fon_bsas(2,1)-feat_test_u(2,i))^2 + (vq_fon_bsas(3,1)-feat_test_u(3,i))^2 );
    distance_bsas_u(2,1) = sqrt( (vq_fon_bsas(1,2)-feat_test_u(1,i))^2 +  (vq_fon_bsas(2,2)-feat_test_u(2,i))^2 + (vq_fon_bsas(3,2)-feat_test_u(3,i))^2 );
    distance_bsas_u(3,1) = sqrt( (vq_fon_bsas(1,3)-feat_test_u(1,i))^2 +  (vq_fon_bsas(2,3)-feat_test_u(2,i))^2 + (vq_fon_bsas(3,3)-feat_test_u(3,i))^2 );
    distance_bsas_u(4,1) = sqrt( (vq_fon_bsas(1,4)-feat_test_u(1,i))^2 +  (vq_fon_bsas(2,4)-feat_test_u(2,i))^2 + (vq_fon_bsas(3,4)-feat_test_u(3,i))^2 );
    [c inx_bsas_u] = min( distance_bsas_u' ); %%1
    if inx_bsas_u ~= 1
        misclasified_bsas_u = misclasified_bsas_u + 1;
    end
end

misclasified_bsas_s = 0;
distance_bsas_s = zeros(4,1);
for i=1:nCentroids_test
    distance_bsas_s(1,1) = sqrt( (vq_fon_bsas(1,1)-feat_test_s(1,i))^2 +  (vq_fon_bsas(2,1)-feat_test_s(2,i))^2 + (vq_fon_bsas(3,1)-feat_test_s(3,i))^2 );
    distance_bsas_s(2,1) = sqrt( (vq_fon_bsas(1,2)-feat_test_s(1,i))^2 +  (vq_fon_bsas(2,2)-feat_test_s(2,i))^2 + (vq_fon_bsas(3,2)-feat_test_s(3,i))^2 );
    distance_bsas_s(3,1) = sqrt( (vq_fon_bsas(1,3)-feat_test_s(1,i))^2 +  (vq_fon_bsas(2,3)-feat_test_s(2,i))^2 + (vq_fon_bsas(3,3)-feat_test_s(3,i))^2 );
    distance_bsas_s(4,1) = sqrt( (vq_fon_bsas(1,4)-feat_test_s(1,i))^2 +  (vq_fon_bsas(2,4)-feat_test_s(2,i))^2 + (vq_fon_bsas(3,4)-feat_test_s(3,i))^2 );
    [c inx_bsas_s] = min( distance_bsas_s' ); %%4
    if inx_bsas_s ~= 4
        misclasified_bsas_s = misclasified_bsas_s + 1;
    end
end

misclasified_bsas_m = 0;
distance_bsas_m = zeros(4,1);
for i=1:nCentroids_test
    distance_bsas_m(1,1) = sqrt( (vq_fon_bsas(1,1)-feat_test_m(1,i))^2 +  (vq_fon_bsas(2,1)-feat_test_m(2,i))^2 + (vq_fon_bsas(3,1)-feat_test_m(3,i))^2 );
    distance_bsas_m(2,1) = sqrt( (vq_fon_bsas(1,2)-feat_test_m(1,i))^2 +  (vq_fon_bsas(2,2)-feat_test_m(2,i))^2 + (vq_fon_bsas(3,2)-feat_test_m(3,i))^2 );
    distance_bsas_m(3,1) = sqrt( (vq_fon_bsas(1,3)-feat_test_m(1,i))^2 +  (vq_fon_bsas(2,3)-feat_test_m(2,i))^2 + (vq_fon_bsas(3,3)-feat_test_m(3,i))^2 );
    distance_bsas_m(4,1) = sqrt( (vq_fon_bsas(1,4)-feat_test_m(1,i))^2 +  (vq_fon_bsas(2,4)-feat_test_m(2,i))^2 + (vq_fon_bsas(3,4)-feat_test_m(3,i))^2 );
    [c inx_bsas_m] = min( distance_bsas_m' ); %%3?
    if inx_bsas_m ~= 3
        misclasified_bsas_m = misclasified_bsas_m + 1;
    end
end

stats_bsas = zeros(4,1);
stats_bsas(1) = misclasified_bsas_a/nCentroids_test *100;
stats_bsas(2) = misclasified_bsas_u/nCentroids_test *100;
stats_bsas(3) = misclasified_bsas_s/nCentroids_test *100;
stats_bsas(4) = misclasified_bsas_m/nCentroids_test *100;

fprintf(['El clasificador con clustering BSAS se equivocó en ' num2str(stats_bsas(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador con clustering BSAS se equivocó en ' num2str(stats_bsas(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador con clustering BSAS se equivocó en ' num2str(stats_bsas(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador con clustering BSAS se equivocó en ' num2str(stats_bsas(4)) '%% de las pruebas de M' ' \n'])










%%%%Pruebas clusterizacin por LBG
%se prueba con los datos de entrenamiento para reconocer cual vector
%representa a cada fonema
misclasified_lbg_a = 0;
distance_lbg_a = zeros(4,nCentroids);
for i=1:nCentroids
    distance_lbg_a(1,i) = sqrt( (vq_fon_lbg(1,1)-feat_a(1,i))^2 +  (vq_fon_lbg(2,1)-feat_a(2,i))^2 + (vq_fon_lbg(3,1)-feat_a(3,i))^2 );
    distance_lbg_a(2,i) = sqrt( (vq_fon_lbg(1,2)-feat_a(1,i))^2 +  (vq_fon_lbg(2,2)-feat_a(2,i))^2 + (vq_fon_lbg(3,2)-feat_a(3,i))^2 );
    distance_lbg_a(3,i) = sqrt( (vq_fon_lbg(1,3)-feat_a(1,i))^2 +  (vq_fon_lbg(2,3)-feat_a(2,i))^2 + (vq_fon_lbg(3,3)-feat_a(3,i))^2 );
    distance_lbg_a(4,i) = sqrt( (vq_fon_lbg(1,4)-feat_a(1,i))^2 +  (vq_fon_lbg(2,4)-feat_a(2,i))^2 + (vq_fon_lbg(3,4)-feat_a(3,i))^2 );
end
[c inx_lbg_a] = min( mean(distance_lbg_a') ); %%1


misclasified_lbg_u = 0;
distance_lbg_u = zeros(4,nCentroids);
for i=1:nCentroids
    distance_lbg_u(1,i) = sqrt( (vq_fon_lbg(1,1)-feat_u(1,i))^2 +  (vq_fon_lbg(2,1)-feat_u(2,i))^2 + (vq_fon_lbg(3,1)-feat_u(3,i))^2 );
    distance_lbg_u(2,i) = sqrt( (vq_fon_lbg(1,2)-feat_u(1,i))^2 +  (vq_fon_lbg(2,2)-feat_u(2,i))^2 + (vq_fon_lbg(3,2)-feat_u(3,i))^2 );
    distance_lbg_u(3,i) = sqrt( (vq_fon_lbg(1,3)-feat_u(1,i))^2 +  (vq_fon_lbg(2,3)-feat_u(2,i))^2 + (vq_fon_lbg(3,3)-feat_u(3,i))^2 );
    distance_lbg_u(4,i) = sqrt( (vq_fon_lbg(1,4)-feat_u(1,i))^2 +  (vq_fon_lbg(2,4)-feat_u(2,i))^2 + (vq_fon_lbg(3,4)-feat_u(3,i))^2 );
end
[c inx_lbg_u] = min( mean(distance_lbg_u') ); %%3


misclasified_lbg_s = 0;
distance_lbg_s = zeros(4,nCentroids);
for i=1:nCentroids
    distance_lbg_s(1,i) = sqrt( (vq_fon_lbg(1,1)-feat_s(1,i))^2 +  (vq_fon_lbg(2,1)-feat_s(2,i))^2 + (vq_fon_lbg(3,1)-feat_s(3,i))^2 );
    distance_lbg_s(2,i) = sqrt( (vq_fon_lbg(1,2)-feat_s(1,i))^2 +  (vq_fon_lbg(2,2)-feat_s(2,i))^2 + (vq_fon_lbg(3,2)-feat_s(3,i))^2 );
    distance_lbg_s(3,i) = sqrt( (vq_fon_lbg(1,3)-feat_s(1,i))^2 +  (vq_fon_lbg(2,3)-feat_s(2,i))^2 + (vq_fon_lbg(3,3)-feat_s(3,i))^2 );
    distance_lbg_s(4,i) = sqrt( (vq_fon_lbg(1,4)-feat_s(1,i))^2 +  (vq_fon_lbg(2,4)-feat_s(2,i))^2 + (vq_fon_lbg(3,4)-feat_s(3,i))^2 );
end
[c inx_lbg_s] = min( mean(distance_lbg_s') ); %%4


misclasified_lbg_m = 0;
distance_lbg_m = zeros(4,nCentroids);
for i=1:nCentroids
    distance_lbg_m(1,i) = sqrt( (vq_fon_lbg(1,1)-feat_m(1,i))^2 +  (vq_fon_lbg(2,1)-feat_m(2,i))^2 + (vq_fon_lbg(3,1)-feat_m(3,i))^2 );
    distance_lbg_m(2,i) = sqrt( (vq_fon_lbg(1,2)-feat_m(1,i))^2 +  (vq_fon_lbg(2,2)-feat_m(2,i))^2 + (vq_fon_lbg(3,2)-feat_m(3,i))^2 );
    distance_lbg_m(3,i) = sqrt( (vq_fon_lbg(1,3)-feat_m(1,i))^2 +  (vq_fon_lbg(2,3)-feat_m(2,i))^2 + (vq_fon_lbg(3,3)-feat_m(3,i))^2 );
    distance_lbg_m(4,i) = sqrt( (vq_fon_lbg(1,4)-feat_m(1,i))^2 +  (vq_fon_lbg(2,4)-feat_m(2,i))^2 + (vq_fon_lbg(3,4)-feat_m(3,i))^2 );
end
[c inx_lbg_m] = min( mean(distance_lbg_m') ); %%2

%Pruebas con LBG
misclasified_lbg_a = 0;
distance_lbg_a = zeros(4,1);
for i=1:nCentroids_test
    distance_lbg_a(1,1) = sqrt( (vq_fon_lbg(1,1)-feat_test_a(1,i))^2 +  (vq_fon_lbg(2,1)-feat_test_a(2,i))^2 + (vq_fon_lbg(3,1)-feat_test_a(3,i))^2 );
    distance_lbg_a(2,1) = sqrt( (vq_fon_lbg(1,2)-feat_test_a(1,i))^2 +  (vq_fon_lbg(2,2)-feat_test_a(2,i))^2 + (vq_fon_lbg(3,2)-feat_test_a(3,i))^2 );
    distance_lbg_a(3,1) = sqrt( (vq_fon_lbg(1,3)-feat_test_a(1,i))^2 +  (vq_fon_lbg(2,3)-feat_test_a(2,i))^2 + (vq_fon_lbg(3,3)-feat_test_a(3,i))^2 );
    distance_lbg_a(4,1) = sqrt( (vq_fon_lbg(1,4)-feat_test_a(1,i))^2 +  (vq_fon_lbg(2,4)-feat_test_a(2,i))^2 + (vq_fon_lbg(3,4)-feat_test_a(3,i))^2 );
    [c inx_lbg_a] = min( distance_lbg_a' ); %%1
    if inx_lbg_a ~= 1
        misclasified_lbg_a = misclasified_lbg_a + 1;
    end
end
%Pruebas con LBG
misclasified_lbg_u = 0;
distance_lbg_u = zeros(4,1);
for i=1:nCentroids_test
    distance_lbg_u(1,1) = sqrt( (vq_fon_lbg(1,1)-feat_test_u(1,i))^2 +  (vq_fon_lbg(2,1)-feat_test_u(2,i))^2 + (vq_fon_lbg(3,1)-feat_test_u(3,i))^2 );
    distance_lbg_u(2,1) = sqrt( (vq_fon_lbg(1,2)-feat_test_u(1,i))^2 +  (vq_fon_lbg(2,2)-feat_test_u(2,i))^2 + (vq_fon_lbg(3,2)-feat_test_u(3,i))^2 );
    distance_lbg_u(3,1) = sqrt( (vq_fon_lbg(1,3)-feat_test_u(1,i))^2 +  (vq_fon_lbg(2,3)-feat_test_u(2,i))^2 + (vq_fon_lbg(3,3)-feat_test_u(3,i))^2 );
    distance_lbg_u(4,1) = sqrt( (vq_fon_lbg(1,4)-feat_test_u(1,i))^2 +  (vq_fon_lbg(2,4)-feat_test_u(2,i))^2 + (vq_fon_lbg(3,4)-feat_test_u(3,i))^2 );
    [c inx_lbg_u] = min( distance_lbg_u' ); %%3
    if inx_lbg_u ~= 3
        misclasified_lbg_u = misclasified_lbg_u + 1;
    end
end

%Pruebas con LBG
misclasified_lbg_s = 0;
distance_lbg_s = zeros(4,1);
for i=1:nCentroids_test
    distance_lbg_s(1,1) = sqrt( (vq_fon_lbg(1,1)-feat_test_s(1,i))^2 +  (vq_fon_lbg(2,1)-feat_test_s(2,i))^2 + (vq_fon_lbg(3,1)-feat_test_s(3,i))^2 );
    distance_lbg_s(2,1) = sqrt( (vq_fon_lbg(1,2)-feat_test_s(1,i))^2 +  (vq_fon_lbg(2,2)-feat_test_s(2,i))^2 + (vq_fon_lbg(3,2)-feat_test_s(3,i))^2 );
    distance_lbg_s(3,1) = sqrt( (vq_fon_lbg(1,3)-feat_test_s(1,i))^2 +  (vq_fon_lbg(2,3)-feat_test_s(2,i))^2 + (vq_fon_lbg(3,3)-feat_test_s(3,i))^2 );
    distance_lbg_s(4,1) = sqrt( (vq_fon_lbg(1,4)-feat_test_s(1,i))^2 +  (vq_fon_lbg(2,4)-feat_test_s(2,i))^2 + (vq_fon_lbg(3,4)-feat_test_s(3,i))^2 );
    [c inx_lbg_s] = min( distance_lbg_s' ); %%4
    if inx_lbg_s ~= 4
        misclasified_lbg_s = misclasified_lbg_s + 1;
    end
end

%Pruebas con LBG
misclasified_lbg_m = 0;
distance_lbg_m = zeros(4,1);
for i=1:nCentroids_test
    distance_lbg_m(1,1) = sqrt( (vq_fon_lbg(1,1)-feat_test_m(1,i))^2 +  (vq_fon_lbg(2,1)-feat_test_m(2,i))^2 + (vq_fon_lbg(3,1)-feat_test_m(3,i))^2 );
    distance_lbg_m(2,1) = sqrt( (vq_fon_lbg(1,2)-feat_test_m(1,i))^2 +  (vq_fon_lbg(2,2)-feat_test_m(2,i))^2 + (vq_fon_lbg(3,2)-feat_test_m(3,i))^2 );
    distance_lbg_m(3,1) = sqrt( (vq_fon_lbg(1,3)-feat_test_m(1,i))^2 +  (vq_fon_lbg(2,3)-feat_test_m(2,i))^2 + (vq_fon_lbg(3,3)-feat_test_m(3,i))^2 );
    distance_lbg_m(4,1) = sqrt( (vq_fon_lbg(1,4)-feat_test_m(1,i))^2 +  (vq_fon_lbg(2,4)-feat_test_m(2,i))^2 + (vq_fon_lbg(3,4)-feat_test_m(3,i))^2 );
    [c inx_lbg_m] = min( distance_lbg_m' ); %%2
    if inx_lbg_m ~= 2
        misclasified_lbg_m = misclasified_lbg_m + 1;
    end
end

stats_lbg = zeros(4,1);
stats_lbg(1) = misclasified_lbg_a/nCentroids_test *100;
stats_lbg(2) = misclasified_lbg_u/nCentroids_test *100;
stats_lbg(3) = misclasified_lbg_s/nCentroids_test *100;
stats_lbg(4) = misclasified_lbg_m/nCentroids_test *100;

fprintf(['El clasificador con clustering de cuantización vectorial se equivocó en ' num2str(stats_lbg(1)) '%% de las pruebas de A' ' \n'])
fprintf(['El clasificador con clustering de cuantización vectorial se equivocó en ' num2str(stats_lbg(2)) '%% de las pruebas de U' ' \n'])
fprintf(['El clasificador con clustering de cuantización vectorial se equivocó en ' num2str(stats_lbg(3)) '%% de las pruebas de S' ' \n'])
fprintf(['El clasificador con clustering de cuantización vectorial se equivocó en ' num2str(stats_lbg(4)) '%% de las pruebas de M' ' \n'])
















%graficacion 
figure (1)
hold all
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('Features: Azul = a. Verde = u.');
hold off


figure (2)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'k+');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'r+');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
title('Features: Negro = s. Rojo = m.');
hold off


%%%%%%%%%%%%%PERCEPTRON
figure (3)
hold all
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('Perceptrón vocales: Azul = a. Verde = u.');
pointA = [ 0.5, 0.2, (0.5*(-w_perce_vocs(1)) + 0.2*-w_perce_vocs(2) - w_perce_vocs(4))/w_perce_vocs(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_perce_vocs(1)) + 0.2*-w_perce_vocs(2) - w_perce_vocs(4))/w_perce_vocs(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_perce_vocs(1)) - 0.2*-w_perce_vocs(2) - w_perce_vocs(4))/w_perce_vocs(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'r')
grid on
alpha(0.3)
hold off


figure (4)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'ko');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'ro');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
title('Perceptrón consonantes: Negro = s. Rojo = m.');
pointA = [ 0.5, 0.2, (0.5*(-w_perce_cons(1)) + 0.2*-w_perce_cons(2) - w_perce_cons(4))/w_perce_cons(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_perce_cons(1)) + 0.2*-w_perce_cons(2) - w_perce_cons(4))/w_perce_cons(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_perce_cons(1)) - 0.2*-w_perce_cons(2) - w_perce_cons(4))/w_perce_cons(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'g')
grid on
alpha(0.3)
hold off


%%%%%%%%%%%%%SUMA DE ERRORES
figure (5)
hold all
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('suma de errores vocales: Azul = a. Verde = u.');
pointA = [ 0.5, 0.2, (0.5*(-w_sumerrors_vocs(1)) + 0.2*-w_sumerrors_vocs(2) - w_sumerrors_vocs(4))/w_sumerrors_vocs(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_sumerrors_vocs(1)) + 0.2*-w_sumerrors_vocs(2) - w_sumerrors_vocs(4))/w_sumerrors_vocs(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_sumerrors_vocs(1)) - 0.2*-w_sumerrors_vocs(2) - w_sumerrors_vocs(4))/w_sumerrors_vocs(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'r')
grid on
alpha(0.3)
hold off


figure (6)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'ko');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'ro');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
title('suma de errores consonantes: Negro = s. Rojo = m.');
pointA = [ 0.5, 0.2, (0.5*(-w_sumerrors_cons(1)) + 0.2*-w_sumerrors_cons(2) - w_sumerrors_cons(4))/w_sumerrors_cons(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_sumerrors_cons(1)) + 0.2*-w_sumerrors_cons(2) - w_sumerrors_cons(4))/w_sumerrors_cons(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_sumerrors_cons(1)) - 0.2*-w_sumerrors_cons(2) - w_sumerrors_cons(4))/w_sumerrors_cons(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'g')
grid on
alpha(0.3)
hold off




%%%%%%%%%%%%%LMS
figure (7)
hold all
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('LMS vocales: Azul = a. Verde = u.');
pointA = [ 0.5, 0.2, (0.5*(-w_lms_vocs(1)) + 0.2*-w_lms_vocs(2) - w_lms_vocs(4))/w_lms_vocs(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_lms_vocs(1)) + 0.2*-w_lms_vocs(2) - w_lms_vocs(4))/w_lms_vocs(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_lms_vocs(1)) - 0.2*-w_lms_vocs(2) - w_lms_vocs(4))/w_lms_vocs(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'r')
grid on
alpha(0.3)
hold off


figure (8)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'ko');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'ro');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
title('LMS consonantes: Negro = s. Rojo = m.');
pointA = [ 0.5, 0.2, (0.5*(-w_lms_cons(1)) + 0.2*-w_lms_cons(2) - w_lms_cons(4))/w_lms_cons(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_lms_cons(1)) + 0.2*-w_lms_cons(2) - w_lms_cons(4))/w_lms_cons(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_lms_cons(1)) - 0.2*-w_lms_cons(2) - w_lms_cons(4))/w_lms_cons(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'g')
grid on
alpha(0.3)
hold off


%%%%%%%%%% A vs TODOS
figure (9)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'ko');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'ro');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('Perceptron A vs todos: Azul = a. Verde = u. Negro = s. Rojo = m.');
pointA = [ 0.5, 0.2, (0.5*(-w_perce_a(1)) + 0.2*-w_perce_a(2) - w_perce_a(4))/w_perce_a(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_perce_a(1)) + 0.2*-w_perce_a(2) - w_perce_a(4))/w_perce_a(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_perce_a(1)) - 0.2*-w_perce_a(2) - w_perce_a(4))/w_perce_a(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'g')
grid on
alpha(0.3)
hold off


%%%%%%%%%% U vs TODOS
figure (10)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'ko');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'ro');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('Perceptron U vs todos: Azul = a. Verde = u. Negro = s. Rojo = m.');
pointA = [ 0.5, 0.2, (0.5*(-w_perce_u(1)) + 0.2*-w_perce_u(2) - w_perce_u(4))/w_perce_u(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_perce_u(1)) + 0.2*-w_perce_u(2) - w_perce_u(4))/w_perce_u(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_perce_u(1)) - 0.2*-w_perce_u(2) - w_perce_u(4))/w_perce_u(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'g')
grid on
alpha(0.3)
hold off


%%%%%%%%%% S vs TODOS
figure (11)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'ko');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'ro');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('Perceptron S vs todos: Azul = a. Verde = u. Negro = s. Rojo = m.');
pointA = [ 0.5, 0.2, (0.5*(-w_perce_s(1)) + 0.2*-w_perce_s(2) - w_perce_s(4))/w_perce_s(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_perce_s(1)) + 0.2*-w_perce_s(2) - w_perce_s(4))/w_perce_s(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_perce_s(1)) - 0.2*-w_perce_s(2) - w_perce_s(4))/w_perce_s(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'g')
grid on
alpha(0.3)
hold off


%%%%%%%%%% M vs TODOS
figure (12)
hold all
plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'ko');
plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'ro');
plot3(feat_test_s(1,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(1,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
plot3(feat_test_a(1,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(1,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('Perceptron M vs todos: Azul = a. Verde = u. Negro = s. Rojo = m.');
pointA = [ 0.5, 0.2, (0.5*(-w_perce_m(1)) + 0.2*-w_perce_m(2) - w_perce_m(4))/w_perce_m(3) ];
pointB = [ -0.2, 0.2, (-0.2*(-w_perce_m(1)) + 0.2*-w_perce_m(2) - w_perce_m(4))/w_perce_m(3) ];
pointC = [ 0.2, -0.2, (0.2*(-w_perce_m(1)) - 0.2*-w_perce_m(2) - w_perce_m(4))/w_perce_m(3) ];
points=[pointA' pointB' pointC']; 
fill3(points(1,:),points(2,:),points(3,:),'g')
grid on
alpha(0.3)
hold off
