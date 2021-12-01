% Demo of a wave simulation in which a sinusoidal wave is reflected off a
% parabola

function WaveDemo()
    Size = [100, 100]; % size of matrix
    Pos = zeros(Size); % value (wave height) of the field at each point
    Vel = zeros(Size); % time derivative of Pos
    K = ones(Size); % speed of propagation
    Buf = 10; % damping buffer width
    Damp = DampedBorder(Size, Buf); % damping coefficient
    Step = 0.1; % time step
    Duration = 1000; % duration of simulation
    Frequency = 0.1; % frequency of wave
    
    % Generating parabola: K on the concave side of the parabola is 0, and
    % is 1 everywhere else.
    Vertex = [50, 30]; % vertex of parabola
    Coef = 0.02; % Coefficient in parabola equation
    Focus = [Vertex(1), round(Vertex(2) + 1 / (4 * Coef))]; % focus of parabola
    x = 1:Size(2);
    y = 1:Size(1);
    Parabola = Coef * ((x - Vertex(1)).^2) + Vertex(2); % vector of parabola height
    [~, Y] = meshgrid(x,y);
    K(Y < Parabola) = 0; % K below the parabola is 0
    
    % You can also read the matrices from images for easy creation of
    % shapes with your favourite program. Black means 0 and white means 1.
    % K = im2double(rgb2gray(imread('K.png')));
    % Damp = im2double(rgb2gray(imread('Damp.png')));
    
    % Force function
    function Force = ForceFunc(Time, Size, WavePos, Frequency)
        Force = zeros(Size);
        Force(WavePos(2), WavePos(1)) = sin(1 * pi * Frequency * Time);
    end

    % Drawing it
    SurfX = Buf:Size(1)-Buf;
    SurfY = Buf:Size(2)-Buf;
    Surf = surf(SurfX, SurfY, Pos(Buf:end-Buf, Buf:end-Buf));
    
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    hold on;
    z = ones(size(SurfX)) * 0.1;
    plot3(SurfX, Parabola(SurfY), z, 'r-');
    hold off;

    
    % Main loop
    for Time = 0:Step:Duration
        [Pos, Vel] = StepWave(Pos, Vel, K, Damp, Step, Time,...
                              @ForceFunc, {Size, Focus, Frequency});
        Surf.ZData = Pos(Buf:end-Buf, Buf:end-Buf);
        drawnow();
    end
end