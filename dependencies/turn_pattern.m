function T = turn_pattern(theta1, theta2, threshold)
% no turn, turn

turn = theta2 - theta1; 

if turn > 180
    turn = turn-360;
elseif turn < -180
    turn = turn+360;
end

if abs(turn) > threshold
    T = 1;
else
    T = 0;
end
    
end