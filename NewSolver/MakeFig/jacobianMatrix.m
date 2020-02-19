% function calculates the phase jacobian matrix
function J = jacobianMatrix(y,N,K,gamma1,gamma2)
    J = zeros(N,N);
    pts = reshape(y(1:2*N),N,2);
    Y = 1./internal.stats.pdistmex(pts','euc',[]);
    invDis = zeros(N,N);
    invDis(tril(true(N),-1)) = Y;
    invDis = invDis + invDis';
    %invDis = invDis + eye(N);
    phi = y(2*N + 1:end);
    for i = 1:N
        for j = 1:N
            if i == j
                s = 0;
                for k = 1:N
                    s = s - invDis(i,k)*(gamma1*cos(phi(k) - phi(i)) + 2* gamma2 * cos(2*(phi(k) - phi(i))));
                end
                J(i,j) = s;
            else
                J(i,j) = invDis(i,j)*(gamma1*cos(phi(j) - phi(i)) + 2*gamma2*cos(2*(phi(j) - phi(i))));
            end
        end
    end
    J = J * K/N;
end
