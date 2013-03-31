%%
% get most possible ellipse containing the dish.
function ellipse(im)
    [w, h] = size(im);
    L = bwlabel(im, 8);% Calculating connected components 
    mx=max(max(L));
    % There will be mx connected components.Here U can give a value between 1 and mx for L or in a loop you can extract all connected components 
    % If you are using the attached car image, by giving 1,2??3 to L you can extract the number plate completely. 
    maxrank = 0;
    for id = 1:mx
        [r,c] = find(L==id);
        e = ellipsefit(c, r);
        e = rank(e, w, h);
        if maxrank < e.rank
            maxrank = e.rank;
            best = e;
            disp(e);
        end
        draw(e, 'y');
    end
    if best.good
        draw(best, 'g');
    else
        draw(best, 'r');
    end
end

%%
function e = rank(e, w, h)
    e.r_dc = 100 / dist([e.cx e.cy], [w/2 h/2]');
    e.r_sz = 16 * e.a * e.b / (w * h);
    e.r_cond = 10 / log(e.cond + 1);
    e.rank = e.r_dc * e.r_sz * e.r_cond;
    if e.r_sz > 1
        e.good = 1;
    else
        e.good = 0;
    end
end

%%
function draw(ellipse, color)
    t1 = 0:.02:pi; 
    t2 = pi:.02:2*pi; 
    z1 = exp(1i*t1); 
    z2 = exp(1i*t2); 
    z1 = (ellipse.a * real(z1) + 1i*ellipse.b*imag(z1))*exp(1i*ellipse.angle); 
    z2 = (ellipse.a * real(z2) + 1i*ellipse.b*imag(z2))*exp(1i*ellipse.angle); 
    z1=z1+ellipse.cx+ellipse.cy*1i; 
    z2=z2+ellipse.cx+ellipse.cy*1i; 
    hold on 
    plot(z1,color) 
    hold on 
    plot(z2,color);
    hold off 
end