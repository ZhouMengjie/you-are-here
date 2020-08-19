% calculte accuracy
path = fullfile(p.results_dir, p.dataset, num2str(p.turns),[p.name,'.mat']);
load(path,'ranking');

acc = sum(ranking > 0 & ranking <= p.topk, 1) / size(ranking,1);
figure
plot(100*acc);