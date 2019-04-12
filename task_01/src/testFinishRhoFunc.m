gMat = [1, 2; -1, 3; -4, -2; 2, -2];
gVec = [1; 2; -3; -4];

figure;
drawingRho(finishRhoFunc(gMat, gVec), 100);
axis([-1000, 1000, -1000, 1000])