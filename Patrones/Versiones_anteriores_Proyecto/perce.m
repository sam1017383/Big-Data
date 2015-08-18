function w=perce(X,y,w_ini)
    [l,N]=size(X);
    max_iter=10000; % Maximum allowable number of iterations
    rho=0.05; % Learning rate
    w=w_ini; % Initialization of the parameter vector
    iter=0; % Iteration counter
    mis_clas=N; % Number of misclassified vectors
    while (mis_clas>0) && (iter<max_iter)
        iter=iter+1;
        mis_clas=0;
        gradi=zeros(l,1);% Computation of the "gradient"
        % term
        for i=1:N
            if((X(:,i)'*w)*y(i)<0)
            mis_clas=mis_clas+1;
            gradi=gradi+rho*(-y(i)*X(:,i));
            end
        end
        w=w-rho*gradi; % Updating the parameter vector
    end