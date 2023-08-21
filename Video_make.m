% generate video
clc
clear all;
close all;

% Add repository path
path =  fullfile(pwd);
addpath(genpath(path)); 

% Configuration
p.type = 'MES';                 % Embedding space features
p.name = '50%culling';          % A name for the experiment
p.turns = false;                % Whether to use turns in the localisation process
p.topk = 1;                     % Save the topk best routes
p.results_dir = 'results/MES';  % Results directory
p.features_dir = 'features';
dataset = 'unionsquare5k';
test_num = 500;
city = 'manhattan';
loops = 40;

load(['results/video/','final_routes','_',dataset,'.mat'],'final_routes');
% k = randi([1,length(final_routes)]);
% route_index = final_routes(k,1);
route_index = 486; % 413, 267
k = find(final_routes(:,1) == route_index);
disp(route_index);
successful_route_length_mes = final_routes(k,2); % successfully localised length for es
successful_route_length_es = final_routes(k,3);% successfully localised length for bsd

% load testing routes and turn information
load(['test_routes/',dataset,'_routes_', num2str(test_num),'.mat']); 

% Load ES features and best estimated routes
network = '2donly';
path = fullfile(p.results_dir, dataset, num2str(p.turns), network, [p.name,'.mat']);   
load(path,'best_estimated_top5_routes'); 
es_best = best_estimated_top5_routes;

% Load ES features
filename = fullfile(p.features_dir,p.type,network,[p.type,'_',dataset,'.mat']);
load(filename,'routes');
es_routes = routes;


% Load MES best estimated routes
network = 'dgcnnpolar';
path = fullfile(p.results_dir, dataset, num2str(p.turns), network, [p.name,'.mat']);   
load(path,'best_estimated_top5_routes'); 
mes_best = best_estimated_top5_routes;

% Load MES features
filename = fullfile(p.features_dir,p.type,network,[p.type,'_',dataset,'.mat']);
load(filename,'routes');
mes_routes = routes;

% Find boundaries limits
file_id = fopen(['Data/',dataset,'.csv']);
coords = textscan(file_id, '%s%f%f%f%s', 'Delimiter', ',' );
gt_x = coords{1,3};
gt_y = coords{1,2};
limits = [min(coords{1,3}) max(coords{1,3}) min(coords{1,2}) max(coords{1,2})];
range_x = abs(limits(1) - limits(2));
range_y = abs(limits(3) - limits(4));
fclose(file_id);

% Create the map
map = Map(limits, [],[],-1);
hold on;

set(gca,'xtick',[],'xticklabel',[]);
set(gca,'ytick',[],'yticklabel',[]);
set(gca,'Visible','off')

F(loops) = struct('cdata',[],'colormap',[]);
parfor_progress('searching', loops);

save_for_vis = zeros(3,40);
for key_frame = 1:loops    
    % display the ground truth
    gt = test_route(route_index,1:key_frame);
    
    % true location
    true_x1 = zeros(key_frame,1);
    true_y1 = zeros(key_frame,1);
    
    for i=1:key_frame
        true_x1(i) = gt_x(gt(i));
        true_y1(i) = gt_y(gt(i));
    end
    
    hd(1) = plot(true_x1(:,1), true_y1(:,1), '*', 'MarkerFaceColor', 'r','MarkerSize', 5, 'MarkerEdgeColor','r');
    hd(2) = plot(true_x1(key_frame), true_y1(key_frame), 'o', 'MarkerEdgeColor', 'r','MarkerSize', 15, 'LineWidth', 5);
    
    % display the best estimated route
    es_estimates = es_best{1, route_index}{1,key_frame}(1,:);
    mes_estimates = mes_best{1, route_index}{1,key_frame}(1,:);
  
    eshd = display_top_routes(gt_x, gt_y, es_estimates, 'b', 20);
    meshd = display_top_routes(gt_x, gt_y, mes_estimates, 'g', 25); 
    txhd = text(true_x1(key_frame) + 0.0005, true_y1(key_frame)+ 0.0005, num2str(key_frame),'FontSize',15);
    
    if key_frame < 2
        lgd = legend([hd(1) eshd(1) meshd(1)], ['Ground Truth',' (Route Length = ',num2str(key_frame),')'], ['ES',' (Successfully Localized at step ',num2str(successful_route_length_es),')'], ['Ours',' (Successfully Localized at step ',num2str(successful_route_length_mes),')'],'Location', 'northeast');
        position = lgd.Position;
    else
        lgd = legend([hd(1) eshd(1) meshd(1)], ['Ground Truth',' (Route Length = ',num2str(key_frame),')'], ['ES',' (Successfully Localized at step ',num2str(successful_route_length_es),')'], ['Ours',' (Successfully Localized at step ',num2str(successful_route_length_mes),')'],'Location', position);
    end

    F(key_frame) = getframe(map.ax);  
    if key_frame ~= loops
        delete(eshd);
        delete(meshd);
        delete(hd(2)); % delete gt circle
        delete(txhd);
    end

    save_for_vis(1,key_frame) = test_route(route_index,key_frame);
    save_for_vis(2,key_frame) = es_best{1, route_index}{1,key_frame}(1,key_frame);
    save_for_vis(3,key_frame) = mes_best{1, route_index}{1,key_frame}(1,key_frame);
    parfor_progress('searching');
end

name = [dataset, '_', num2str(route_index),'.avi'];
   
v = VideoWriter(name, 'Motion JPEG AVI');
v.Quality = 95;
v.FrameRate = 1; % smaller, slower
open(v)
writeVideo(v,F)
close(v)

save(['us_vis','.mat'],'save_for_vis');


