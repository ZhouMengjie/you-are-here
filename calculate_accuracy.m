% calculte accuracy
switch p.type
    case {'ES'}
        path = fullfile(p.results_dir, p.dataset, num2str(p.turns), p.scale, [p.name,'.mat']);
    case {'BSD'}
        path = fullfile(p.results_dir, p.dataset, num2str(p.turns), [p.name,'.mat']);
    case {'MES'}
        path = fullfile(p.results_dir, p.dataset, num2str(p.turns), p.network, [p.name,'.mat']);
end

load(path,'ranking');

acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);

fig = figure;
plot(100*acc);
saveas(fig,[p.dataset,'_',p.type,'_',p.network,'_',p.name],'png');
