function jdg(xc, yc, a, b, angle, color) 
% ª≠∏ˆÕ÷‘∞) 
% (xc,yc) is the position of center 
% a is long radio 
% b is short radio 
% k is the position of the angle 
% Example: 
% jdg(0,0,3,5,pi/6) 
t1=0:.02:pi; 
t2=pi:.02:2*pi; 
z1=exp(1i*t1); 
z2=exp(1i*t2); 
z1=(a*real(z1)+1i*b*imag(z1))*exp(1i*angle); 
z2=(a*real(z2)+1i*b*imag(z2))*exp(1i*angle); 
z1=z1+xc+yc*1i; 
z2=z2+xc+yc*1i; 
hold on 
plot(z1,color) 
hold on 
plot(z2,color) 
hold off 