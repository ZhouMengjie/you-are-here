% pick a test route for visualization
clc
clear all
close all

% choose features type
p.type = 'MES';               % Embedding space features
p.name = '50%culling';        % A name for the experiment
p.turns = false;              % Whether to use turns in the localisation process
p.topk = 1;                   % Save the topk best routes
p.results_dir = 'results/MES';% Results directory
dataset = 'unionsquare5k';
test_num = 500;
length_diff = 5;

% load MES data
network = 'dgcnn2to3';
path = fullfile(p.results_dir, dataset, num2str(p.turns), network, [p.name,'.mat']);   
load(path); 
MES_ranking = ranking;
MES_rlength = zeros(test_num,1);
for i = 1:test_num
    [~,col] = find(MES_ranking(i,:),1,'first');    
    if isempty(col)
        col = 41;
    end
    MES_rlength(i) = col;
end

% load ES data
network = '2d';
path = fullfile(p.results_dir, dataset, num2str(p.turns), network, [p.name,'.mat']);   
load(path); 
ES_ranking = ranking;
ES_rlength = zeros(test_num,1);
for i = 1:test_num
    [~,col] = find(ES_ranking(i,:),1,'first'); 
    if isempty(col)
        col = 41;
    end
    ES_rlength(i) = col;
end

% pick routes
final_routes = [];
for i=1:test_num
    diff = ES_rlength(i) - MES_rlength(i);
    if diff >= length_diff && MES_rlength(i) >=5
        final_routes = [final_routes;i,MES_rlength(i),ES_rlength(i),diff]; 
    end
end
save(['results/video/','final_routes','_',dataset,'.mat'],'final_routes');
