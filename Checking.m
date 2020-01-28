clear;
clc;
dim = 2;
N = 100;
pts = rand(100,2);
tic 
%Make a NxNxdim matrix with the differences between points
PTS = zeros(N,N,dim);
for i=1:N
    PTS(i,:,:) = pts;
end
PTSdiff = PTS - permute(PTS, [2 1 3]); %permute is like transpose
%PTSdiff(i,j,:) is equal to pts(j,:) - pts(i,:)
%make it into a NxN cell array, with the i,j cell being pts(j,:) - pts(i,:)
PTSdiff2 = mat2cell(PTSdiff,ones(N,1),ones(N,1),[dim]); 
% apply norm over all the cells
normdiff = cellfun(@(x) norm(reshape(x,dim,1)), PTSdiff2);
% set diagonal to 1's to avoid divide by zero errors
normdiff = normdiff + eye(N);
% adjacency matrix for the oscillator dynamics

A_osc = 1./normdiff;
toc

tic
invDis = zeros(N,N);
for i = 1:N 
    for j = i:N 
        invDis(i,j) = norm(pts(i,:)- pts(j,:));
        invDis(j,i) = invDis(i,j);
    end
end
invDis = invDis + eye(N);
invDis = 1./invDis;
toc

tic 
invDis2 = zeros(N,N);
for i = 1:N 
    invDis2(i,:) = vecnorm(repmat(pts(i,:),N,1) - pts(:,:),2,2);
end
invDis2 = invDis2 + eye(N);
invDis2 = 1./invDis2;
toc;

% Fastest code 
tic 
A=pdist(pts);
Y = 1./internal.stats.pdistmex(pts','euc',[]);
invDis3 = zeros(N,N);
invDis3(tril(true(N),-1)) = Y;
invDis3 = invDis3 + invDis3';
invDis3 = invDis3 + eye(N);
toc