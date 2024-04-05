function [avg, vec1] = Avg_ssdot(val,vec0)
% average of ssdot    
    % shift data by one cell and add the new value to the front
    vec1 = zeros(size(vec0));
    vec1(2:end) = vec0(1:end-1);
    vec1(1) = val;
    avg = nanmean(vec1);
end