function [location, rank, best_top5_routes] = RouteSearching_onlyT(routes, max_route_length, R_init, t, T, threshold,topk,overlap)
R = R_init;
rank = zeros(max_route_length,1);
best_top5_routes = {max_route_length};

for m=1 : max_route_length
    if m > 1
        turn = T(m-1);
        R_ = Turn_filter_v2(R, turn, routes, m, threshold);
    else
        R_ = R;
    end
            
    if m < max_route_length
        R = RRextend_v2(R_, routes);
    end  
    
    % rank of the current route
    rank(m,1) = getrank(R_, t(1:m), topk, overlap);
    
    % current best estimated route
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        t_ = [];
    end
    
    if size(R_, 1) > 5
        top5 = R_(1:5,:);
    else
        top5 = R_;
    end
    best_top5_routes{m} = top5;
end

if ~isempty(t_)
    location = t_(1, size(t_, 2));
else 
    location = [];
end

end