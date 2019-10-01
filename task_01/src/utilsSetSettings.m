function utilsSetSettings()
    % Прочие параметры приложения
    global startT MaxDeltaT SplitNumber Delta PsiPlace;
    
    MaxDeltaT = 1;
    SplitNumber = 10;
    Delta = pi;
    PsiPlace = 0;    
    
    global MostOptimalTime MostOptimalManagement ...
        MostOptimalTimeManagement MostOptimalLine MostOptimalTimeLine ...
        MostOptimalLastPsi;
    
    MostOptimalTime = startT + MaxDeltaT;
    MostOptimalManagement = 0;
    MostOptimalTimeManagement = 0;
    MostOptimalLine = 0;
    MostOptimalTimeLine = 0;
    MostOptimalLastPsi = 0;
    
    global SpecifyIsFirstUsage SpecifyFigure SpecifiedStartPsis ...
        SpecifyIsOptimalExist;
    SpecifyIsOptimalExist = 0;
    SpecifyIsFirstUsage = 1;
    SpecifiedStartPsis = [0 0];
end

