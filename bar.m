clc
clear all
close all

% add path 
addpath(genpath(fullfile(pwd)))

p.name = '50%culling';        % A name for the experiment
p.turns = false;              % Whether to use turns in the localisation process
p.topk = 1;                   % Save the topk best routes

dataset = 'wallstreet5k';
groups = 8;
range = 5:5:20;
data = zeros(size(range,2),3); 

%% load ranking using 2D+2.5D
p.results_dir = 'results/MES';  % Results directory
p.type = 'MES';
p.network = 'dgcnn2to3';
path = fullfile(p.results_dir, dataset, num2str(p.turns), p.network, [p.name,'.mat']);
load(path,'ranking');
acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);
col = acc(1,range)';
data(:,3) = col;


%% load ranking using 2D
p.results_dir = 'results/MES';  % Results directory
p.type = 'MES';
p.network = '2dsafapolar';
path = fullfile(p.results_dir, dataset, num2str(p.turns), p.network, [p.name,'.mat']);
load(path,'ranking');
acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);
col = acc(1,range)';
data(:,2) = col;

p.results_dir = 'results/MES';  % Results directory
p.type = 'MES';
p.network = '2d';
path = fullfile(p.results_dir, dataset, num2str(p.turns), p.network, [p.name,'.mat']);
load(path,'ranking');
acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);
col = acc(1,range)';
data(:,1) = col;

file_name = fullfile('exps', ['data.mat']);
save(file_name,'data');

data = 100 * data;

%% Make plot
b = bar(range, data, 'FaceColor','flat','EdgeColor',[1 1 1]);
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';
b(3).FaceColor = [0.4660,0.6740,0.1880];

set(gca,'FontName','Times','FontSize',20,'FontWeight','bold');
xlabel('Route length', 'FontName', 'Times','FontSize',20,'FontName','Times','FontWeight','bold')
ylabel('Top-1 Localisations (%)', 'FontName', 'Times', 'FontSize',20,'FontName','Times','FontWeight','bold')
grid on 
ax = gca;
set(ax,'Ytick',60:10:100)
ylim([60,100]);
legend({'ES', 'SAFA-Pol', 'Ours'}, 'FontName', 'Times', 'Location', 'northwest','FontSize',16,'FontWeight','bold')
filename = fullfile('figures', 'bars.eps');
print(gcf, '-depsc', filename);


