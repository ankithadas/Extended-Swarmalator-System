function dy = simpleSolver(~,y,dataArray)

    % First 2 data points are the clusters,
    % The rest are rogues
    N = dataArray(1);
    K = dataArray(2);
    J = dataArray(3);
    gamma1 = dataArray(4);
    gamma2 = dataArray(5);
    na = dataArray(6);
    nb = dataArray(7);

    dy = zeros(3*N,1);
    pts = reshape(y(1:2*N),[],2);
    
    PTS = permute(repmat(pts,1,1,N),[3 1 2]);
    PTSdiff = PTS - permute(PTS, [2 1 3]); 

    PTSdiff(1,:,:) = na*PTSdiff(1,:,:);
    PTSdiff(2,:,:) = nb*PTSdiff(2,:,:);

    PTSdiff(:,1,:) = na*PTSdiff(:,1,:);
    PTSdiff(:,2,:) = PTSdiff(:,1,:);

    Y = 1./internal.stats.pdistmex(pts','euc',[]);
    invDis = zeros(N,N);
    invDis(tril(true(N),-1)) = Y;
    invDis = invDis + invDis';
    invDis = invDis + eye(N);

    phi = y(dim*N + 1:end);

    PHIdiff = phi' - phi;
    A_pos = (1+J*cos(PHIdiff)).*invDis - invDis.^2;

    dy(2*N + 1:end) = (K/N) * sum(invDis.*(gamma1*sin(PHIdiff) + gamma2*sin(2* PHIdiff)),2);

    vel = 1/N * squeeze(sum(A_pos.* PTSdiff,2));
    dy(1:2*N) = reshape(vel,1,[]);
end


