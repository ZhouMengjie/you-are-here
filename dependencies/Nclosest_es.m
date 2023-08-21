function [R_, dist_] = Nclosest_es(y, R, routes, dist, N, min_num_candidates)
sz1 = size(R, 1);
sz2 = size(R, 2);
for i=1:sz1      
    k = R(i,sz2);
    x = routes(k).x; % reference
    v = y - x;
    dist(i,1) = dist(i,1) + sqrt(v*v');
end

% criteria: sort, find the k nearest neighbors
[~, I] = sort(dist);

ncandidates = size(I,1); % This is in fact number of candidate routes

if ncandidates > min_num_candidates
    p = floor(ncandidates/100*N);
else
    p = ncandidates;
end

I = I(1:p,1);    
R_ = R(I,:);
dist_ = dist(I,1);

end
