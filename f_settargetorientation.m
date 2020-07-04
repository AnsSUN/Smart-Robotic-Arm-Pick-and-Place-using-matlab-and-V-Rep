function[returncode_setorientation]=f_settargetorientation(alpha,beta,gamma)

vrep=remApi('remoteApi');
vrep.simxFinish(-1);% close all current connects
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection

if (clientID>-1)
    disp('Connected successful');
    
    %codes here
    co=[alpha,beta,gamma];% This is the target position, in global CS.
    [returnCode1,joint1]=vrep.simxGetObjectHandle(clientID,'redundantRob_target',vrep.simx_opmode_blocking);
    [returnCode2]=vrep.simxSetObjectOrientation(clientID,joint1,-1,co,vrep.simx_opmode_blocking);
    %[number returnCode]=simxSetObjectOrientation(number clientID,number objectHandle,number relativeToObjectHandle,array eulerAngles,number operationMode)
   returncode_setorientation=1;

    
    
    vrep.simxFinish(-1)
end
end
% This function is to set the target orientation, to use it, three euler
% angle will be need to input.
%The z-axis point at the forward of the gripper, the x-axis point from on
%finger to anthor.