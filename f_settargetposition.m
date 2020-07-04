function[returncode_settarget]=f_settargetposition(x,y,z)

vrep=remApi('remoteApi');
vrep.simxFinish(-1);% close all current connects
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection

if (clientID>-1)
    disp('Connected successful');
    
    %codes here
    cp=[x,y,z];% This is the target position, in global CS.
    [returnCode1,joint1]=vrep.simxGetObjectHandle(clientID,'redundantRob_target',vrep.simx_opmode_blocking);
    [returnCode2]=vrep.simxSetObjectPosition(clientID,joint1,-1,cp,vrep.simx_opmode_blocking);
   returncode_settarget=1;
    
    
    vrep.simxFinish(-1)
end
end
        