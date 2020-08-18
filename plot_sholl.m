[file, path] = uigetfile({'*.mat'},...
    'Select Sholl script output file');

[~, filename, ext] = fileparts(file);

% multiply distances in voxels by dimensions
distances = distances * scales(1);

% truncate trailing values under threshold in connections
threshold = 10;
lim_conn = connections;
lim_conn(lim_conn < threshold) = 0;
limits = [1 distances(find(lim_conn,1,'last')) 0 inf];

% do some MATLAB plotting here, or output/save DC to a file
% example plot code is show below
figure
xlabel('radius from seed (mm)')
ylabel('total intersections at distance')
title('Sholl profile')
hold on
plot(distances, connections)
axis(limits)
hold off
savefig([path filename])