function rank = getrank(R, gt_route, topk, overlap)
    k = min(size(R,1), topk);
    high = size(R,2);
    low = max(high - overlap + 1, 1);
    best_estimates = R(1:k,low:high);
    gt_route = gt_route(low:high);
    try
    comp = ismember(best_estimates,gt_route,'rows');
    catch
        disp('error');
    end
    isintopk = any(comp);
    if isintopk
       index = find(comp);
       rank = index(1);
    else
       rank = 0;
    end   
            
end