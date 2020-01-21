% rng('default') % For reproducibility
% X = [y_full(end,1:200)',y_full(end,201:400)'];
% [idx,C] = kmeans(X,3);
% 
% figure
% gscatter(X(:,1),X(:,2),idx,'bgm')
% hold on
% plot(C(:,1),C(:,2),'kx')
% legend('Cluster 1','Cluster 2','Cluster 3','Cluster Centroid')

X = reshape(y_full(end,:),[],3);
X(:,3) = 10*X(:,3);
avg = zeros(1,5);
for i = 1:6
    clust = kmeans(X,i);
    s = silhouette(X,clust);
    avg(i) = mean(s);
end
[~,in] = max(avg);
outputs = [outputs,in];

[idx,C] = kmeans(X,in);
figure(2)
gscatter(y_full(end,1:100),y_full(end,101:200),idx,'bmgk');

% Method 
% Using clustering algo find the clusters 
% Using K means find the index of each cluster 
% Mean Phase and standard deviation in each cluster 
% Find the centeroid of each cluster 
% Finally find inter cluster distance 

% Need to improve productivity 
% New task allocation and execution policies 
% Less distraction from 'TH'