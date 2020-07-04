close all,clear all,clc
f_settargetposition(0,0.6,0.33);
f_settargetorientation(-105,0,0);
for i=1:100
    record(:,i)=f_GetGripperPosition;
    pause(0.1)
end
