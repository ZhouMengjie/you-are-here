% generate random routes
directory = 'test_routes/';
turn_filename = [ directory, p.dataset, '_turns_', num2str(p.T),'_' , num2str(p.threshold) ,'.mat'];
route_filename = [ directory, p.dataset, '_routes_', num2str(p.T),'.mat'];

if ~exist(directory, 'dir')
    mkdir(directory)
end

if (isfile(route_filename) || isfile(turn_filename))
    disp('warning! file not created because it already existed. If you need a new one remove old file or rename it');
else
    load(['Data/','streetlearn/',p.dataset,'.mat'],'routes');
    if strcmp(p.dataset,'wallstreet5k') || strcmp(p.dataset,'hudsonriver5k')
        load(['Data/','streetlearn/', p.dataset,'_','highwayflags','.mat'],'highway_flag');
    else
        highway_flag = zeros(1,5000);
    end

    R_init = zeros(size(routes,2),1);
    for i = 1:size(routes,2)
        R_init(i) = i;   
    end

    test_route = [];
    test_turn = [];
    while size(test_route, 1) < p.T % 500 test routes
        [t, max_route_length] = RandomRoutes(R_init, routes, p.mrl);
        if (~isempty(test_route) && sum(ismember(test_route, t, 'rows'))) || sum(highway_flag(t))% check the uniqueness 
            continue;
        else
            T = zeros(1, size(t, 2)-1);
            for i=1:size(t, 2)-1
                theta1 = routes(t(i)).gsv_yaw;
                theta2 = routes(t(i+1)).gsv_yaw;
                T(i) = turn_pattern(theta1, theta2, p.threshold);
            end
            test_route = [test_route; t];
            test_turn = [test_turn; T];
        end
    end
    save(turn_filename, 'test_turn');
    save(route_filename,'test_route');
    
end




