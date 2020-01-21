function [avgDis,stdSwarm] = averageDistance(points,N)
    x = points(1:N);
    y = points(N+1:2*N);
    dt = delaunayTriangulation(x',y');
    figure(7), triplot(dt);
    edges = dt.edges;
    edgeLengths = zeros(size(edges,1),1);
    for i = 1:size(edges,1)
        edgePoints = dt.Points(edges(i,:),:);
        edgeLen = vecnorm(diff(edgePoints),2,2);
        edgeLengths(i) = edgeLen;
    end
    avgDis = mean(edgeLengths);
    stdSwarm = std(edgeLengths);
    hold off
end
