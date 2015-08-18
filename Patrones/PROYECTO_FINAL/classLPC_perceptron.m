%Limpia el ambiente del interprete
clear;
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

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%CLASIFICADORES LINEALES POR PARES %%%%%%%%%%%%%%%%%%%
% fprintf('clasificadores lineales por pares... \n');
% w_ini = [ 1 1 1 1 1 ]';
% 
% %::::::::::perceptron para consonantes::::::::::
% y_cons = [-ones(1,nCentroids) ones(1,nCentroids)];
% X_t_cons = [feat_s feat_m];
% X_t_cons(5,:) = 1;
% w_perce_cons = perce(X_t_cons, y_cons, w_ini);
% 
% %::::::::::perceptron para vocales::::::::::::::
% y_vocs = [-ones(1,nCentroids) ones(1,nCentroids)];
% X_t_vocs = [feat_a feat_u];
% X_t_vocs(5,:) = 1;
% w_perce_vocs = perce(X_t_vocs, y_vocs, w_ini);
% 
% 
% 
% %::::::::::suma de errores para consonantes::::::::::
% y_cons = [-ones(1,nCentroids) ones(1,nCentroids)];
% X_t_cons = [feat_s feat_m];
% X_t_cons(5,:) = 1;
% w_sumerrors_cons = sum_of_errors(X_t_cons, y_cons);
% 
% %::::::::::suma de errores para vocales::::::::::::::
% y_vocs = [-ones(1,nCentroids) ones(1,nCentroids)];
% X_t_vocs = [feat_a feat_u];
% X_t_vocs(4,:) = 1;
% w_sumerrors_vocs = sum_of_errors(X_t_vocs, y_vocs);
% 
% 
% w_ini = [0 0 0 1 0]';
% 
% %::::::::::LMS para consonantes::::::::::
% y_cons = [-ones(1,nCentroids) ones(1,nCentroids)];
% X_t_cons = [feat_s feat_m];
% X_t_cons(5,:) = 1;
% w_lms_cons = lms(X_t_cons, y_cons, w_ini);
% 
% 
% w_ini = [0 -1 1 1 0]';
% 
% %::::::::::LMS para vocales::::::::::::::
% y_vocs = [-ones(1,nCentroids) ones(1,nCentroids)];
% X_t_vocs = [feat_a feat_u];
% X_t_vocs(5,:) = 1;
% w_lms_vocs = lms(X_t_vocs, y_vocs, w_ini);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%CLASIFICADORES LINEALES UNO VS TODOS%%%%%%%%%%%%%%%%%
% fprintf('clasificador con perceptron uno contra todos... \n');
% w_ini = [ 1 1 1 1 1 ]';
% 
% %::::::::::perceptron para a::::::::::
% y_a = [-ones(1,3*nCentroids) ones(1,nCentroids)];
% X_t_a = [feat_s feat_m feat_u feat_a];
% X_t_a(5,:) = 1;
% w_perce_a = perce(X_t_a, y_a, w_ini);
% 
% %::::::::::perceptron para u::::::::::
% y_u = [-ones(1,3*nCentroids) ones(1,nCentroids)];
% X_t_u = [feat_s feat_m feat_a feat_u];
% X_t_u(5,:) = 1;
% w_perce_u = perce(X_t_u, y_u, w_ini);
% 
% %::::::::::perceptron para s::::::::::
% y_s = [-ones(1,3*nCentroids) ones(1,nCentroids)];
% X_t_s = [feat_a feat_m feat_u feat_s];
% X_t_s(5,:) = 1;
% w_perce_s = perce(X_t_s, y_s, w_ini);
% 
% %::::::::::perceptron para m::::::::::
% y_m = [-ones(1,3*nCentroids) ones(1,nCentroids)];
% X_t_m = [feat_s feat_a feat_u feat_m];
% X_t_m(5,:) = 1;
% w_perce_m = perce(X_t_m, y_m, w_ini);
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %::::::::::::::Red neuronal multicapa:::::::::::::
% fprintf('clasificador con red neuronal multicapa... \n');
% P = [feat_a(1:4) feat_u(1:4) feat_s(1:4) feat_m(1:4)];
% target_a = zeros(4,nCentroids);
% target_u = zeros(4,nCentroids);
% target_s = zeros(4,nCentroids);
% target_m = zeros(4,nCentroids);
% for i=1:32
%     target_a(:,i) = [1 ; 0 ; 0 ; 0];
%     target_u(:,i) = [0 ; 1 ; 0 ; 0];
%     target_s(:,i) = [0 ; 0 ; 1 ; 0];
%     target_m(:,i) = [0 ; 0 ; 0 ; 1];
% end
% T = [target_a target_u target_s target_m];
% net = newff(P,T, [4 4]); 
% net.trainParam.epochs = 80;
% net = train(net,P,T);
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%
 








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
feat_test_a(5,:) = 1;

%UUUUUUUUUUUUUU
vq_test_u = vq_from_wav(t_u, nCentroids_test, false);
feat_test_u = feat_from_lpc(vq_test_u,nCentroids_test);
feat_test_u(5,:) = 1;

%SSSSSSSSSSSSSSS
vq_test_s = vq_from_wav(t_s, nCentroids_test, false);
feat_test_s = feat_from_lpc(vq_test_s,nCentroids_test);
feat_test_s(5,:) = 1;

%MMMMMMMMMMMMMMM
vq_test_m = vq_from_wav(t_m, nCentroids_test, false);
feat_test_m = feat_from_lpc(vq_test_m,nCentroids_test);
feat_test_m(5,:) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%evaluacion de la clasificacion
fprintf(' \n \n')
fprintf('::::::::evaluando con bayes:::::::: \n')
bayes_a = feat_test_a(1:4,:);
misclasify_bayes_a = 0;
for i=1:nCentroids_test
    eval_bayes_a(1) = gaussian_eval(mean_a', cov_a, bayes_a(:,i));
    eval_bayes_a(2) = gaussian_eval(mean_u', cov_u, bayes_a(:,i));
    eval_bayes_a(3) = gaussian_eval(mean_s', cov_s, bayes_a(:,i));
    eval_bayes_a(4) = gaussian_eval(mean_m', cov_m, bayes_a(:,i));
    [C inx_a] = max(eval_bayes_a);
    if inx_a ~= 1
        misclasify_bayes_a = misclasify_bayes_a + 1;
    end
end

bayes_u = feat_test_u(1:4,:);
misclasify_bayes_u = 0;
for i=1:nCentroids_test
    eval_bayes_u(1) = gaussian_eval(mean_a', cov_a, bayes_u(:,i));
    eval_bayes_u(2) = gaussian_eval(mean_u', cov_u, bayes_u(:,i));
    eval_bayes_u(3) = gaussian_eval(mean_s', cov_s, bayes_u(:,i));
    eval_bayes_u(4) = gaussian_eval(mean_m', cov_m, bayes_u(:,i));
    [C inx_u] = max(eval_bayes_u);;
    if inx_u ~= 2
        misclasify_bayes_u = misclasify_bayes_u + 1;
    end
end

bayes_s = feat_test_s(1:4,:);
misclasify_bayes_s = 0;
for i=1:nCentroids_test
    eval_bayes_s(1) = gaussian_eval(mean_a', cov_a, bayes_s(:,i));
    eval_bayes_s(2) = gaussian_eval(mean_u', cov_u, bayes_s(:,i));
    eval_bayes_s(3) = gaussian_eval(mean_s', cov_s, bayes_s(:,i));
    eval_bayes_s(4) = gaussian_eval(mean_m', cov_m, bayes_s(:,i));
    [C inx_s] = max(eval_bayes_s);
    if inx_s ~= 3
        misclasify_bayes_s = misclasify_bayes_s + 1;
    end
end

bayes_m = feat_test_m(1:4,:);
misclasify_bayes_m = 0;
for i=1:nCentroids_test
    eval_bayes_m(1) = gaussian_eval(mean_a', cov_a, bayes_m(:,i));
    eval_bayes_m(2) = gaussian_eval(mean_u', cov_u, bayes_m(:,i));
    eval_bayes_m(3) = gaussian_eval(mean_s', cov_s, bayes_m(:,i));
    eval_bayes_m(4) = gaussian_eval(mean_m', cov_m, bayes_m(:,i));
    [C inx_m] = max(eval_bayes_m);
    if inx_m ~= 4
        misclasify_bayes_m = misclasify_bayes_m + 1;
    end
end
stats_bayes = zeros(4,1);
stats_bayes(1) = misclasify_bayes_a/nCentroids_test *100;
stats_bayes(2) = misclasify_bayes_u/nCentroids_test *100;
stats_bayes(3) = misclasify_bayes_s/nCentroids_test *100;
stats_bayes(4) = misclasify_bayes_m/nCentroids_test *100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% fprintf(' \n \n')
% fprintf(':::evaluando K-vecinos con distancia euclidiana::: \n')
% z = [feat_a feat_u feat_s feat_m];
% v = [ones(1,nCentroids) 2*ones(1,nCentroids) 3*ones(1,nCentroids) 4*ones(1,nCentroids)];
% num_neighbors = 5;
% %%%%FAlta modificar para que regrese medididas de rendimiento o certeza
% k_neighbors_a = k_nn_classifier(z,v,num_neighbors, feat_test_a(1:3));
% k_neighbors_u = k_nn_classifier(z,v,num_neighbors, feat_test_u(1:3));
% k_neighbors_s = k_nn_classifier(z,v,num_neighbors, feat_test_s(1:3));
% k_neighbors_m = k_nn_classifier(z,v,num_neighbors, feat_test_m(1:3));
% 
% fprintf(['El archivo ' t_a ' ' ])
% if k_neighbors_a == 1
%     fprintf('se clasifica como una a \n')
% elseif k_neighbors_a == 2
%     fprintf('se clasifica como una u \n')
% elseif k_neighbors_a == 3
%     fprintf('se clasifica como una s \n')
% elseif k_neighbors_a == 4
%     fprintf('se clasifica como una m \n')
% end
% 
% fprintf(['El archivo ' t_u ' ' ])
% if k_neighbors_u == 1
%     fprintf('se detecta una a \n')
% elseif k_neighbors_u == 2
%     fprintf('se detecta una u \n')
% elseif k_neighbors_u == 3
%     fprintf('se detecta una s \n')
% elseif k_neighbors_u == 4
%     fprintf('se detecta una m \n')
% end
% 
% fprintf(['El archivo ' t_s ' ' ])
% if k_neighbors_s == 1
%     fprintf('se detecta una a \n')
% elseif k_neighbors_s == 2
%     fprintf('se detecta una u \n')
% elseif k_neighbors_s == 3
%     fprintf('se detecta una s \n')
% elseif k_neighbors_s == 4
%     fprintf('se detecta una m \n')
% end
% 
% fprintf(['El archivo ' t_m ' ' ])
% if k_neighbors_m == 1
%     fprintf('se clasifica como una a \n')
% elseif k_neighbors_m == 2
%     fprintf('se clasifica como una u \n')
% elseif k_neighbors_m == 3
%     fprintf('se clasifica como una s \n')
% elseif k_neighbors_m == 4
%     fprintf('se clasifica como una m \n')
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf(' \n \n')
% fprintf('::::::::evaluando con perceptrï¿½n:::::::: \n')
% g_s = dot(feat_test_s, w_perce_cons);
% if (g_s < 0)
%     fprintf(['el archivo ' t_s ' se detecta como S con g = ' num2str(g_s) ' \n'])
% else
%     fprintf(['el archivo ' t_s ' se detecta como M con g = ' num2str(g_s) ' \n'])
% end
% 
% g_m = dot(feat_test_m, w_perce_cons);
% if (g_m < 0)
%     fprintf(['el archivo ' t_m ' se detecta como S con g = ' num2str(g_m) ' \n'])
% else
%     fprintf(['el archivo ' t_m ' se detecta como M con g = ' num2str(g_m) ' \n'])
% end
% 
% g_a = dot(feat_test_a, w_perce_vocs);
% if (g_a < 0)
%     fprintf(['el archivo ' t_a ' se detecta como A con g = ' num2str(g_a) ' \n'])
% else
%     fprintf(['el archivo ' t_a ' se detecta como U con g = ' num2str(g_a) ' \n'])
% end
% 
% g_u = dot(feat_test_u, w_perce_vocs);
% if (g_u < 0)
%     fprintf(['el archivo ' t_u ' se detecta como A con g = ' num2str(g_u) ' \n'])
% else
%     fprintf(['el archivo ' t_u ' se detecta como U con g = ' num2str(g_u) ' \n'])
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf(' \n \n')
% fprintf('::::::::evaluando con suma de errores cuadraticos:::::::: \n')
% g_s = dot(feat_test_s, w_sumerrors_cons);
% if (g_s < 0)
%     fprintf(['el archivo ' t_s ' se detecta como S con g = ' num2str(g_s) ' \n'])
% else
%     fprintf(['el archivo ' t_s ' se detecta como M con g = ' num2str(g_s) ' \n'])
% end
% 
% g_m = dot(feat_test_m, w_sumerrors_cons);
% if (g_m < 0)
%     fprintf(['el archivo ' t_m ' se detecta como S con g = ' num2str(g_m) ' \n'])
% else
%     fprintf(['el archivo ' t_m ' se detecta como M con g = ' num2str(g_m) ' \n'])
% end
% 
% g_a = dot(feat_test_a, w_sumerrors_vocs);
% if (g_a < 0)
%     fprintf(['el archivo ' t_a ' se detecta como A con g = ' num2str(g_a) ' \n'])
% else
%     fprintf(['el archivo ' t_a ' se detecta como U con g = ' num2str(g_a) ' \n'])
% end
% 
% g_u = dot(feat_test_u, w_sumerrors_vocs);
% if (g_u < 0)
%     fprintf(['el archivo ' t_u ' se detecta como A con g = ' num2str(g_u) ' \n'])
% else
%     fprintf(['el archivo ' t_u ' se detecta como U con g = ' num2str(g_u) ' \n'])
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% fprintf(' \n \n')
% fprintf('::::::::evaluando con LMS:::::::: \n')
% g_s = dot(feat_test_s, w_lms_cons);
% if (g_s < 0)
%     fprintf(['el archivo ' t_s ' se detecta como S con g = ' num2str(g_s) ' \n'])
% else
%     fprintf(['el archivo ' t_s ' se detecta como M con g = ' num2str(g_s) ' \n'])
% end
% 
% g_m = dot(feat_test_m, w_lms_cons);
% if (g_m < 0)
%     fprintf(['el archivo ' t_m ' se detecta como S con g = ' num2str(g_m) ' \n'])
% else
%     fprintf(['el archivo ' t_m ' se detecta como M con g = ' num2str(g_m) ' \n'])
% end
% 
% g_a = dot(feat_test_a, w_lms_vocs);
% if (g_a < 0)
%     fprintf(['el archivo ' t_a ' se detecta como A con g = ' num2str(g_a) ' \n'])
% else
%     fprintf(['el archivo ' t_a ' se detecta como U con g = ' num2str(g_a) ' \n'])
% end
% 
% g_u = dot(feat_test_u, w_lms_vocs);
% if (g_u < 0)
%     fprintf(['el archivo ' t_u ' se detecta como A con g = ' num2str(g_u) ' \n'])
% else
%     fprintf(['el archivo ' t_u ' se detecta como U con g = ' num2str(g_u) ' \n'])
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% test_signal = feat_test_a;
% test_signal_name = t_a;
% g_s_a = zeros(1,4);
% fprintf(' \n \n')
% fprintf('::::::::evaluando con perceptrï¿½n 1 vs todos:::::::: \n')
% g_s_a(1) = dot(test_signal, w_perce_a);
% if (g_s_a(1) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como A con g = ' num2str(g_s_a(1)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de A con g = ' num2str(g_s_a(1)) ' \n'])
% end
% g_s_a(2) = dot(test_signal, w_perce_u);
% if (g_s_a(2) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como U con g = ' num2str(g_s_a(2)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de U con g = ' num2str(g_s_a(2)) ' \n'])
% end
% g_s_a(3) = dot(test_signal, w_perce_s);
% if (g_s_a(3) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como S con g = ' num2str(g_s_a(3)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de S con g = ' num2str(g_s_a(3)) ' \n'])
% end
% g_s_a(4) = dot(test_signal, w_perce_m);
% if (g_s_a(4) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como M con g = ' num2str(g_s_a(4)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de M con g = ' num2str(g_s_a(4)) ' \n'])
% end
% 
% fprintf(' \n')
% test_signal = feat_test_u;
% test_signal_name = t_u;
% g_s_u = zeros(1,4);
% g_s_u(1) = dot(test_signal, w_perce_a);
% if (g_s_u(1) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como A con g = ' num2str(g_s_u(1)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de A con g = ' num2str(g_s_u(1)) ' \n'])
% end
% g_s_u(2) = dot(test_signal, w_perce_u);
% if (g_s_u(2) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como U con g = ' num2str(g_s_u(2)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de U con g = ' num2str(g_s_u(2)) ' \n'])
% end
% g_s_u(3) = dot(test_signal, w_perce_s);
% if (g_s_u(3) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como S con g = ' num2str(g_s_u(3)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de S con g = ' num2str(g_s_u(3)) ' \n'])
% end
% g_s_u(4) = dot(test_signal, w_perce_m);
% if (g_s_u(4) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como M con g = ' num2str(g_s_u(4)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de M con g = ' num2str(g_s_u(4)) ' \n'])
% end
% 
% 
% fprintf(' \n')
% test_signal = feat_test_s;
% test_signal_name = t_s;
% g_s_s = zeros(1,4);
% g_s_s(1) = dot(test_signal, w_perce_a);
% if (g_s_s(1) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como A con g = ' num2str(g_s_s(1)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de A con g = ' num2str(g_s_s(1)) ' \n'])
% end
% g_s_s(2) = dot(test_signal, w_perce_u);
% if (g_s_s(2) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como U con g = ' num2str(g_s_s(2)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de U con g = ' num2str(g_s_s(2)) ' \n'])
% end
% g_s_s(3) = dot(test_signal, w_perce_s);
% if (g_s_s(3) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como S con g = ' num2str(g_s_s(3)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de S con g = ' num2str(g_s_s(3)) ' \n'])
% end
% g_s_s(4) = dot(test_signal, w_perce_m);
% if (g_s_s(4) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como M con g = ' num2str(g_s_s(4)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de M con g = ' num2str(g_s_s(4)) ' \n'])
% end
% 
% 
% fprintf(' \n')
% test_signal = feat_test_m;
% test_signal_name = t_m;
% g_s_m = zeros(1,4);
% g_s_m(1) = dot(test_signal, w_perce_a);
% if (g_s_m(1) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como A con g = ' num2str(g_s_m(1)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de A con g = ' num2str(g_s_m(1)) ' \n'])
% end
% g_s_m(2) = dot(test_signal, w_perce_u);
% if (g_s_m(2) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como U con g = ' num2str(g_s_m(2)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de U con g = ' num2str(g_s_m(2)) ' \n'])
% end
% g_s_m(3) = dot(test_signal, w_perce_s);
% if (g_s_m(3) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como S con g = ' num2str(g_s_m(3)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de S con g = ' num2str(g_s_m(3)) ' \n'])
% end
% g_s_m(4) = dot(test_signal, w_perce_m);
% if (g_s_m(4) > 0)
%     fprintf(['el archivo ' test_signal_name ' se detecta como M con g = ' num2str(g_s_m(4)) ' \n'])
% else
%     fprintf(['el archivo ' test_signal_name ' se detecta como distinto de M con g = ' num2str(g_s_m(4)) ' \n'])
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %pruebas de red neuronal
% classes = ['A';'U';'S';'M'];
% 
% out_a = sim(net,feat_test_a(1:3,:));
% [n class] = max(out_a);
% fprintf(['el archivo de prueba A se detectó como ' classes(class) ' \n'] )
% 
% out_u = sim(net,feat_test_u(1:3,:));
% [n class] = max(out_u);
% fprintf(['el archivo de prueba U se detectó como ' classes(class) ' \n'] )
% 
% out_s = sim(net,feat_test_s(1:3,:));
% [n class] = max(out_s);
% fprintf(['el archivo de prueba S se detectó como ' classes(class) ' \n'] )
% 
% out_m = sim(net,feat_test_m(1:3,:));
% [n class] = max(out_m);
% fprintf(['el archivo de prueba M se detectó como ' classes(class) ' \n'] )
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%graficacion 
figure (1)
hold all
plot3(feat_a(4,:), feat_a(2,:), feat_a(3,:), 'bo');
%plot3(feat_i(1,:), feat_i(2,:), feat_i(3,:), 'ro')
plot3(feat_u(4,:), feat_u(2,:), feat_u(3,:), 'go');
%plot3(feat_e(1,:), feat_e(2,:), feat_e(3,:), 'co')
%plot3(feat_o(1,:), feat_o(2,:), feat_o(3,:), 'ko')

plot3(feat_test_a(4,:), feat_test_a(2,:), feat_test_a(3,:), 'b*');
plot3(feat_test_u(4,:), feat_test_u(2,:), feat_test_u(3,:), 'g*');
title('Features: Azul = a. Verde = u.');
hold off


figure (2)
hold all
plot3(feat_s(4,:), feat_s(2,:), feat_s(3,:), 'k+');
plot3(feat_m(4,:), feat_m(2,:), feat_m(3,:), 'r+');

plot3(feat_test_s(4,:), feat_test_s(2,:), feat_test_s(3,:), 'k*');
plot3(feat_test_m(4,:), feat_test_m(2,:), feat_test_m(3,:), 'r*');
title('Features: Negro = s. Rojo = m.');
hold off

%resultados de bayes
figure (3)
hold all
stem(1, stats_bayes(1), 'b','LineWidth',6);
stem(2, stats_bayes(2), 'g','LineWidth',6);
stem(3, stats_bayes(3), 'k','LineWidth',6);
stem(4, stats_bayes(4), 'r','LineWidth',6);
title('Bayes misclassified: Azul = a. Verde = u. Negro = s. Rojo = m.');
hold off
% 
% figure (4)
% hold all
% plot3(feat_a(1,:), feat_a(2,:), feat_a(3,:), 'bo');
% plot3(feat_u(1,:), feat_u(2,:), feat_u(3,:), 'go');
% plot3(feat_test_a(1,1), feat_test_a(2,1), feat_test_a(3,1), 'b*');
% plot3(feat_test_u(1,1), feat_test_u(2,1), feat_test_u(3,1), 'g*');
% 
% plot3(feat_s(1,:), feat_s(2,:), feat_s(3,:), 'k+');
% plot3(feat_m(1,:), feat_m(2,:), feat_m(3,:), 'r+');
% plot3(feat_test_s(1,1), feat_test_s(2,1), feat_test_s(3,1), 'k*');
% plot3(feat_test_m(1,1), feat_test_m(2,1), feat_test_m(3,1), 'r*');
% title('Features: Negro = s. Rojo = m. Azul = a. Verde = u.');
% hold off
% 
% figure (5)
% hold all
% title('Negro = perceptron. Rojo = Suma de errores. Azul = LMS');
% plot(1:4, w_perce_vocs, 'ko')
% plot(1:4, w_sumerrors_vocs, 'ro')
% plot(1:4, w_lms_vocs, 'bo')
% hold off
% 
% figure (6)
% hold all
% title('Negro = perceptron. Rojo = Suma de errores. Azul = LMS');
% plot(1:4, w_perce_cons, 'ko')
% plot(1:4, w_sumerrors_cons, 'ro')
% plot(1:4, w_lms_cons, 'bo')
% hold off
% 
% 
% figure (7)
% hold all
% title('valores g de fonema "a".   1 = a, 2 = u, 3 = s, 4 = m');
% stem(1:4, g_s_a, 'go','LineWidth',6)
% hold off
% 
% figure (8)
% hold all
% title('valores g de fonema "u".   1 = a, 2 = u, 3 = s, 4 = m');
% stem(1:4, g_s_u, 'bo','LineWidth',6)
% hold off
% 
% figure (9)
% hold all
% title('valores g de fonema "s".   1 = a, 2 = u, 3 = s, 4 = m');
% stem(1:4, g_s_s, 'ko','LineWidth',6)
% hold off
% 
% figure (10)
% hold all
% title('valores g de fonema "m".   1 = a, 2 = u, 3 = s, 4 = m');
% stem(1:4, g_s_m, 'ro','LineWidth',6)
% hold off
% 
