function [value,isterminal,direction] = eventFunction(t,y)
    persistent P 
    if nargin == 0
        P = 1;
        return 
    end
    drawnow;
    P = 1;
    if isempty(P)
        value = 0;
        isterminal = 0;
        direction = 0;
    else
        value = 0;
        isterminal = 1;
        direction = 0;
        P = [];
    end
end
