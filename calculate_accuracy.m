% calculte accuracy
if strcmp(p.type, 'ES') 
    path = fullfile(p.results_dir, p.dataset, num2str(p.turns),p.scale,[p.name,'.mat']);
else
    path = fullfile(p.results_dir, p.dataset, num2str(p.turns),[p.name,'.mat']);
end
load(path,'ranking');

acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);
% acc = sum(ranking(1:50,:) > 0 & ranking(1:50,:) <= p.topk, 1) / 50;

fig = figure;
plot(100*acc);
saveas(fig,[p.dataset,'_',p.type],'png');