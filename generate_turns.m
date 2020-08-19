% generate turn patterns
load([ 'test_routes/', p.dataset,'_routes_', num2str(p.T),'.mat']);
turn_filename = [ 'test_routes/', p.dataset,'_turns_', num2str(p.T),'_' , num2str(p.threshold) ,'.mat'];

load(['Data/','streetlearn/', p.dataset,'.mat'],'routes');

test_turn = [];
for i=1:size(test_route,1)
    t = test_route(i,:);
    % true turn patterns
    T = zeros(1, size(t, 2)-1);
    for j=1:size(t, 2)-1
        theta1 = routes(t(j)).gsv_yaw;
        theta2 = routes(t(j+1)).gsv_yaw;
        T(j) = turn_pattern(theta1, theta2, p.threshold);
    end
    test_turn = [test_turn; T];
end
save(turn_filename, 'test_turn');
