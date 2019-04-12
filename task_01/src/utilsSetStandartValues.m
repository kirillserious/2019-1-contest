% Задаёт стандартные параметры для задачи
function utilsSetStandartValues()
    global a; 
    global b;
    global c;
    global r;
    global p;
    global gMat;
    global gVec;
    global a11Str;
    global a12Str;
    global a21Str;
    global a22Str;
    global b11Str;
    global b12Str;
    global b21Str;
    global b22Str;
    global startT;
    
    % Переменные для матриц
    a11Str = '-1';
    a12Str = '-2';
    a21Str = '3';
    a22Str = '-4';
    b11Str = '1';
    b12Str = '2*sin(t)';
    b21Str = '3';
    b22Str = '4';
    % Время
    startT = 0;
    % Переменные для множества управлений
    a = 4;
    b = 7;
    c = 2;
    % Переменные для начального множества
    r = 4;
    p = [-3, -7];
    % Переменные для конечного множества
    gMat = [0.3, 4; -0.4, -2; 0.2, -2];
    gVec = [-10; -3; -4];
    
    utilsSetSettings();
    
end

