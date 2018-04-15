clear
clc

i=1;
boxImage = imread('cube.png');

sceneImage = imread('scene.png');
sceneImage = rgb2gray(sceneImage);

boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);

[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

boxPairs = matchFeatures(boxFeatures, sceneFeatures);

matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
%point_coordinates = matchedScenePoints.Location

figure;
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');


%%
%Group Data into Clusters and find the center point
% figure;
% imshow(sceneImage);
% hold on;
% 
% X=matchedScenePoints.Location;
% opts = statset('Display','iter');
% [idx,C,sumd,d,midx,info] = kmedoids(X,3,'Distance','cityblock','Options',opts);
% 
% plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',7)
% hold on
% plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',7)
% plot(C(:,1),C(:,2),'co',...
%      'MarkerSize',7,'LineWidth',1.5)
% legend('Cluster 1','Cluster 2','Medoids',...
%        'Location','NW');
% title('Cluster Assignments and Medoids');



%%
%canny dector
% I = sceneImage;
% I1=im2double(I);
% [IGradX, IGradY]= smoothing(I1);
% Iabst=abs(IGradX)+abs(IGradY);
% [theta]=computeangle(IGradX,IGradY);
% [Iabst1]=nonmaximalsupression(Iabst,theta);
% Ie=im2uint8(Iabst1);
% Tl=115;
% Th=180;
% [Ie1]=gradingedges(Ie,Tl,Th);
% [Ifinal]=connectingedge(Ie1,Tl,Th);
% theta=padarray(theta,[1 1]);
% Ifinal= Ifinal(7:end-7,7:end-7);
% Ioutput=Ifinal;
% figure;
% subplot(1,2,1);imshow(Iabst);title('origional edge');
% K = imadjust(Iabst,[0 0.4],[]);
% subplot(1,2,2);imshow(K);title('edge adjust');









