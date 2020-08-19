function [t, max_route_length] = RandomRoutes(R, routes, max_route_length_init)
% random choose a seed
max_route_length = 0;    
while max_route_length < max_route_length_init
    flag = 0;
    loop = 0;
    t = [];
    idx = randi(size(R, 1));
    t(1) = R(idx);
    for m=1:(max_route_length_init-1)
        neighbor = routes(t(m)).neighbor;
        if isempty(neighbor)
            max_route_length = m;
            break;
        end
        t(m+1) = rextend(neighbor);
        k = find(t == t(m+1));
        %while m~=1 && t(m+1) == t(m-1)
        %    t(m+1) = rextend(neighbor); 
        %end
        while m~=1 && size(k, 2) > 1
           if loop > 5
               flag = 1;
               break;
           end
           t(m+1) = rextend(neighbor); 
           k = find(t == t(m+1));
           loop = loop+1;
        end
        if flag == 1
            break;
        else
            max_route_length = m+1;
        end
    end
end

% true turn patterns
% T = zeros(1, size(t, 2)-1);
% for i=1:size(t, 2)-1
%     theta1 = routes(t(i)).gsv_yaw;
%     theta2 = routes(t(i+1)).gsv_yaw;
%     T(i) = turn_pattern(theta1, theta2, threshold);
% end

end