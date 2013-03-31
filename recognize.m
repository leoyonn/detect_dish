%%
function recognize(imagepath)
    img = imread(imagepath);
    imi = rgb2gray(img);
    im = rgb2gray(img);
    [w, h] = size(im);
    %%{
    psize = fix(20 * w / 400);
    if mod(psize, 2) ~= 1
        psize = psize + 1;
    end
    hs = fix(psize / 2);
    g = gauss(hs);
    for y = 1:h
        for x = 1:w
            im(x, y) = sub_gauss_diff(imi, x, y, w, h, hs, g);
        end
    end
    imwrite(im, [imagepath, '.1-cdog.bmp']);
    bw = im2bw(im, 0.08);
    %%}
    imwrite(bw, [imagepath, '.2-bw.bmp']);
    se = strel('disk', fix(6 * 400 / w));
    % bw = imerode(bw, se);
    % bw = imdilate(bw, se);
    bw = imclose(bw, se);
    imwrite(bw, [imagepath, '.3-close.bmp']);
    %im1=medfilt2(im0,[3 3]); 
    bw = edge(bw,'canny'); %finding edges 
    imwrite(bw, [imagepath, '.4-edge.bmp']);
    bw = imdilate(bw, strel('disk',1));
    imwrite(bw, [imagepath, '.5-dil.bmp']);
    figure;
    axis off
    box off
    imshow(bw, 'border', 'tight', 'initialmagnification', 'fit');
    ellipse(bw);
    saveas(gcf, [imagepath, '.6-ellipse.bmp']);
end

function g = gauss(halfsize)
    s1 = halfsize * halfsize / (2 * pi);
    mu = [0, 0];% 均值向量
    sigma = [s1 0; 0 s1];% 协方差矩阵
    [X,Y] = meshgrid(-halfsize:1:halfsize,-halfsize:1:halfsize);%在XOY面上，产生网格数据
    g = mvnpdf([X(:) Y(:)], mu, sigma);%求取联合概率密度，相当于Z轴
    g = reshape(g, size(X)); %将Z值对应到相应的坐标上
end

%%
function D = sub_gauss_diff(img, x, y, w, h, hs, g)
    x1 = x - hs;
    gx1 = 1;
    if x1 <= 0
        gx1 = 2 - x1;
        x1 = 1;
    end
    x2 = x + hs;
    gx2 = 2 * hs + 1;
    if x2 > w
        gx2 = 2 * hs + 1 - (x2 - w);
        x2 = w;
    end
    y1 = y - hs;
    gy1 = 1;
    if y1 <= 0
        gy1 = 2 - y1;
        y1 = 1;
    end
    y2 = y + hs;
    gy2 = 2 * hs + 1;
    if y2 > h
        gy2 = 2 * hs + 1 - (y2 - h);
        y2 = h;
    end
    subimg = img(x1:x2, y1:y2);
    subg = g(gx1:gx2, gy1:gy2);
%{
    disp([x1, x2, y1, y2]);
    disp([gx1, gx2, gy1, gy2]);
    disp(size(subimg));
    disp(size(subg));
%}
    D = fix(sum(dot(abs(single(subimg) - single(img(x, y))), subg)));
end    