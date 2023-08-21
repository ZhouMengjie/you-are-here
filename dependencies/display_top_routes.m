function [hd] = display_top_routes(gt_x, gt_y, et1, color, marker_size)
    % estimated location
    estimated_x1 = zeros(size(et1,2),1);
    estimated_y1 = zeros(size(et1,2),1);

    for i=1:size(et1,2)
        estimated_x1(i) = gt_x(et1(i));
        estimated_y1(i) = gt_y(et1(i));   
    end
    
    hd(1) = plot(estimated_x1(:,1), estimated_y1(:,1), 'o', 'MarkerFaceColor', color,'MarkerSize', 5,'MarkerEdgeColor', color);    
    hd(2) = plot(estimated_x1(size(et1,2)), estimated_y1(size(et1,2)), 'o', 'MarkerEdgeColor', color,'MarkerSize', marker_size, 'LineWidth', 5);
end