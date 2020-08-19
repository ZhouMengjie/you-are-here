function R = RRextend_v2(R_, routes)
index = 1;
sz1 = size(R_,1);
sz2 = size(R_,2);
R = zeros(sz1*5,sz2+1);   % preallocate, should be large enough

for i=1:sz1
    idx = R_(i,sz2);
    neighbor = routes(idx).neighbor;

    if isempty(neighbor) % if no neighbors, delete this route
        continue;
    end
    
    for j=1:size(neighbor, 1)      
        k = find (R_(i,:) == neighbor(j));
        if size(k, 2)== 0
            R(index,:) = [R_(i,:), neighbor(j)];
            index = index+1;
        else
            continue;
        end          
    end    
end

R = R(1:index-1,:);  % shrink
end
