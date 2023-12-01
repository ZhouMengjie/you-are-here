clc
clear all
close all

% add path 
addpath(genpath(fullfile(pwd)))

p.type = 'MES';               % Embedding space features
p.turns = false;              % Whether to use turns in the localisation process
p.topk = 1;                   % Save the topk best routes
p.results_dir = 'results/MES';% Results directory
p.network = '2dsafapolar';

datasets = {'hudsonriver5k', 'unionsquare5k', 'wallstreet5k'};
legend_text = {'HR No-Culling - 91.4%', 'US No-Culling - 96.8%', 'WS No-Culling - 94.2%','HR Culling - 91.4%', 'US Culling - 96.8%', 'WS Culling - 93.8%'};

ndatasets = length(datasets);
names = {'100%culling', '50%culling'};       % A name for the experiment
color = {'r','b',[0.4660,0.6740,0.1880]};
ax = gca;
for t = 1:2
    ax.ColorOrderIndex = 1;
    name = names{t};
    for dset_index=1:ndatasets
        dataset = datasets{dset_index};
        path = fullfile(p.results_dir, dataset, num2str(p.turns), p.network, [name,'.mat']);
        if strcmp(name, '100%culling')
            linestyle = '-';
        else
            linestyle = '--';
        end        
        load(path,'ranking');
        acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);
        
        % file_name = fullfile('exps', [dataset,'_',name,'.mat']);
        % save(file_name,'acc');

        x = 5:1:40;
        plot(ax, x, 100*acc(x), 'LineStyle', linestyle, 'LineWidth',2,'Color',color{dset_index})
        grid on
        hold on
    end
end
set(gca,'FontName','Times','FontSize',20,'FontWeight','bold');
xlabel(ax, 'Route length','FontSize',20,'FontName','Times','FontWeight','bold')
ylabel(ax, 'Top-1 Localisations (%)', 'FontSize',20,'FontName','Times','FontWeight','bold')
set(ax,'Xtick',5:5:40)
axis([5 40 60 100]) 

legend(ax, legend_text, 'location','southeast','FontName','Times','FontSize',16,'FontWeight','bold')
fig = gcf;
filename = fullfile('figures','culling.eps');
print(gcf, '-depsc', filename);



