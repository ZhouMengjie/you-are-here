% delete pano_id and gsv_coords because of the google copyright
clear all

% delete
% parameters
p.features_dir = 'features';
p.type = 'ES'; 
p.scale = 'S1';
p.network = 'v2_12';
p.dataset = 'hudsonriver5k'; % wallstreet5k, unionsquare5k

% load
filename = fullfile(p.features_dir,p.type,p.network,p.scale,[p.type,'_',p.dataset,'.mat']);
load(filename, 'routes');

p.type = 'MES';
p.network = 'dgcnn2to3'; % 2d, 2dsafapolar
filename = fullfile(p.features_dir,p.type,p.network,[p.type,'_',p.dataset,'.mat']);
load(filename);

% attach MES descriptors
for i=1:size(routes,2)
    routes(i).x = ref(i,:); % x is reference, map
    routes(i).y = qry(i,:); % y is query, pano
end


filename = fullfile(p.features_dir,p.type,p.network,[p.type,'_',p.dataset,'.mat']);
save(filename, 'routes');    

