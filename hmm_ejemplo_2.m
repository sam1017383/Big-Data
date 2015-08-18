
TRANSICIONES = [.25 .7 .05; .05 .25 .7; .05 .05 .9]
EMISIONES = [.95 .05; .05 .95; .95 .05]


% Teniendo el modelo probabilistico podemos simular secuencias que siguen
% el modelo
[observaciones,estados] = hmmgenerate(10,TRANSICIONES,EMISIONES)

% Para conocer la probalidad de que el modelo reproduzca la secuencia de
% observaciones se usa hmmdecode

[prob_con_tk, prob_log] = hmmdecode(observaciones, TRANSICIONES, EMISIONES)

% Si modificamos la secuencia de observaciones de manera arbitraria, las
% observaciones en lo general no se apegan al modelo descrito, por lo que
% su probabilidad baja

observaciones_mix = observaciones(randperm(length(observaciones)))

[prob_con_tk_mix, prob_log_mix] = hmmdecode(observaciones_mix, TRANSICIONES, EMISIONES)

