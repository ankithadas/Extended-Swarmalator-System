function [index] = phaseSeperation(numbers)

    % Location based clustering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    X = reshape(numbers,[],3);
    phase = X(:,3);
%     X(:,3) = 10*X(:,3);
% 
%     avgSil = zeros(1,6);
%     for i = 1:6
%         clust = kmeans(X,i);
%         s = silhouette(X,clust);
%         avgSil(i) = mean(s);
%     end
%     % Finding the ideal number of clusters
%     [~,in] = max(avgSil);
%     [indexLoc,C] = kmeans(X,in);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Phase based clustering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bins = [];
    edges = linspace(min(phase),max(phase), 15);
    for i = 1:length(edges)-1
        if i == 1
            data = find(phase >= edges(i) & phase <= edges(i+1));
        else
            data = find(phase > edges(i) & phase <= edges(i+1));
        end
        if ~isempty(data)
            bins = [bins; [mean(phase(data)), numel(data),min(phase(data)),max(phase(data))]];
        end
    end
    bins = sortrows(bins,1,'ascend');
    diffMeans = diff(bins(:,1));
    for i = 1:length(diffMeans)
        if diffMeans(i) < 0.15
            % Correct the new mean of the phase 
            bins(i,1) = (bins(i,1)*bins(i,2) + bins(i+1,1)*bins(i+1,2))/(bins(i,2) + bins(i+1,2));
            % Change the number of particles in the bin
            bins(i,2) = bins(i,2) + bins(i+1,2);
            % Change the min and max of bins
            bins(i,3) = min(bins(i:i+1,3));  %% Is this necessary ?
            bins(i,4) = max(bins(i:i+1,4));
            % Change the next bin to nan for removal 
            bins(i+1,1) = nan;
        end
    end
    bins(any(isnan(bins),2),:) = [];
    bins = sortrows(bins,2,'descend');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Indexing the clusters from phase based clustering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    indexPh = zeros(1,length(phase));
    for i = 1:size(bins,1)
        ind = find(phase >= bins(i,3) & phase <= bins(i,4));
        indexPh(ind) = i;
    end
    % Combining the resluts from the both clustering methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % No idea how to combine results 
    % What if the clustering reults are different 
    % what if there are clashes in phase based clustering 
    % How to combine k means and phased based clustering

    %% Testing 
    % figure
    % gscatter(X(:,1),X(:,2),idx,'bmgk');


    %Return the final indexing
    %index = indexLoc;
    index = indexPh;
end

% Fixed needed-
% Combine indexing and clusting from the 2 methods 
% Possibly add another method for indexing