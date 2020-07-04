function [GripperStatus]=f_GetGripperStatus

%if it return 1, gripper is open, if it return 2, gripper is closed, if it
%return 3, gripper is grabing something
vrep=remApi('remoteApi');
vrep.simxFinish(-1);% close all current connects
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection


    
     %codes here
    [returnCode1,joint1]=vrep.simxGetObjectHandle(clientID,'RG2_leftJoint0',vrep.simx_opmode_blocking);
    %[returnCode9,anglejoint1]=vrep.simxGetJointPosition(clientID,joint1,vrep.simx_opmode_oneshot);
    for i=1:5
    [returnCode10,anglejoint1]=vrep.simxGetJointPosition(clientID,joint1,vrep.simx_opmode_blocking);
    angle=anglejoint1/pi*180;
    end
    if angle<-35
        GripperStatus=1;
    elseif angle>20
        GripperStatus=2;
    else
        GripperStatus=3;
    end

   

    
    
    vrep.simxFinish(-1)
end