clc;
clear all;

% add path 
addpath(genpath(fullfile(pwd)))

p.type = 'ES';                % Embedding space features
p.name = '100%culling';       % A name for the experiment
p.dataset = 'unionsquare5k';   % The name of the dataset       
p.network = 'v2_12';          % The name of the network (model)

p.T = 500;                    % Number of test turns
p.mrl = 40;                   % Maximum route_length
p.threshold = 30;
p.turns = false;              % Whether to use turns in the localisation process
p.topk = 1;                   % Save the topk best routes
p.overlap = 5;                % Overlap criteria
p.N = 100*ones(1,p.mrl);      % N for culling
p.mnc = 100;                  % minimun number of candidate routes to concerve when culling
p.scale = 'S1';               % Scale {S1,S2}  

p.results_dir = 'results/ES';  % Results directory
p.features_dir = 'features';   % Features directory


