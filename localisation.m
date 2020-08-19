%% Load features and test routes
if strcmp(p.type, 'ES') 
    filename = fullfile(p.features_dir,p.type,p.network,p.scale,[p.type,'_',p.dataset,'.mat']);
    load(filename, 'routes');
else
    filename = fullfile(p.features_dir,p.type,p.dataset,[p.type,'_',p.dataset,'_',p.network,'.mat']);
    load(filename, 'routes');    
end

% load test routes and test turns
directory = 'test_routes/';
load([directory, p.dataset,'_turns_', num2str(p.T), '_' , num2str(p.threshold),'.mat']);
load([directory, p.dataset,'_routes_', num2str(p.T),'.mat']); 

R_init = zeros(size(routes,2),1);
for i = 1:size(routes,2)
    R_init(i) = i;   
end

ranking = zeros(p.T, p.mrl);
best_estimated_routes = {p.T};
best_estimated_top5_routes = {p.T};
dist = {p.T};

tic;
parfor_progress('searching', p.T);
for i=1:p.T
    t = test_route(i,1:p.mrl);
    T = test_turn(i,1:p.mrl-1);
        
    switch p.type
        case{'ES'}
        %% ES FEATURES
            [location, rank, best_top5_routes, route_dist] =  RouteSearching_ES(routes, p.N, p.mrl, p.threshold, R_init, t, T, p.turns, p.mnc, p.topk, p.overlap);
            dist{i} = route_dist;
        %% BSD FEATURES
        case {'BSD'}    
            [location, rank, best_top5_routes, route_dist] = RouteSearching_BSD(routes, p.N, p.mrl, p.threshold, R_init, t, T, p.turns, p.mnc, p.topk, p.overlap);
            dist{i} = route_dist;
        %% JUST TURNS
        otherwise
            [location, rank, best_top5_routes] = RouteSearching_onlyT(routes, p.mrl, R_init, t, T, p.threshold, p.topk, p.overlap);     
    end
    
    ranking(i,:) = rank;
    best_estimated_top5_routes{i} = best_top5_routes;

    parfor_progress('searching');
end

time = toc;
avg_time = time/p.T;


%% Save localization test information
path = fullfile(p.results_dir, p.dataset, num2str(p.turns));
if ~exist(path, 'dir')
    mkdir(path)
end
file_name = fullfile(path, [p.name,'.mat']);
save(file_name,'ranking','best_estimated_top5_routes');
