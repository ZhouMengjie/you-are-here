% delete pano_id and gsv_coords because of the google copyright
clear all

% delete
% parameters
p.features_dir = 'features';
p.type = 'BSD'; 
p.scale = 'S2';
p.network = 'alexnet';
p.dataset = 'hudsonriver5k';

% load
if strcmp(p.type, 'ES') 
    filename = fullfile(p.features_dir,p.type,p.network,p.scale,[p.type,'_',p.dataset,'.mat']);
    load(filename, 'routes');
else
    filename = fullfile(p.features_dir,p.type,p.dataset,[p.type,'_',p.dataset,'_',p.network,'.mat']);
    load(filename, 'routes');    
end

% remove and save
routes = rmfield(routes, 'id');
routes = rmfield(routes, 'gsv_coords');

if strcmp(p.type, 'ES') 
    filename = fullfile(p.features_dir,p.type,p.network,p.scale,[p.type,'_',p.dataset,'.mat']);
    save(filename, 'routes');
else
    filename = fullfile(p.features_dir,p.type,p.dataset,[p.type,'_',p.dataset,'_',p.network,'.mat']);
    save(filename, 'routes');    
end

