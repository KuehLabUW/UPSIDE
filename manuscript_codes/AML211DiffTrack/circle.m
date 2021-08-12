function image = circle(image,x,y,r)
for k=r-2:r+2
    for th=0:pi/10000:2*pi;
        x1 = k * cos(th) + x;
        y1 = k * sin(th) + y;
        i=abs(floor(x1));
        j=abs(floor(y1));
        if((~i==0)&&(~j==0))
        image(i,j,1)=0;
        %image(i,j,2)=0;
        %image(i,j,3)=0;
        end
    end
end