function [avg,count] = phaseSeperation(numbers)

    % Location based clustering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    X = reshape(numbers,[],3);
    phase = X(:,3);
    X(:,3) = 10*X(:,3);

    avgSil = zeros(1,6);
    for i = 1:6
        clust = kmeans(X,i);
        s - silhouette(X,clust);
        avgSil(i) = mean(s);
    end
    % Finding the ideal number of clusters
    [~,in] = max(avgSil);
    [index,C] = kmeans(X,in);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Phase based clustering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bins = []
    edges = linspace(min(phase),max(phase), 40);
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
    for i = length(diffMeans)
        if diffMeans(i) < 0.1;
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
    bins = sortrows(bins,2,'descend');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Indexing the clusters from phase based clustering
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    






    % Combining the resluts from the both clustering methods
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% Testing 
    figure
    gscatter(X(:,1),X(:,2),idx,'bmgk');


    %Return the final indexing

end
    

