% Рисует целевое множество в заданном прямоугольнике
function filledPlt = drawFinishSet(x1, y1, x2, y2, mode)
    global gMat gVec;
    % По умолчанию считаем, что x1, y1 - положительные
    if nargin < 4
        x2 = x1;
        y2 = y1;
        x1 = -x1;
        y1 = -y1;
    end
    if nargin < 5
        mode = 'default';
    end
    G = [gMat; -1 0; 1 0; 0 -1; 0 1];
    g = [gVec; x1; -x2; y1; -y2];
    
    exts = finishExt(G, g);
    k = convhull(exts(:, 1), exts(:, 2));
    if strcmp(mode, 'as_line')
        filledPlt = plot(exts(k, 1), exts(k, 2), 'r');
    else
        filledPlt = fill(exts(k, 1), exts(k, 2), 'r');
    end
end

