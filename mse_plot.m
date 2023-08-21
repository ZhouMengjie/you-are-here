clc
clear all
close all

% add path 
addpath(genpath(fullfile(pwd)))

p.type = 'MES';               % Embedding space features
p.name = '50%culling';        % A name for the experiment
p.turns = false;              % Whether to use turns in the localisation process
p.topk = 1;                   % Save the topk best routes
p.results_dir = 'results/MES';% Results directory

datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'};
legend_text = {'HR Ours -91.4%', 'US Ours - 96.8%', 'WS Ours - 93.8%','HR ES - 87.2%', 'US ES - 89.0%', 'WS ES - 87.2%'};
p.network = {'dgcnn2to3','2d'};
ndatasets = length(datasets);
color = {'r','b',[0.4660,0.6740,0.1880]};
ax = gca;
for t = 1:2
    ax.ColorOrderIndex = 1;
    network = p.network{t};
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};
        path = fullfile(p.results_dir, dataset, num2str(p.turns), network, [p.name,'.mat']);
        if strcmp(network, 'dgcnn2to3')
            linestyle = '-';
        else
            linestyle = '--';
        end        
        load(path,'ranking');
        acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);
        
        % file_name = fullfile('exps', [dataset,'_',network,'.mat']);     
        % save(file_name,'acc');

        x = 5:1:40;
        plot(ax, x, 100*acc(x), 'LineStyle', linestyle, 'LineWidth',2,'Color',color{dset_index});
        grid on
        hold on
    end
end

set(gca,'FontName','Times','FontSize',20,'FontWeight','bold');
xlabel(ax, 'Route length','FontSize',20,'FontName','Times','FontWeight','bold')
ylabel(ax, 'Top-1 Localisations (%)', 'FontSize',20,'FontName','Times','FontWeight','bold')
set(ax,'Xtick',5:5:40)
axis([5 40 60 100]) 

legend(ax, legend_text, 'location', 'southeast','FontName','Times','FontSize',16,'FontWeight','bold')
fig = gcf;
filename = fullfile('figures','MSE.eps');
print(gcf, '-depsc', filename);



