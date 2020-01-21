classdef Swarmalator
    properties (GetAccess='public', SetAccess='public')
        position
        velocity
        phase
    end
    methods
        function inverseDistance = getInverseDis(objects)
            global N
            inverseDistance = vecnorm(repmat(position,1,N)- [objects.position],2,1);
        end
        function objects = Swarmalator(m,n)
            if nargin ~= 0
                objects(m,n) = objects;
            end

        end

    end
end