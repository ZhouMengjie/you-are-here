clc;
clear all;

% add path 
addpath(genpath(fullfile(pwd)))

p.type = 'MES';               % Embedding space features
p.name = '100%culling';       % A name for the experiment
p.dataset = 'unionsquare5k';  % The name of the dataset 
p.network = '2dsafapolar';             % The name of the network (model), MES:2d, 2dsafapolar, dgcnn2to3

p.T = 500;                    % Number of test turns
p.mrl = 40;                   % Maximum route_length
p.threshold = 30;
p.turns = false;              % Whether to use turns in the localisation process
p.topk = 1;                   % Save the topk best routes
p.overlap = 5;                % Overlap criteria
p.N = 100*ones(1,p.mrl);      % N for culling
p.mnc = 100;                  % minimun number of candidate routes to concerve when culling

p.results_dir = 'results/MES'; % Results directory
p.features_dir = 'features';   % Features directory


