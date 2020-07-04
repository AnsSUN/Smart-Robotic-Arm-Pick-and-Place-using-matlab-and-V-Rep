function [cluster_GeoCenter]=point_matching(boxImage,matched_points_threshold,color_reference,object)



%boxImage = imread('control.png');
sceneImage = imread('scene.png');
sceneImage_original = imread('scene.png');  %for color reference
sceneImage = rgb2gray(sceneImage);

boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);
[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

boxPairs = matchFeatures(boxFeatures, sceneFeatures);
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
%     matchedScenePoints, 'montage');
% title('Putatively Matched Points (Including Outliers)');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% we are going to divide into 30x30 grids and the pixel of each is 68 d ad             
% therefore we have 29x29 center for 田 grid, (i,left to right) (j,down to up)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% imshow(sceneImage);hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n] = size(matchedScenePoints.Location);
grid_size=68; %pixels

%draw grids
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:29
%     plot([i*grid_size,i*grid_size],[0,2045],'w.-');
%     plot([0,2045],[i*grid_size,i*grid_size],'w.-');
% end

% 
% %draw points
% for i=1:m
%     plot(matchedScenePoints.Location(i,1),matchedScenePoints.Location(i,2),'y.','MarkerSize',4)
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%count the point number of each center area
grid_center_sum=zeros(29,29);
Points_order=zeros(m,3);  % 3 columns are:(order,x,y) order=(i-1)*29+j 
for k=1:m
    i=floor(matchedScenePoints.Location(k,1)/grid_size);
    j=floor(matchedScenePoints.Location(k,2)/grid_size);
    Points_order(k,:)=[(i-1)*29+j,matchedScenePoints.Location(k,1),matchedScenePoints.Location(k,2)]; 
    grid_center_sum(i,j)=grid_center_sum(i,j)+1;
    grid_center_sum(i+1,j)=grid_center_sum(i+1,j)+1;
    grid_center_sum(i,j+1)=grid_center_sum(i,j+1)+1;
    grid_center_sum(i+1,j+1)=grid_center_sum(i+1,j+1)+1;
end
Points_order=sortrows(Points_order,1);  %sort all the matched Points in order

%choose the valid center and corresponeding weight center

center_counter=0;   %number of chosen center
for i=1:29
    for j=1:29
        if (grid_center_sum(i,j) >= matched_points_threshold)
            if center_counter==0
                choosed_center=[i,j,grid_center_sum(i,j)];
            else
                choosed_center=[choosed_center;[i,j,grid_center_sum(i,j)]];
            end
            %plot(i*grid_size,j*grid_size,'r.','MarkerSize',12); %plot
            %choosed centers  % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            center_counter=center_counter+1;
        end
    end
end

cluster=zeros(10,50,3);  %10 for the max number for same object, 50 for max mathed centers
i=1;
while 1  
    point_num_orgin=nnz(cluster(i,:,:))/3;  %original number of centers in cluster
    point_num=point_num_orgin;
    if point_num==0   %empty
        for k=1:center_counter
            if choosed_center(k,1)~=0 
               point_num=point_num+1;
               cluster(i,1,:)=choosed_center(k,:); %assign first center
               choosed_center(k,:)=[0,0,0]; %clear 
               break;
            end
        end
    else   %not empty
        for j=1:point_num
            for k=1:center_counter
                distance=abs(cluster(i,j,1)-choosed_center(k,1))+abs(cluster(i,j,2)-choosed_center(k,2));%x,y distance
                if distance<=4  %diagnoal of two grids as the distance
                    point_num=point_num+1;
                    cluster(i,point_num,:)=choosed_center(k,:); %assign new center
                    choosed_center(k,:)=[0,0,0]; %clear
                end
            end                
        end   
    end
    
    if nnz(choosed_center(:,:))==0  %no center left, then break
        break;
    end
    if point_num==point_num_orgin
        i=i+1; %new cluster
    end
end
cluster_number=i;


color_sample=zeros(cluster_number,48,3);   % 12 sample dots, 3RGB
[m2,n2]=size(boxPairs); %number of all matched points
for i=1:cluster_number
    o=0;
    for j=1:nnz(cluster(i,:,:))/3 %number of points in cluster
        order=(cluster(i,j,1)-1)*29+cluster(i,j,2);
        for k=1:m2           
            if (order==Points_order(k,1))||(order==(Points_order(k,1)+1))||(order==(Points_order(k,1)+29))||(order==(Points_order(k,1)+30))  %each point belongs to four corner centers
                o=o+1;
                areaPoints(i,o,:)=[Points_order(k,1) Points_order(k,2) Points_order(k,3)];
            end
        end
    end

    length=nnz(areaPoints(i,:,:))/3;
    if length<40  %fail safe
        fprintf('failed')
        length
        continue;
    end
    
    try
          k = convhull(areaPoints(i,1:length,2)',areaPoints(i,1:length,3)');
    catch 
           continue%假如上面的没法执行则执行continue,到下个循环
    end
    
    %plot(areaPoints(i,k,2)',areaPoints(i,k,3)','r-')  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [length_k,n]=size(k);
    sort_xy=zeros(length_k,2);
    sort_xy(:,1)=areaPoints(i,k,2)';
    sort_xy(:,2)=areaPoints(i,k,3)';
    x_pick=sortrows(sort_xy,1);
    y_pick=sortrows(sort_xy,2);
    cluster_GeoCenter(i,1)=(x_pick(1,1)+x_pick(length_k,1))/2;  % x of the center
    cluster_GeoCenter(i,2)=(y_pick(1,2)+y_pick(length_k,2))/2;  % x of the center
    cluster_GeoCenter(i,3)=length;  %number of feature points in each cluster
    cluster_GeoCenter(i,4)=object;  %assign the object kind to center
    %plot(cluster_GeoCenter(i,1),cluster_GeoCenter(i,2),'wx','MarkerSize',17,'linewidth',2)
    color_sample(i,:,:)=[sceneImage_original(round(cluster_GeoCenter(i,2))+10,round(cluster_GeoCenter(i,1)),:);   % color samples
                       sceneImage_original(round(cluster_GeoCenter(i,2))-10,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)+10;
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)-10;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+40,round(cluster_GeoCenter(i,1)),:);   % color samples
                       sceneImage_original(round(cluster_GeoCenter(i,2))-40,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)-40;
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)+40;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+20,round(cluster_GeoCenter(i,1)),:);   % color samples
                       sceneImage_original(round(cluster_GeoCenter(i,2))-20,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)+20;
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)-20;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+10,round(cluster_GeoCenter(i,1)),:)+10;   % color samples
                       sceneImage_original(round(cluster_GeoCenter(i,2))-10,round(cluster_GeoCenter(i,1)),:)+10;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+10,round(cluster_GeoCenter(i,1)),:)-10;
                       sceneImage_original(round(cluster_GeoCenter(i,2))-10,round(cluster_GeoCenter(i,1)),:)-10; 
                       sceneImage_original(round(cluster_GeoCenter(i,2))+60,round(cluster_GeoCenter(i,1)),:);   
                       sceneImage_original(round(cluster_GeoCenter(i,2))-60,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)+60;
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)-60;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+30,round(cluster_GeoCenter(i,1)),:)+30;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+50,round(cluster_GeoCenter(i,1)),:)+30;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+30,round(cluster_GeoCenter(i,1)),:)-50;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+50,round(cluster_GeoCenter(i,1)),:)-30;   
                       sceneImage_original(round(cluster_GeoCenter(i,2))-50,round(cluster_GeoCenter(i,1)),:)+30;
                       sceneImage_original(round(cluster_GeoCenter(i,2))-30,round(cluster_GeoCenter(i,1)),:)+50;
                       sceneImage_original(round(cluster_GeoCenter(i,2))-30,round(cluster_GeoCenter(i,1)),:)-50;
                       sceneImage_original(round(cluster_GeoCenter(i,2))-50,round(cluster_GeoCenter(i,1)),:)-30;   
                       sceneImage_original(round(cluster_GeoCenter(i,2))-100,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)+100;
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)-100;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+100,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2))-70,round(cluster_GeoCenter(i,1)),:)+70;
                       sceneImage_original(round(cluster_GeoCenter(i,2))-70,round(cluster_GeoCenter(i,1)),:)-70;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+70,round(cluster_GeoCenter(i,1)),:)+70;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+70,round(cluster_GeoCenter(i,1)),:)-70;
                       
                       sceneImage_original(round(cluster_GeoCenter(i,2))-5,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)+5;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+5,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)-5;   
                       sceneImage_original(round(cluster_GeoCenter(i,2))-120,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)+120;
                       sceneImage_original(round(cluster_GeoCenter(i,2)),round(cluster_GeoCenter(i,1)),:)-120;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+120,round(cluster_GeoCenter(i,1)),:);
                       sceneImage_original(round(cluster_GeoCenter(i,2))-40,round(cluster_GeoCenter(i,1)),:)+40;
                       sceneImage_original(round(cluster_GeoCenter(i,2))-40,round(cluster_GeoCenter(i,1)),:)-40;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+40,round(cluster_GeoCenter(i,1)),:)+40;
                       sceneImage_original(round(cluster_GeoCenter(i,2))+40,round(cluster_GeoCenter(i,1)),:)-40 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                       ];
end

%ues color sample find true cluster center
for i=1:cluster_number
    color_counter=0;
    for j=1:12
        distance=abs(color_reference(1,1)- color_sample(i,j,1))+abs(color_reference(2,1)- color_sample(i,j,2))+abs(color_reference(3,1)- color_sample(i,j,3));
        if distance<=42   %reasonable color range
            color_counter=color_counter+1;
            continue;
        end          
    end 
    if color_counter==0
        cluster_GeoCenter(i,:)=[0 0 0 0]; %wrong center, clear 
    else
        fprintf('color sample failed\n')
        %plot(cluster_GeoCenter(i,1),cluster_GeoCenter(i,2),'rx','MarkerSize',17,'linewidth',2)  % plot the true center 
    end
end
 






end







