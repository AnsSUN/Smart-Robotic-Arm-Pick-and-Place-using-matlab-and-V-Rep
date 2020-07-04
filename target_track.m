function [WorldCenters]=target_track()

I=imread('scene_2.png');
BW = im2bw(I, 0.995);


[a,b,c]=size(BW);
red=0;
blue=0;
black=0;
white=0;
for i=1:a
    for j=1:b
        if BW(i,j)==1
            
            white=white+1;
        end
 
    end
end

total=red+white+blue+black;
percentage=total/(a*b);  %  0.0085 to 0.25m distance
P=percentage/0.00845;

try
    %call imfindcircles
    [c,r] = imfindcircles(BW,[10,100]);
    %display detected circles
    imshow(BW);
    viscircles(c,r);
    hold on;
    plot(10,300,'rx')
    xi=c(1,1);
    yi=c(1,2);

    syms zw 
    % (xw-0.3)^2+(yw-0.2)^2+(zw-1)^2-P/16=0;
    % (1.05*(1-zw)/0.25)=L;
    % (xw-(0.3-L/2))/L-xi/1024=0;
    % ((0.2+L/2)-yw)/L-yi/1024=0;

    %zw=solve('(a1^2+a2^2+1)*zw^2+(2*a1*b1+2*a2*b2+2)*zw+(b1^2+b2^2+1)')

    a1=1.05*(xi/1024-1/2);
    a2=1.05*(1/2-yi/1024);
    zw = 1-sqrt(1/16/P/(a1^2+a2^2+1));
    xw=a1*(1-zw)+0.3;
    yw=a2*(1-zw)+0.2;
    WorldCenters=[xw yw zw 0];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
catch
    WorldCenters=[0 0 0 0];
end
    
end



