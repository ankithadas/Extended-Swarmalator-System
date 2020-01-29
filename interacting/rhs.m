function ydot=rhs(t,y,c,m) 
    global k;
    ydot_1 = y(2); 
    ydot_2 = -(c/m)*y(2) - (k/m)*y(1) + force(t)/m; 
    ydot = [ydot_1 ; ydot_2 ];
    if t >= 50
        P = 1;
    end
end 

function f=force(t) 
    P = 100;   % force amplitude 
    %f=P*sin(omega*t); 
    
    f=10;  %unit step 
    
    %if t<eps     %impulse 
    %   f=1 
    %else 
    %    f=0; 
    %end 
    %f=P*t;  %ramp input 
end 