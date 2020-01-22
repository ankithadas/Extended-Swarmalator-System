function pos = pointsInC(centerX,centerY,R,count)
    r = R*sqrt(rand(count,1));
    theta = rand(count,1)*2*pi;

    x = centerX + r.*cos(theta);
    y = centerY + r.*sin(theta);

    pos = [x,y];
end

