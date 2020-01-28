function dy = swarmalator_matrixform(t,y,dim,N,w,K,J,gamma1,gamma2)
    dy=zeros((dim+1)*N,1);
    %%% Calculate each of the system's N equations

    % Background flow
    v = zeros(N,dim);

    % The first entries of y are the spacial coordinates, all x's then all y's
    % then all z's etc
    pts = reshape(y(1:dim*N),N,dim);
    %Make a NxNxdim matrix with the differences between points
    % PTS = zeros(N,N,dim);
    % for i=1:N
    %     PTS(i,:,:) = pts;
    % end
    PTS = permute(repmat(pts,1,1,N),[3 1 2]);
    PTSdiff = PTS - permute(PTS, [2 1 3]); %permute is like transpose
    % %PTSdiff(i,j,:) is equal to pts(j,:) - pts(i,:)
    % %make it into a NxN cell array, with the i,j cell being pts(j,:) - pts(i,:)
    % PTSdiff2 = mat2cell(PTSdiff,ones(N,1),ones(N,1),[dim]); 
    % % apply norm over all the cells
    % normdiff = cellfun(@(x) norm(reshape(x,dim,1)), PTSdiff2);
    % % set diagonal to 1's to avoid divide by zero errors
    % normdiff = normdiff + eye(N);
    % % adjacency matrix for the oscillator dynamics
    % A_osc = 1./normdiff;

    %invDis = zeros(N,N);
    % for i = 1:N 
    % %     for j = i:N 
    % %         invDis(i,j) = norm(pts(i,:)- pts(j,:)); %% could optimize this section more for speed 
    % %         invDis(j,i) = invDis(i,j);
    % %     end
    %     invDis(i,:) = vecnorm(repmat(pts(i,:),N,1) - pts(:,:),2,2);
    % end
    % invDis = invDis + eye(N);
    % invDis = 1./invDis;


    % invDis = squareform(internal.stats.pdistmex(pts','euc',[]));
    % invDis = 1./(invDis + eye(N));

    Y = 1./internal.stats.pdistmex(pts','euc',[]);
    invDis = zeros(N,N);
    invDis(tril(true(N),-1)) = Y;
    invDis = invDis + invDis';
    invDis = invDis + eye(N);

    % get the oscillator phases from y
    phi = y(dim*N + 1:end);
    % % Make NxN matrix with phi as a repeated row vector
    % PHI = repmat(phi',N,1);
    % % Differences between phases
    % PHIdiff = PHI - PHI';
    %PHIdiff(i,j) equals phi(j) - phi(i)
    PHIdiff = phi' - phi;

    % adjacency matrix for the position dynamics
    A_pos = (1 + J*cos(PHIdiff)).*invDis - invDis.^2;

    % phase velocities
    dy(dim*N + 1:(dim+1)*N) = w' + (K/N)*sum(invDis.*(gamma1*sin(PHIdiff) + gamma2*sin(2*PHIdiff)),2);

    % position velocitites
    v_pos = v + (1/N)*reshape(sum(A_pos.*PTSdiff,2),N,dim);

    dy(1:dim*N) = reshape(v_pos,dim*N,1);
end