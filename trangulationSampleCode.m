x = [ 16 16 16 17 18 19 19 20 21 21 23 23 23 ]
y = [ 151 369 397 208 84 93 177 326 112 243 164 213 390 ]
DT = delaunayTriangulation(x',y')
figure, triplot(DT), hold on
edges = DT.edges;
edgeLens = zeros(size(edges,1),1);
for i = 1:size(edges,1)
    thisEdgePts = DT.Points(edges(i,:),:);
    edgeCpt = mean(thisEdgePts,1);
    edgeLen = sqrt(sum(diff(thisEdgePts,[],1).^2));
    edgeLens(i) = edgeLen;
    text(edgeCpt(1),edgeCpt(2),sprintf('%0.1f',edgeLen),'HorizontalAlignment','center')
end
outerBoundaryPerim = sum(edgeLens(ismember(DT.edges, DT.freeBoundary,'rows')))
for i = 1:size(DT.ConnectivityList,1)
    thisVerts = DT.Points(DT.ConnectivityList(i,:),:);
    faceEdgeLens = sqrt(sum(diff(thisVerts([1:end 1],:),[],1).^2,2));
    facePerim = sum(faceEdgeLens);
    faceCpt = mean(thisVerts,1);
    text(faceCpt(1),faceCpt(2), sprintf('%0.1f',facePerim),'Color','r')
end