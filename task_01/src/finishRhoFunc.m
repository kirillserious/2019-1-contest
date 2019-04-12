function rho = finishRhoFunc(gMat, gVec)
    options = optimoptions('fmincon','Display','off','Algorithm','sqp'); 
    rho = supportLebesgue(@(x) max(gMat * transpose(x) + gVec), options);
end

function rho = supportLebesgue (func, opts)
    rho = @(direction) suppfunc(direction, func, opts);

    function [c, ceq] = myFunc(func, x)
        ceq = [];
        c = func(x);
    end

    function [val,x]=suppfunc(direction, func, opts)
        x0Vec = zeros(size(direction));
        scalar = @(x) -sum(x.*direction);
        [x,val] = fmincon( @(x) scalar(x), x0Vec, [], [], [], [], [], [], @(x) myFunc(func, x), opts);
        val = -val;
    end
end

