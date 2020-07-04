function f_grippercontrol(xc,yc,zc,xt,yt,zt,alpha,beta,gamma)
vrep=remApi('remoteApi');
vrep.simxFinish(-1);% close all current connects
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection
%enter the target cs and the euler angles
sps=3; %number of steps
signalmovefinish=0;
[returnCode1,joint1]=vrep.simxGetObjectHandle(clientID,'redundantRob_target',vrep.simx_opmode_blocking);
co=[alpha/180*pi,beta/180*pi,gamma/180*pi];
[returnCode2]=vrep.simxSetObjectOrientation(clientID,joint1,-1,co,vrep.simx_opmode_blocking);
for i=1:sps
    cp=[xc+i*((xt-xc)/sps),yc+i*((yt-yc)/sps),zc+i*((zt-zc)/sps)];
    [returnCode2]=vrep.simxSetObjectPosition(clientID,joint1,-1,cp,vrep.simx_opmode_blocking);
    %[returnCode2]=vrep.simxSetObjectOrientation(clientID,joint1,-1,co,vrep.simx_opmode_blocking);
    %f_settargetorientation(alpha,beta,gamma);
    %f_settargetposition(x/sps*i,y/sps*i,1.17-i*((1.17-z)/sps));
    pause(3)
end
signalmovefinish=1;
end