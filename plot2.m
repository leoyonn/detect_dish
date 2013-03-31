function p = plot2(hs) 
s1 = hs * hs / (2 * pi);
mu = [0, 0];% ��ֵ����
sigma = [s1 0; 0 s1];% Э�������
[X,Y]=meshgrid(-hs:1:hs,-hs:1:hs);%��XOY���ϣ�������������
p=mvnpdf([X(:) Y(:)], mu, sigma);%��ȡ���ϸ����ܶȣ��൱��Z��
p=reshape(p,size(X));%��Zֵ��Ӧ����Ӧ��������
disp(p);
figure
set(gcf,'Position',get(gcf,'Position').*[1 1 1.3 1])

subplot(2,3,[1 2 4 5])
surf(X,Y,p),axis tight,title('��ά��̬�ֲ�ͼ')

subplot(2,3,3)
surf(X,Y,p),view(2),axis tight,title('��XOY���ϵ�ͶӰ')
subplot(2,3,6)
surf(X,Y,p),view([0 0]),axis tight,title('��XOZ���ϵ�ͶӰ')
