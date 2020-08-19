clear all
addpath(genpath(fullfile(pwd)));

p.type = 'BSD';               % BSD features
p.name = '100%culling';   % A name for the experiment
p.dataset = 'wallstreet5k';   % The name of the dataset       
p.network = 'resnet18';       % The name of the network (model)

p.T = 500;                    % Number of test turns
p.mrl = 40;                   % Maximum route_length
p.threshold = 30;             % Threshold to define turns
p.turns = true;               % Whether to use turns in the localisation process
p.topk = 1;                   % Save the topk best routes
p.overlap = 5;                % Overlap criteria
p.mnc = 100;
p.N = 100*ones(1,p.mrl);         % N for culling

p.results_dir = 'results/BSD';  % Results directory
p.features_dir = 'features';  % Features directory
