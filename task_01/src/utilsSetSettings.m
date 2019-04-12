function utilsSetSettings()
    % Прочие параметры приложения
    global startT MaxDeltaT SplitNumber Delta PsiPlace;
    
    MaxDeltaT = 1;
    SplitNumber = 5;
    Delta = pi;
    PsiPlace = 0;    
    
    global MostOptimalTime MostOptimalManagement ...
        MostOptimalTimeManagement MostOptimalLine MostOptimalTimeLine;
    
    MostOptimalTime = startT + MaxDeltaT;
    MostOptimalManagement = 0;
    MostOptimalTimeManagement = 0;
    MostOptimalLine = 0;
    MostOptimalTimeLine = 0;
end

