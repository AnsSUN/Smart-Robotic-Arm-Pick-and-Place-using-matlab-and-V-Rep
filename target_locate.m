function [WorldCenters]=target_locate()


%    1_bulb,  2_cube,  3_control, 4_speaker  5_soccer
Info=[300     600      500        500       300;    % FeaturePoints
      3       10       5         10        10;   % FeaturePoints Matched Threshold
      0.037   0.041    0.02175    0.027     0.05;    % Object Height
      255     40       80         115       210;    % Red
      210     110      180        10        210;    % Green
      255     60       210        40         210];    % Blue
Centers=[]; 

for object=1:5
    if object==1
        boxImage = imread('bulb.png');
    elseif object==2
        boxImage = imread('cube.png');
    elseif object==3
        boxImage = imread('control.png');
    elseif object==4
        boxImage = imread('speaker.png');
    elseif object==5
        boxImage = imread('soccer.png');
    end 
    matched_points_threshold=Info(2,object);
    color_reference=Info(4:6,object);
    [cluster_GeoCenter]=point_matching(boxImage,matched_points_threshold,color_reference,object);
    Centers=[Centers;cluster_GeoCenter];    %(x,y,number of FeaturePoints,object_kind)
end

Centers( ~any(Centers,2), : ) = [];  %delete wrong centers
[m,n]=size(Centers);
C=zeros(m,1);
Centers=[Centers C]  %(x,y,number of FeaturePoints,object,PairMark)

PairCounter=0;
for i=1:m
    if m==1
        break;
    end
    for j=(i+1):m
        Center_distance = sqrt ((Centers(i,1)-Centers(j,1))^2+(Centers(i,2)-Centers(j,2))^2);
        if (Center_distance<270) && (Center_distance>0)
            i_kind=Centers(i,4);
            j_kind=Centers(j,4);
            Percentage_i=Centers(i,3)/Info(1,i_kind)
            Percentage_j=Centers(j,3)/Info(1,j_kind)
            PairCounter=PairCounter+1;
%             Centers(i,5)=PairCounter;
%             Centers(j,5)=PairCounter;
            if Percentage_i>Percentage_j   %COMPARE
                Centers(j,5)=PairCounter;
            else
                Centers(j,5)=PairCounter;
            end
%
        end
    end
end

Centers( ~any(Centers,2),:)=[];


figure;
imshow('scene.png');
hold on;
plot(Centers(:,1),Centers(:,2),'rx','MarkerSize',17,'linewidth',2)  % plot the true center 

[m,n]=size(Centers);

for i=1:m
    if Centers(i,5)~=0
        plot(Centers(i,1),Centers(i,2),'bx','MarkerSize',17,'linewidth',2)  % plot the true center 
    end
end

a=3*0.169/4088;
WorldCenters=[]; %x,  y,  z,   matchedPoints,  ObjectKind  PairMark
for i=1:m
    object_kind=Centers(i,4);
    WorldCenters(i,2)=(   1.8*sqrt(3)*a*(2044-Centers(i,2))  +   1.8*0.431*sqrt(3)   )    /  (  2.231*sqrt(3)  - a*sqrt(3)*(2044-Centers(i,2))  -0.431*sqrt(3)   );
    if Centers(i,5)==1
        h=Info(3,object_kind)+0.011;
    else
        h=Info(3,object_kind);
    end
    WorldCenters(i,2)=WorldCenters(i,2)-WorldCenters(i,2)/0.6/sqrt(3)*h*3/5;  %Info(3,object_kind)=h
    WorldCenters(i,1)=(  WorldCenters(i,2)*0.0255/0.369 - 0.0255/0.369*0.431+0.1475  )*(Centers(i,1)-1022)/1022;
    WorldCenters(i,3)=0.3+h;    %add another height %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    WorldCenters(i,4:6)=Centers(i,3:5); 
end


end
