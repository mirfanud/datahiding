img = imread('checkerboard.png');

if ( size ( img,3 ) ~= 1)
    img=rgb2gray(img);
end

imshow(img);

[h, w] = size(img);
delta = findDelta(img,1,511);
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
img_org = img;
img = img(:,map);
H = double(img);
figure;
imshow(img);


diff = zeros(h,w/2);
for i=1:w/2
    x = 2*(i-1)+1;
    y = x+1;
    diff(:,i) = abs(H(:,x)-H(:,y));
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
for i=1:h
    for j=1:w/2
        if(diff(i,j)>peak)
            diff(i,j) = diff(i,j)+1;
        end
    end
end
m = randi([0 1],capacity,1);

k = 0;
for i=1:h
    for j=1:w/2
        if(diff(i,j)==peak)            
            k = k+1;
            diff(i,j) = diff(i,j)+m(k);
        end
    end
end
S = zeros(h,w);
for i=1:h
    for j=1:w/2
        x = 2*(j-1)+1;
        y = x+1;
        if(H(i,x)>=H(i,y))
            S(i,x) = H(i,y)+diff(i,j);
            S(i,y) = H(i,y);
        else
            S(i,y) = H(i,x)+diff(i,j);
            S(i,x) = H(i,x);
        end

    end
end

[pk,mse] = psnr(img,uint8(S));
clear imap;
imap(map) = 1:length(map);
img_embed = uint8(S(:,imap));
figure
imshow(img_embed);

disp(strcat('Delta = ',num2str(delta)));
disp(strcat('Capacity = ',num2str(capacity)));
disp(strcat('PSNR = ',num2str(pk)));
disp(strcat('Peak = ',num2str(peak)));