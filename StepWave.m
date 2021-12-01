% StepWave returns the next frame of Pos and Vel after a time setp Step.
% An RK4 numerical integrator is used to solve the wave equation.
    % Pos: matrix of value of the field at each point
    % Vel: matrix of derivative of value of the field at each point
    % K: propagation speed coefficient matrix
    % Damp: damping coefficient matrix
    % Step: time-step size
    % Time: time (optional)
    % Force: function handle to a function which accepts Time and ForceInfo
    %        as arguments and returns the force matrix applied to Pos
    %        (optional)
    % ForceInfo: cell array of other arguments which should be passed to
    %            Force (optional)

function [Pos, Vel] = StepWave(Pos, Vel, K, Damp, Step, Time, Force, ForceInfo)

    % Deriv returns the derivative of Pos and Vel, Vel and Acc respectively
        % Pos: matrix of the value of the field at each point
        % Vel: matrix of the rate of change of the field at each point
        % Acc: matrix of the second derivative of the field at each point
        % Time: time variable
    
    function [Vel, Acc] = Deriv(Pos, Vel, Time)
        Acc = zeros(size(Pos));
        % Acceleration is proportional to the average difference between
        % the position of the surrounding points
        Acc(2:end-1, 2:end-1) = (Pos(3:end, 2:end-1) + Pos(1:end-2, 2:end-1) + Pos(2:end-1, 3:end)...
                                + Pos(2:end-1, 1:end-2)) / 4 - Pos(2:end-1, 2:end-1);
        
        % Its convenient to create waves by just setting the Pos of a point
        % to a sin wave, but if one wants better physical accuracy, they
        % should pass a Force function which returns a force matrix so it
        % can be properly taken into account for the numerical integration
        if exist('Force', 'var')
            if exist('ForceInfo', 'var')
                Acc = Acc + Force(Time, ForceInfo{:});
            else
                Acc = Acc + Force(Time);
            end
        end
        
        Acc = Acc .* K - Vel .* Damp; % Applying scaling and damping
    end

    if ~exist('Time', 'var')
        Time = 0;
    end

    % Numerically integrating using an RK4 integrator
    [Vel1, Acc1] = Deriv(Pos, Vel, Time);
    [Vel2, Acc2] = Deriv(Pos + Step/2 * Vel1, Vel + Step/2 * Acc1, Time + Step/2);
    [Vel3, Acc3] = Deriv(Pos + Step/2 * Vel2, Vel + Step/2 * Acc2, Time + Step/2);
    [Vel4, Acc4] = Deriv(Pos + Step   * Vel3, Vel + Step   * Acc3, Time + Step);

    Pos = Pos + Step/6 * (Vel1 + 2*Vel2 + 2*Vel3 + Vel4);
    Vel = Vel + Step/6 * (Acc1 + 2*Acc2 + 2*Acc3 + Acc4);
end