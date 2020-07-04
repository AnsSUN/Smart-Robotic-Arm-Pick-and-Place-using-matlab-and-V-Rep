%boxImage = imread('control.png');
sceneImage = imread('scene.png');
sceneImage_original = imread('scene.png');  %for color reference


figure;
imshow(sceneImage);hold on;
grid_size=68; %pixels

%draw grids
for i=1:29
    plot([i*grid_size,i*grid_size],[0,2045],'w.-');
    plot([0,2045],[i*grid_size,i*grid_size],'w.-');
end