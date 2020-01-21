function invDis = invsqdis(pts,N)

    invDis = zeros(N,N);
    for i = 1:N 
        for j = 1:N 
            invDis(i,j) = norm(pts(i,:)- pts(j,:));
        end
    end
    invDis = invDis + eye(N);
    invDis = 1./invDis;

end
