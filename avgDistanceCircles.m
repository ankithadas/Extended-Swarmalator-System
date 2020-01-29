function avgDist = avgDistanceCircles(distCircle,r1,r2)
    pos1 = pointsInC(0,0,r1,10^3);
    pos2 = pointsInC(0,distCircle,r2,10^3);
    Dis = pdist2(pos1,pos2);
    avgDist = mean2(Dis);
end
