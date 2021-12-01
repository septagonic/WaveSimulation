% Returns a matrix of damping values.
% Damp is a matrix of zeros of size Size surrounded by a borer of width
% Width with increasing values approaching the edge of the matrix. This damping
% at the edges minimises wave reflections from the edges of the simulation,
% allowing one to approximate an infinitely large space.
    % Damp: matrix of damping value at each point in space
    % Size: size of matrix [numRows, numCols]
    % Width: width of damped border

function Damp = DampedBorder(Size, Width)
    Damp = zeros(Size);
    
    for i = 1:Width
        DampHere = 0.01 * (Width - i + 1);
        Damp(i, i:end-i+1) = DampHere;
        Damp(end-i+1, i:end-i+1) = DampHere;
        Damp(i:end-i+1, i) = DampHere;
        Damp(i:end-i+1, end-i+1) = DampHere;
    end
end