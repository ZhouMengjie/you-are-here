function [R_,dist_] = Turn_filter(R_, dist_, turn, routes, m, threshold)
T_ = zeros(size(R_, 1), 1);
for i=1:size(R_, 1)
    idx1 = R_(i, m-1);
    idx2 = R_(i, m);
    theta1 = routes(idx1).gsv_yaw;
    theta2 = routes(idx2).gsv_yaw;
    if isempty(theta1) || isempty(theta2)
        T_(i) = 3;
    else
        T_(i) = turn_pattern(theta1, theta2, threshold);
    end
end 
k = find(T_ == turn);
R_ = R_(k,:);
dist_ = dist_(k,:);

end