function utilsSetABSymb()
    global aMat;
    global bMat;
    
    global a11Str;
    global a12Str;
    global a21Str;
    global a22Str;
    global b11Str;
    global b12Str;
    global b21Str;
    global b22Str;

    aMat = eval(strcat('@(t) [', a11Str, ',', a12Str, ';', a21Str, ',', a22Str, ']'));
    bMat = eval(strcat('@(t) [', b11Str, ',', b12Str, ';', b21Str, ',', b22Str, ']'));
end

