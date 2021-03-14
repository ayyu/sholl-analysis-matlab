function [dists, conns] = sholl_analysis(image, info, seed)
    % hash map to store # of connections at different distances
    dist_conn = containers.Map('KeyType','double','ValueType','double');
    
    dims = info.ImageSize;
    scales = info.PixelDimensions;
    
    % Loop through each voxel's coordinates
    for x = 1:dims(1)
        for y = 1:dims(2)
            for z = 1:dims(3)
                % get the of connections at that voxel from the image
                conns = image(x,y,z);
                % calculate Euclidean distance between current and seed voxel
                distance = ((x - seed(1))*scales(1))^2 + ...
                           ((y - seed(2))*scales(2))^2 + ...
                           ((z - seed(3))*scales(3))^2;

                if (~isKey(dist_conn, distance))
                    dist_conn(distance) = 0;
                end
                % add the number of connections to the hash map
                dist_conn(distance) = dist_conn(distance) + conns;
            end
        end
    end
    
    % take sqrt at end to save time
    dists = sqrt(cell2mat(keys(dist_conn)));
    conns = cell2mat(values(dist_conn));
end