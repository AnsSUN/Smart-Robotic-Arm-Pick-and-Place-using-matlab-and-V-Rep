vrep=remApi('remoteApi');
vrep.simxFinish(-1);% close all current connects
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection
%enter the target cs and the euler angles


sps=3; %number of steps
signalmovefinish=0;
[returnCode1,joint1]=vrep.simxGetObjectHandle(clientID,'redundantRob_target',vrep.simx_opmode_blocking);
c=[-80,0,0];
co1=c(:,1)/180*pi;
co2=c(:,2)/180*pi;
co3=c(:,3)/180*pi;
co=[co1,co2,co3];
[returnCode2]=vrep.simxSetObjectOrientation(clientID,joint1,-1,co,vrep.simx_opmode_oneshot);

%vrep.simxFinish(-1)
