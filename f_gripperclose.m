function f_gripperclose

vrep=remApi('remoteApi');
vrep.simxFinish(-1);% close all current connects
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);% setup connection


    
     %codes here
    [returnCode1,joint1]=vrep.simxGetObjectHandle(clientID,'RG2_openCloseJoint',vrep.simx_opmode_blocking)
    [returnCode2]=vrep.simxSetJointTargetVelocity(clientID,joint1,-0.1,vrep.simx_opmode_blocking)

   
   returncode_gripperclose=1;

    
    
    vrep.simxFinish(-1)
end