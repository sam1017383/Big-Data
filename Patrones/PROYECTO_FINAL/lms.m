function w = lms(X, y, w_ini)
    [l,N] = size(X);
    rho = 0.9;
    w = w_ini;
    for i=1:N
        w = w + (rho/i)*(y(i) - X(:,i)'*w)*X(:,i);
    end