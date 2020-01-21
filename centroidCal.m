function [centroid,pos] = centroidCal(points,index)
    position = reshape(points, [] , 3);
    i = 1;
    centroid = [];
    pos = [];
    while any(index(:) == i)
        in = find(index == i)';
        x = mean(position(in,1));
        y = mean(position(in,2));
        centroid = [ centroid;[x,y]];
        pos = [pos,i];
        i = i + 1;
    end
end

