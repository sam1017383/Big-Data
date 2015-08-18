%N l-dimensional vectors, mean m, covariance matrix S
%--> mvnrnd

randn('state',0);
Nm = 100;
m1=[-5; 0];
s1 = eye(2);
m2=[5 0];
N = zeros(5,2);
X1 = mvnrnd(m1, s1, 5)