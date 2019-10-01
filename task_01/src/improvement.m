% Осуществляет улучшение (глобальное или локальное)

function improvement(mode)
    if nargin < 1
        mode = 'local';
    end
    
    global SplitNumber Delta;
    
    if strcmp(mode, 'local')
        Delta = Delta / SplitNumber;
    else
        SplitNumber = 2 * SplitNumber;
    end
end

