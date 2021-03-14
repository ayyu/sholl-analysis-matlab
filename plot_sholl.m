function [sholl_figure, bins, conn_bins] = plot_sholl(dists, conns, bin_size)

max_bin = ceil(max(dists)/bin_size)*bin_size;
bins = 0:bin_size:max_bin;
conn_bins = zeros(1, length(bins));

% sum the connections at each distance into bins defined by bin_size
left = 1;
for bin = 1:length(bins)
    for i = left:length(dists)
        if (dists(i) > bin*bin_size)
            break;
        end
        conn_bins(bin) = conn_bins(bin) + conns(i);
        left = i;
    end
end

% do some MATLAB plotting here, or output/save DC to a file
sholl_figure = figure;
plot(bins, conn_bins);
xlabel('radius from seed (mm)');
ylabel('total connections at radius');
title('Sholl profile');