function [mx_delta,mx_capacity,mx_map,mx_peak] = findDelta(img,min_val,max_val)
H = double(img);
[h, w] = size(img);
mx_capacity = 0;
for delta=min_val:max_val
    map = zeros(w,1);
    flag = zeros(w,1);
    map(1) = 1;
    flag(1) = 1;
    for i=2:length(map)
        map(i) = map(i-1)+delta;
        if(map(i)>w)
            map(i) = map(i)-w;
        end
        if(flag(map(i))==1)
            map(i) = map(i)+1;
        end
        flag(map(i)) = 1;
    end
    diff = zeros(h,w/2);
    for i=1:w/2
        x = 2*(i-1)+1;
        y = x+1;
        diff(:,i) = abs(H(:,map(x))-H(:,map(y)));
    end

    u_val = unique(diff(:));
    if length(u_val)==1
        peak = u_val;
        capacity = w*h/2;
    else
        [aa, bb] = histcounts(diff(:),unique(diff(:)));
        [capacity,ind] = max(aa);
        peak = bb(ind);
    end
    if(capacity>mx_capacity)
        mx_capacity = capacity;
        mx_delta = delta;
        mx_map = map;
        mx_peak = peak;
    end
end
