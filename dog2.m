function dog2(imgpath)
% comparison of convolution and correlation; Laplacian and difference of
% Gaussians.

% cd to the course data directory
%
im=double(rgb2gray(imread(imgpath)));
imagesc(im);
colormap gray;
axis off;
axis image;

G=fspecial('gaussian',7,1);
imagesc(G);
colormap gray;
axis off;
axis image;
pause;

% construct a derivative of a gaussian
dGx=imfilter(G,[1 0 -1],'symmetric','conv');

surf(dGx);
pause;

imagesc(dGx);
colormap gray;
axis off;
axis image;
pause;

dBarb=imfilter(im,dGx,'symmetric','conv');
imagesc(dBarb);
axis off;
axis image;

% compare (conv (conv im, Gdx), Gdx) and (corr (corr im, Gdx), Gdx)
subplot(2,2,1)
imagesc(imfilter(imfilter(im,[0,-1,0,1,0],'symmetric','conv'),[0,-1,0,1,0],'symmetric','conv'));
axis off; axis image;
subplot(2,2,2)
imagesc(imfilter(imfilter(im,[0,-1,0,1,0],'symmetric','corr'),[0,-1,0,1,0],'symmetric','corr'));
axis off; axis image;

% with (conv (conv Gdx, Gdx), im) and (corr (corr Gdx, Gdx), im) 
% these are not the same!
subplot(2,2,3)
imagesc(imfilter(im,imfilter([0,-1,0,1,0],[0,-1,0,1,0],0,'conv'),'symmetric','conv'));
axis off; axis image;
subplot(2,2,4)
imagesc(imfilter(im,imfilter([0,-1,0,1,0],[0,-1,0,1,0],0,'corr'),'symmetric','corr'));
axis off; axis image;

%%% second derivative of Gaussian
clf
G=fspecial('gaussian',15,2);
surf(G)
imagesc(G)

d2Gx=imfilter(G,[1,-2,1],0,'conv');
imagesc(d2Gx)
axis off; axis image;
d2Gy=imfilter(G,[1,-2,1]',0,'conv');
imagesc(d2Gy)
axis off; axis image;

LG=d2Gx+d2Gy;
surf(LG)
colormap default
imagesc(LG)
axis off; axis image;
colormap gray;

%difference of Gaussians
DoG=fspecial('gaussian',15,2)-fspecial('gaussian',15,1);
imagesc(DoG)
surf(DoG)

