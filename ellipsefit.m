%%
%ELLIPSEFIT Stable Direct Least Squares Ellipse Fit to Data. 
% [Xc,Yc,A,b,angle,p]=ELLIPSEFIT(X,Y) finds the least squares ellipse that 
% best fits the data in X and Y. X and Y must have at least 5 data points. 
% Xc and Yc are the x- and y-axis center of the ellipse respectively. 
% A and b are the major and minor axis of the ellipse respectively. 
% angle is the radian angle of the major axis with respect to the x-axis. 
% p is a vector containing the general conic parameters of the ellipse. 
% The conic representation of the ellipse is given by: 
% 
% p(1)*x^2 + p(2)*x*y + p(3)*y^2 + p(4)*x + p(5)*y + p(6) = 0 
% 
% S=ELLIPSEFIT(X,Y) returns the output data in a structure with field names 
% equal to the variable names given above, e.g., S.Xc, S.Yc, S.A, S.b, 
% S.angle and S.p 
% 
% Reference: R. Halif and J. Flusser, "Numerically Stable Direct Least 
% Squares FItting of Ellipses," Department of Software Engineering, Charles 
% University, Czech Republic, 2000. 
 
% Conversion from conic to conventional ellipse equation inspired by 
% fit_ellipse.m on MATLAB Central 
 
% D.C. Hanselman, University of Maine, Orono, ME 04469 
% Mastering MATLAB 7 
% 2005-02-28 
% Rotation angle fixed 2005-08-09 
 
%-------------------------------------------------------------------------- 
function [varargout]=ellipsefit(x,y) 
x=x(:); % convert data to column vectors 
y=y(:); 
if numel(x)~=numel(y) || numel(x)<5 
   error('X and Y Must be the Same Length and Contain at Least 5 Values.') 
end 
 
D1=[x.*x x.*y y.*y]; % quadratic terms 
D2=[x y ones(size(x))]; % linear terms 
S1=D1'*D1; 
S2=D1'*D2; 
 
[Q2,R2]=qr(D2,0); 
c = condest(R2);
ellipse.cond = c;
if c > 1.0e10 
   warning('ellipsefit',... 
      'Data is Poorly Conditioned and May Not Represent an Ellipse.') 
end 
T=-R2\(R2'\S2'); % -inv(S3) * S2' 
 
M=S1+S2*T; 
CinvM=[M(3,:)/2; -M(2,:); M(1,:)/2]; 
[V,na]=eig(CinvM); 
c=4*V(1,:).*V(3,:) - V(2,:).^2; 
A1=V(:,c>0); 
p=[A1; T*A1]; 
 
% correct signs if needed 
p=sign(p(1))*p; 
 
angle=atan(p(2)/(p(3)-p(1)))/2; 
c=cos(angle); 
s=sin(angle); 
 
% rotate the ellipse parallel to x-axis 
Pr=zeros(6,1); 
Pr(1)=p(1)*c*c - p(2)*c*s + p(3)*s*s; 
Pr(2)=2*(p(1)-p(3))*c*s + (c^2-s^2)*p(2); 
Pr(3)=p(1)*s*s + p(2)*s*c + p(3)*c*c; 
Pr(4)=p(4)*c - p(5)*s; 
Pr(5)=p(4)*s + p(5)*c; 
Pr(6)=p(6); 
 
% extract other data 
xc_yc=[c s;-s c]*[-Pr(4)/(2*Pr(1));-Pr(5)/(2*Pr(3))]; 
cx=xc_yc(1); 
cy=xc_yc(2); 
F=-Pr(6) + Pr(4)^2/(4*Pr(1)) + Pr(5)^2/(4*Pr(3)); 
ab = sqrt(F./Pr(1:2:3)); 
a = ab(1); 
b = ab(2); 
angle = -angle; 
if a < b % x-axis not major axis, so rotate it pi/2 
   angle = angle - sign(angle) * pi / 2; 
   a = ab(2); 
   b = ab(1); 
end 
ellipse.cx = cx; 
ellipse.cy = cy; 
ellipse.a = a; 
ellipse.b = b; 
ellipse.angle = angle;
ellipse.p = p;
if nargout == 1 
   varargout{1} = ellipse; 
else 
   outcell = struct2cell(S); 
   varargout = outcell(1:nargout); 
end 
 