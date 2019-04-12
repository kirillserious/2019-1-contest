function drawSet(rho, n)
    
    angle = linspace(0, 2*pi, n+1);
    direction = @(k)[cos(angle(k)), sin(angle(k))];
    
    internalPointsVec = zeros(2,n);
    externalPointsVec = zeros(2,n);
    
    for k = 1:n
        [val1, point] = rho(direction(k));
        [val2,  ~] = rho(direction(k+1));
        
        internalPointsVec(:,k) = point;
        externalPointsVec(:,k) = linsolve([direction(k); direction(k+1)], [val1; val2]); 
    end
    
    figure;
    grid on;
    hold on;
    plot([internalPointsVec(1,:),internalPointsVec(1,1)], [internalPointsVec(2,:),internalPointsVec(2,1)], '-x');
    plot([externalPointsVec(1,:),externalPointsVec(1,1)], [externalPointsVec(2,:),externalPointsVec(2,1)], '-x');
    legend('Internal hull','External hull');
    hold off;
end

