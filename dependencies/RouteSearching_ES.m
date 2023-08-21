function [location, rank, best_top5_routes, route_dist] = RouteSearching_ES(routes, N, max_route_length, threshold, R_init, t, T, turns_flag,min_num_candidates,topk,overlap)
R = R_init;
dist = zeros(size(routes,2),1);
rank = zeros(max_route_length,1);
best_top5_routes = {max_route_length};
route_dist = {max_route_length};

for m=1 : max_route_length
    y = routes(t(m)).y; % query
            
    if m > 1 
            if turns_flag == 1
                turn = T(m-1); 
                [R_, dist_] = Turn_filter(R, dist, turn, routes, m, threshold); % turn filter
                [R_, dist_] = Nclosest_es(y, R_, routes, dist_, N(m), min_num_candidates); % filter based on sorting
            else
                [R_, dist_] = Nclosest_es(y, R, routes, dist, N(m), min_num_candidates); % filter based on sorting
            end            
            
    else % first observation
            [R_, dist_] = Nclosest_es(y, R, routes, dist, N(m), min_num_candidates); % call dist filter 
    end
    
    if m < max_route_length
        [R, dist] = RRextend(R_, dist_, routes); 
    end
    
    % rank of the current route    
    rank(m,1) = getrank(R_, t(1:m), topk, overlap);
   
    % current best estimated route
    if size(R_, 1) > 0
        t_ = R_(1,:);
    else
        t_ = [];
    end
    route_dist{m} = dist_;
    
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